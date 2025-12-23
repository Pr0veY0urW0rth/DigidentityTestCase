//
//  CatalogRepositoryImpl.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import Foundation

import FactoryKit

// MARK: - Implementation

/// Default implementation of ``CatalogRepository``.
///
/// Uses remote and local data sources to retrieve, cache,
/// and map catalog data into domain entities.
final class CatalogRepositoryImpl: CatalogRepository {
    /// Injectes the repository with a specific remote data source via Factory.
    @Injected(\.catalogRemoteDataSource) private var remoteDataSource: CatalogRemoteDataSource

    /// Injectes the repository with a specific local data source via Factory.
    @Injected(\.catalogLocalDataSource) private var localDataSource: CatalogLocalDataSource

    func fetchCachedCatalog()  throws -> [CatalogItem]{
        try localDataSource.fetchAll().map{$0.toEntity()}
    }
    
    func fetchCatalog(sinceId: String?, maxID: String?) async throws
    -> [CatalogItem]{
        let items = try await remoteDataSource.fetchCatalog(sinceId: sinceId, maxID: maxID).map{$0.toEntity()}
        try localDataSource.save(items.map{CatalogItemModel($0)})
        return items
    }
}

