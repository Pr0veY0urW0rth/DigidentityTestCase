//
//  APIHelper.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 14.07.2025.
//

import OSLog

/// API helper protocol.
/// Makes requests generic and reusable.
protocol APIHelper {
    /// Request to remote server.
    /// - Parameter endpoint: Required `Endpoint` parameter for endpoint in order to make get
    /// request to remote server. Check out ``Endpoint`` for more information.
    ///
    /// - Returns: Any type that conforms to `Decodable` protocol.
    ///
    /// - Throws: Throws ``APIError`` on failure.
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}

/// Extension of ``APIHelper`` protocol for simplifing requests.
/// Removes necessity of declaring return types or providing body.
extension APIHelper {
    func request(endpoint: Endpoint) async throws {
        let _: EmptyResponse = try await request(endpoint: endpoint)
    }
}

final class APIHelperImpl: APIHelper {
    private let interceptors: [RequestInterceptor]
    let urlSession: URLSession
    init(interceptors: [RequestInterceptor] = []) {
        let cookieStorage = HTTPCookieStorage.shared

        let config = URLSessionConfiguration.default
        config.httpCookieStorage = cookieStorage
        config.httpShouldSetCookies = true

        self.urlSession = URLSession(configuration: config)
        self.interceptors = interceptors
    }

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        var request = try await createRequest(
            path: endpoint.path,
            method: endpoint.method.rawValue,
            body: endpoint.body,
            queryItems: endpoint.queryItems
        )

        for interceptor in interceptors {
            request = try interceptor.intercept(request)
        }

