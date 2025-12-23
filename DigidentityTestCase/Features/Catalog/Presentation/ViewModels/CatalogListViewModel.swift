//
//  CatalogListViewModel.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit
import Foundation
import OSLog

// MARK: - View Model

/// View model for ``CatalogListView``.
///
/// Coordinates business logic from the domain layer and exposes data to the UI.
@MainActor
@Observable
final class CatalogListViewModel {
    // MARK: - Dependencies
    /// Use case for fetching catalog items from remote server.
    @ObservationIgnored @Injected(\.fetchCatalogItemsUseCase) private
        var fetchCatalogItemsUC: FetchCatalogItemsUseCase
    /// Use case for fetching cached items from swift data.
    @ObservationIgnored @Injected(\.fetchCachedCatalogUseCase) private
        var fetchCachedCatalogUC: FetchCachedCatalogUseCase

    // MARK: - Published Properties
    /// Catalog data that is exposed in UI.
    var catalog: PaginatedLoadable<CatalogItemUIModel> = .idle()

    // MARK: - Public Methods
    /// Fetches catalog data from server if certain conditions are met.
    ///
    /// - Parameter item: Optional parameter. Represents item from UI layer.
    func fetchIfNeeded(_ item: CatalogItemUIModel? = nil) async{
        guard item?.id == catalog.data.lastID,
            !catalog.isLoading,
            !catalog.data.isCompleted
        else { return }
        await fetchServerItems()
    }

    /// Initiates fetching of catalog items.
    func initialLoad() async {
        await fetchCachedItems()
    }

    /// Refreshes catalog data by restarting pagination
    /// and fetching fresh data from the server.
    func refresh() async {
        Logger.userInterface.info("Pull-to-refresh triggered.")
        
            guard !catalog.isLoading else {return}

        let emptyData = PaginatedData<CatalogItemUIModel>()
        catalog = .loading(data: emptyData)

        do {
            let items = try await fetchCatalogItemsUC.execute()
                .map { CatalogItemUIModel($0) }

            let data = PaginatedData(
                items: items,
                lastID: items.last?.id,
                isCompleted: items.isEmpty
            )
            
            print("data is \(data)")

            catalog = .loaded(data)
        } catch let error as APIError {
            Logger.userInterface.error("Refresh failed: \(error)")
            catalog = .failed(error, data: emptyData)
        } catch {
            Logger.userInterface.error("Unexpected refresh error: \(error)")
            catalog = .failed(error, data: emptyData)
        }
    }

    
    // MARK: - Private Methods
    /// Fetches cached catalog items using the associated use case and updates the view model state.
    ///
    ///
    /// On success, updates the `catalog` property.
    /// On failure, logs the error and updates the `catalog` to `.failed`.
    private func fetchCachedItems() async {
        Logger.features.info(
            "Started  fetching cached items  in CatalogListViewModel."
        )
        do {
            let cachedItems = try fetchCachedCatalogUC.execute().map {
                CatalogItemUIModel($0)
            }
            let cachedData = PaginatedData(
                items: cachedItems,
                lastID: cachedItems.last?.id
            )

            catalog =
                cachedItems.isEmpty
                ? .loading(data: catalog.data) : .loaded(cachedData)

            await fetchServerItems()
        } catch let error as APIError {
            Logger.features.error("Caught API error: \(error)")
            catalog = .failed(error, data: catalog.data)
        } catch {
            Logger.features.error("Unexpected error: \(error)")
            catalog = .failed(error, data: catalog.data)
        }
    }

    /// Fetches catalog items from remote server using the associated use case and updates the view model state.
    ///
    ///
    /// On success, updates the `catalog` property.
    /// On failure, logs the error and updates the `catalog` to `.failed`.
    private func fetchServerItems() async {
        let previousData = catalog.data

        catalog = .loading(data: previousData)

        do {
            let responseItems = try await fetchCatalogItemsUC.execute(
                maxID: previousData.lastID
            )
            .map { CatalogItemUIModel($0) }

            var updatedItems = previousData.items.map {
                cachedItem -> CatalogItemUIModel in
                if let serverItem = responseItems.first(where: {
                    $0.id == cachedItem.id
                }) {
                    return serverItem
                } else {
                    return cachedItem
                }
            }

            let newItems = responseItems.filter { serverItem in
                !previousData.items.contains(where: { $0.id == serverItem.id })
            }
            updatedItems.append(contentsOf: newItems)

            let paginatedData = PaginatedData(
                items: updatedItems,
                lastID: updatedItems.last?.id,
                isCompleted: responseItems.isEmpty
            )

            catalog = .loaded(paginatedData)
        } catch let error as APIError {
            Logger.features.error("Caught API error: \(error)")
            catalog = .failed(error, data: previousData)
        } catch {
            Logger.features.error("Unexpected error: \(error)")
            catalog = .failed(error, data: previousData)
        }
    }

}
