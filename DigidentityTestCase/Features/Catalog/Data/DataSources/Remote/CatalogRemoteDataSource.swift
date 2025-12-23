//
//  CatalogRemoteDataSource.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit
import Foundation

// MARK: - Protocol

/// A remote data source responsible for fetching items catlog.
///
/// Defines methods to communicate with the remote API layer.
protocol CatalogRemoteDataSource {
    /// Fetches catalog items from the server.
    ///
    /// - Parameters:
    ///   - sinceId: If specified, it returns items with an ID greater than (that is, more recent than) the specified ID.
    ///   - maxID: If specified, it returns results with an ID less than (that is, older than) or equal to the specified ID.
    /// - Returns: A list of ``CatalogItemDTO`` items.
    /// - Throws: An ``APIError`` if the request fails.
    func fetchCatalog(sinceId: String?, maxID: String?) async throws
        -> [CatalogItemDTO]
}

// MARK: - Implementation

/// Default implementation of ``CatalogRemoteDataSource``.
///
/// Uses ``APIHelper`` to perform HTTP requests and decode responses.
final class CatalogRemoteDataSourceImpl: CatalogRemoteDataSource {
    /// Injectes data source with the specified API helper via Factory
    @Injected(\.apiHelper) private var apiHelper: APIHelper

    func fetchCatalog(
        sinceId: String?,
        maxID: String?
    ) async throws -> [CatalogItemDTO] {

        let queryItems = [
            sinceId.map { URLQueryItem(name: "since_id", value: $0) },
            maxID.map { URLQueryItem(name: "max_id", value: $0) }
        ].compactMap { $0 }

        return try await apiHelper.request(
            endpoint: Endpoint(
                "mock/v1/items",
                queryItems: queryItems
            )
        )
    }
}


