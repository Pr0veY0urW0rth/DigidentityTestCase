//
//  CatalogRepository.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit

// MARK: - Protocol

/// A repository that manages access to catalog items.
///
/// Provides an abstraction over data sources and handles model transformation.
protocol CatalogRepository {
    /// Retrieves catalog items from a remote source.
    ///
    /// - Parameters:
    ///   - sinceId: If specified, it returns items with an ID greater than (that is, more recent than) the specified ID.
    ///   - maxID: If specified, it returns results with an ID less than (that is, older than) or equal to the specified ID.
    ///
    /// - Returns: A list of ``CatalogItem`` items.
    ///
    /// - Throws: An ``APIError`` if the request fails.
    func fetchCatalog(sinceId: String?, maxID: String?) async throws
        -> [CatalogItem]
    
    /// Retrieves catalog items from a cache.
    ///
    /// - Returns: A list of ``CatalogItem`` items.
    ///
    /// - Throws: An ``APIError`` if the request fails.
    func fetchCachedCatalog()  throws -> [CatalogItem]
}
