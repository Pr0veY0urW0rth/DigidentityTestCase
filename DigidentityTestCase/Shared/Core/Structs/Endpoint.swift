//
//  Endpoint.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 05.12.2025.
//
import Foundation

/// Structure created for simplifing request calls via ``APIHelper``.
/// Determines some parameters of the request.
struct Endpoint {
    /// Required `String` parameter for endpoint in order to make delete request to
    /// remote server.
    let path: String
    /// `HTTPMethod` parameter for endpoint in order to determine type of the request. Check out
    /// ``HTTPMethod`` for more info.
    let method: HTTPMethod
    /// Optional `Data` parameter for providing body with request.
    let body: Data?
    /// A list of optional query parameteres.
    let queryItems: [URLQueryItem]

    init(_ path: String, method: HTTPMethod = .get, body: Data? = nil,queryItems: [URLQueryItem] = []) {
        self.path = path
        self.method = method
        self.body = body
        self.queryItems = queryItems
    }
}
