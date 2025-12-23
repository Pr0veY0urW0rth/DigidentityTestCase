//
//  FetchCatalogItemsUseCase.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit

// MARK: - Protocol

/// A use case that get cached data from local storage.
///
/// Uses ``CatalogRepository`` to execute the operation.
protocol FetchCatalogItemsUseCase {
    /// Executes the business logic to get cached data.
    ///
    /// - Parameters:
    ///   - sinceId: If specified, it returns items with an ID greater than (that is, more recent than) the specified ID.
    ///   - maxID: If specified, it returns results with an ID less than (that is, older than) or equal to the specified ID.
    ///
    /// - Returns: A list of ``CatalogItem`` items.
    ///
    /// - Throws: An ``APIError`` if the repository operation fails.
    func execute(sinceId: String?, maxID: String?) async throws -> [CatalogItem]
}

// MARK: - Extension

/// Extension on ``FetchCatalogItesmUseCase`` for simplifiyng code execution and improvement of code reusability.
extension FetchCatalogItemsUseCase {
    func execute(sinceId: String? = nil, maxID: String? = nil) async throws
        -> [CatalogItem]
    {
        try await execute(sinceId: sinceId, maxID: maxID)
    }
}

// MARK: - Implementation

/// Default implementation of ``FetchCatalogItesmUseCase``.
///
/// Relies on ``CatalogRepository`` for data retrieval and transformation.
final class FetchCatalogItemsUseCaseImpl: FetchCatalogItemsUseCase {
    /// Injectes the use case with a specific repository via Factory.
    @Injected(\.catalogRepository) private var repository: CatalogRepository

    func execute(sinceId: String?, maxID: String?) async throws -> [CatalogItem]
    {
        try await repository.fetchCatalog(sinceId: sinceId, maxID: maxID)
    }
}