        return try await performRequest(request: request)
    }

    /// Function that helpes to create requests based on parameters list.
    /// Needed for getting rid of code duplication.
    ///
    /// - Parameters:
    ///   - path: Required `String` parameter. Defines url endpoint for request.
    ///   - method: Required `String` parameter. Defines which method would be called when making
    /// a request to remote server.
    ///   - body: Optional `Data` parameter. Defines what would be send in the body of the request.
    ///   - queryItems: A list of provided `URLQueryItem`s. Defines which query items should be used within requests.
    ///
    /// - Returns: An instance of `URLRequest` request which was made with provided parameters.
    /// - Throws: Throws ``APIError`` on failure of creating url.
    private func createRequest(path: String, method: String, body: Data? = nil,     queryItems: [URLQueryItem] = [])
        async throws -> URLRequest
    {
        
        guard var components = URLComponents(string: AppConfig.apiURL + path) else {
            Logger.network.error(
                "\(String(describing: APIError.invalidURL.localizedDescription))"
            )
            throw APIError.invalidURL
            }

            if !queryItems.isEmpty {
                components.queryItems = queryItems
            }

            guard let fullURL = components.url else {
                Logger.network.error(
                    "\(String(describing: APIError.invalidURL.localizedDescription))"
                )
                throw APIError.invalidURL
                
            }
        var request = URLRequest(url: fullURL)

        request.httpMethod = method
        request.httpBody = body

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    /// Function that helpes to perform requests.
    /// Needed for getting rid of code duplication.
    ///
    /// - Parameters:
    ///   - request: Required `URLRequest` parameter. Defines request that would be made.
    ///
    /// - Returns: Any type that conforms to `Decodable` protocol.
    /// - Throws: Throws ``APIError`` on failure of performing request.
    private func performRequest<T: Decodable>(request: URLRequest) async throws
        -> T
    {
        logRequest(request)

        let (data, response) = try await urlSession.data(for: request)

        logResponse(response, data: data, error: nil)

        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.network.error(
                "\(String(describing: APIError.failedToGetData.localizedDescription))"
            )

            throw APIError.failedToGetData
        }

        guard httpResponse.statusCode != 400 else {
            Logger.network.error(
                "\(String(describing: APIError.validationError.localizedDescription))"
            )

            throw APIError.validationError
        }

        guard httpResponse.statusCode != 401 else {
            Logger.network.error(
                "\(String(describing: APIError.unauthorized.localizedDescription))"
            )

            throw APIError.unauthorized
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            Logger.network.error(
                "\(String(describing: APIError.serverError.localizedDescription))"
            )
            Logger.network.error("Error is \(httpResponse.description)")
            throw APIError.serverError
        }

        guard !data.isEmpty else {
            Logger.network.error(
                "\(String(describing: APIError.noData.localizedDescription).utf8)"
            )
            throw APIError.noData
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            Logger.network.error("Decoding error is \(decodingError)")
            throw APIError.decodingFailed
        } catch {
            Logger.network.error("Unknown error is \(error)")
            throw APIError.unknown
        }
    }

    /// Function that helpes to log created requests.
    /// Provides full description of request when logging.
    ///
    /// - Parameter request: Required `URLRequest` parameter. Defines request that would be
    /// described.
    private func logRequest(_ request: URLRequest) {
        Logger.network.info("⬆️ [REQUEST]")

        if let method = request.httpMethod {
            Logger.network.info("• Method: \(method, privacy: .public)")
        }

        if let url = request.url {
            let sanitizedURL = URL(
                string: url.scheme! + "://" + (url.host ?? "") + url.path
            )
            Logger.network.info(
                "• URL: \(sanitizedURL?.absoluteString ?? "nil", privacy: .public)"
            )
            Logger.network.info("• Path: \(url.path, privacy: .public)")
        }

        if let headers = request.allHTTPHeaderFields {
            let allowedHeaderKeys = ["Content-Type", "Accept"]
            let safeHeaders = headers.filter {
                allowedHeaderKeys.contains($0.key)
            }

            if !safeHeaders.isEmpty {
                Logger.network.info(
                    "• Headers: \(safeHeaders, privacy: .private)"
                )
            }
        }

        if let body = request.httpBody,
            let bodyString = String(data: body, encoding: .utf8)
        {
            #if DEBUG
                Logger.network.info("• Body: \(bodyString, privacy: .private)")
            #else
                Logger.network.info(
                    "• Body: \(bodyString, privacy: .private(mask: .hash))"
                )
            #endif
        }
    }

    /// Function that helpes to log recieved response.
    /// Provides full description of response when logging.
    ///
    /// - Parameters:
    ///   - response: Optional `URLResponse` parameter. Defines response that was recieved.
    ///   - data: Optional `Data` parameter. Defines what was recieved from remote server.
    ///   - error: Optional `Error` parameter. Defines what error occured when recieved response
    /// from remote server.
    private func logResponse(
        _ response: URLResponse?,
        data: Data?,
        error: Error?
    ) {
        Logger.network.info("⬇️ [RESPONSE]")

        if let httpResponse = response as? HTTPURLResponse {
            Logger.network.info(
                "• Status: \(httpResponse.statusCode, privacy: .public)"
            )
            Logger.network
                .info(
                    "• URL: \(httpResponse.url?.absoluteString ?? "nil", privacy: .public)"
                )

            let allowedHeaderKeys = ["Content-Type"]
            let safeHeaders = httpResponse.allHeaderFields
                .compactMap { ($0.key as? String, $0.value) }
                .filter { key, _ in allowedHeaderKeys.contains(key ?? "") }

            if !safeHeaders.isEmpty {
                Logger.network.info(
                    "• Headers: \(safeHeaders, privacy: .private)"
                )
            }
        }

        if let error {
            Logger.network.error(
                "• Error: \(error.localizedDescription, privacy: .public)"
            )
        }

        if let data {
            #if DEBUG
                if let json = try? JSONSerialization.jsonObject(with: data),
                    let pretty = try? JSONSerialization.data(
                        withJSONObject: json,
                        options: .prettyPrinted
                    ),
                    let jsonString = String(data: pretty, encoding: .utf8)
                {
                    Logger.network.info(
                        "• Body:\n\(jsonString, privacy: .private)"
                    )
                } else if let text = String(data: data, encoding: .utf8) {
                    Logger.network.info("• Body:\n\(text, privacy: .private)")
                }
            #else
                Logger.network.info(
                    "• Body: <hidden>",
                    privacy: .private(mask: .hash)
                )
            #endif
        }
    }
}
