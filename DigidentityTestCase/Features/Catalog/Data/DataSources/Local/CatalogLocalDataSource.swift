//
//  CatalogLocalDataSource.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import Foundation
import SwiftData
import FactoryKit

// MARK: - Protocol

/// A local data source responsible for persisting and retrieving catalog items.
///
/// Defines an interface for interacting with locally stored ``CatalogItemModel``
/// objects, typically backed by SwiftData.
protocol CatalogLocalDataSource {

    /// Fetches all catalog items stored locally.
    ///
    /// - Returns: An array of ``CatalogItemModel`` objects sorted by text
    ///   in reverse order.
    /// - Throws: An error if the fetch operation fails.
    func fetchAll() throws -> [CatalogItemModel]

    /// Saves catalog items to local storage.
    ///
    /// Only items that do not already exist (based on their identifier)
    /// will be inserted.
    ///
    /// - Parameter items: A list of ``CatalogItemModel`` objects to persist.
    /// - Throws: An error if saving to the local store fails.
    func save(_ items: [CatalogItemModel]) throws
}

// MARK: - Implementation

/// Default implementation of ``CatalogLocalDataSource``.
///
/// Uses ``ModelContext`` from SwiftData to fetch and persist catalog items.
/// The context is injected via Factory for easier testing and decoupling.
final class CatalogLocalDataSourceImpl: CatalogLocalDataSource {

    /// Injected SwiftData model context used for fetch and save operations.
    @Injected(\.catalogModelContext) private var context: ModelContext

    func fetchAll() throws -> [CatalogItemModel] {
        let descriptor = FetchDescriptor<CatalogItemModel>(
            sortBy: [SortDescriptor(\.text, order: .reverse)]
        )

        let models = (try? context.fetch(descriptor)) ?? []
        return models
    }

    func save(_ items: [CatalogItemModel]) throws {
        let existing = try fetchAll()
        let existingIDs = Set(existing.map(\.id))

        for item in items where !existingIDs.contains(item.id) {
            context.insert(item)
        }

        try context.save()
    }
}
