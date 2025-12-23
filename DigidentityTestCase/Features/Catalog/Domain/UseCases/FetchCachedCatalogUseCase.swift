//
//  FetchCachedCatalogUseCase.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit

// MARK: - Protocol

/// A use case that get cached data from local storage.
///
/// Uses ``CatalogRepository`` to execute the operation.
protocol FetchCachedCatalogUseCase {
    /// Executes the business logic to get cached data.
    ///
    /// - Returns: A list of ``CatalogItem`` items.
    ///
    /// - Throws: An ``APIError`` if the repository operation fails.
    func execute() throws -> [CatalogItem]
}

// MARK: - Implementation

/// Default implementation of ``FetchCachedCatalogUseCase``.
///
/// Relies on ``CatalogRepository`` for data retrieval and transformation.
final class FetchCachedCatalogUseCaseImpl: FetchCachedCatalogUseCase {
    /// Injectes the use case with a specific repository via Factory.
    @Injected(\.catalogRepository) private var repository: CatalogRepository

    func execute() throws -> [CatalogItem] {
        try repository.fetchCachedCatalog()
    }
}
