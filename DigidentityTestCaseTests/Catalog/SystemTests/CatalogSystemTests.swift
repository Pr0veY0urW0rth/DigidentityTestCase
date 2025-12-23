//
//  CatalogSystemTests.swift
//  DigidentityTestCaseTests
//
//  Created by Daniil Bugaenko on 23.12.2025.
//

@testable import DigidentityTestCase
import Testing
import FactoryTesting
import FactoryKit
internal import Foundation

@Suite("Catalog system tests", .container)
struct CatalogSystemTests {
    @MainActor
    @Test("Initial items fetch system test", .tags(.catalog, .systemTest)) func test_initial_items_fetch() async throws {
        let catalogListViewModel = Container.shared.catalogListViewModel.resolve()
        await catalogListViewModel.initialLoad()
        
        #expect(!catalogListViewModel.catalog.data.items.isEmpty)
        #expect(catalogListViewModel.catalog.isSuccess)
    }
    
    @MainActor
    @Test("More items fetch system test", .tags(.catalog, .systemTest)) func test_fetch_more_items() async throws {
        let catalogListViewModel = Container.shared.catalogListViewModel.resolve()
        let item = CatalogItemUIModel(id: "6915a6129b9f3", text: "20. dmfdu", confidence: 0.36.formatted(), imageURL: "https://placehold.co/512x512?text=20.%20dmfdu")
        catalogListViewModel.catalog = .loaded(PaginatedData(items: [item], lastID: item.id))
        await catalogListViewModel.fetchIfNeeded(item)

        #expect(!catalogListViewModel.catalog.data.items.isEmpty)
        #expect(catalogListViewModel.catalog.isSuccess)
    }
    
    @MainActor
    @Test("Refresh system test", .tags(.catalog, .systemTest)) func test_refresh() async throws {
        let catalogListViewModel = Container.shared.catalogListViewModel.resolve()
        await catalogListViewModel.refresh()

        #expect(!catalogListViewModel.catalog.data.items.isEmpty && catalogListViewModel.catalog.data.items.count == 10)
        #expect(catalogListViewModel.catalog.isSuccess)
    }
}
