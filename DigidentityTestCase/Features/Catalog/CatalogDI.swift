//
//  CatalogDI.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit
import SwiftData

extension Container {
    /// Model context for caching with SwiftData.
    var catalogModelContext: Factory<ModelContext> {
        self { ModelContext(SwiftDataStack.container) }.shared
    }

    /// Local catalog data source used for caching.
    var catalogLocalDataSource: Factory<CatalogLocalDataSource> {
        self {
            CatalogLocalDataSourceImpl()
        }.shared
    }

    /// Remote catalog data source used for fetching data from repository.
    var catalogRemoteDataSource: Factory<CatalogRemoteDataSource> {
        self {
            CatalogRemoteDataSourceImpl()
        }.shared
    }

    /// Catalog repository. Used for fetching data via data sources and mapping them to entities.
    var catalogRepository: Factory<CatalogRepository> {
        self {
            CatalogRepositoryImpl()
        }.shared
    }

    /// Use case for fetching cached data of the catalog.
    var fetchCachedCatalogUseCase: Factory<FetchCachedCatalogUseCase> {
        self {
            FetchCachedCatalogUseCaseImpl()
        }.shared
    }

    /// Use case for fetching catalog data from remote server.
    var fetchCatalogItemsUseCase: Factory<FetchCatalogItemsUseCase> {
        self {
            FetchCatalogItemsUseCaseImpl()
        }.shared
    }

    /// ViewModel for managing state of catalog list view.
    @MainActor
    var catalogListViewModel: Factory<CatalogListViewModel> {
        self {
            @MainActor in CatalogListViewModel()
        }.shared
    }
}
