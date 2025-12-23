//
//  CatalogListViewModelTests.swift
//  DigidentityTestCaseTests
//
//  Created by Daniil Bugaenko on 23.12.2025.
//

import Testing
import FactoryTesting
import FactoryKit
@testable import DigidentityTestCase
internal import Foundation

@Suite("Catalog list viewModel unit tests", .container)
struct CatalogListViewModelTests {
    @MainActor
    @Test("Initial items fetch viewmodel unit test", .tags(.catalog, .unitTest), arguments: CatalogListViewModelTestCase.testCases) func test_initial_items_fetch(testCase: CatalogListViewModelTestCase) async throws {
        Container.shared.fetchCatalogItemsUseCase.register { FetchCatalogItemsUseCaseMock(testCase: testCase) }
                Container.shared.fetchCachedCatalogUseCase.register { FetchCachedCatalogUseCaseMock(testCase: testCase) }
                
                let catalogListViewModel = CatalogListViewModel()
                await catalogListViewModel.initialLoad()
                
                if testCase.expectedError == nil {
                    #expect(catalogListViewModel.catalog.data.items == testCase.itemsToReturn.map{CatalogItemUIModel($0)})
                    #expect(catalogListViewModel.catalog.isSuccess)
                } else {
                    #expect(catalogListViewModel.catalog.isFailed)
                }
    }
    
    @MainActor
    @Test("More items fetch viewmodel unit test", .tags(.catalog, .unitTest), arguments: CatalogListViewModelTestCase.testCases) func test_fetch_more_items(testCase: CatalogListViewModelTestCase) async throws {
        Container.shared.fetchCatalogItemsUseCase.register { FetchCatalogItemsUseCaseMock(testCase: testCase) }
        Container.shared.fetchCachedCatalogUseCase.register{
            FetchCachedCatalogUseCaseMock(testCase: testCase)
        }
                
                let catalogListViewModel = CatalogListViewModel()
                let lastItem = CatalogItemUIModel(id: "last", text: "Last Item", confidence: "0.5", imageURL: "https://placehold.co/512x512?text=Last")
                catalogListViewModel.catalog = .loaded(PaginatedData(items: [lastItem], lastID: lastItem.id))
                
                await catalogListViewModel.fetchIfNeeded(lastItem)
                
                if testCase.expectedError == nil {
                    #expect(!catalogListViewModel.catalog.data.items.isEmpty)
                    #expect(catalogListViewModel.catalog.isSuccess)
                } else {
                    #expect(catalogListViewModel.catalog.isFailed)
                }
    }
    
    @MainActor
    @Test("Refresh viewmodel unit test", .tags(.catalog, .unitTest), arguments: CatalogListViewModelTestCase.testCases)
        func test_refresh(testCase: CatalogListViewModelTestCase) async throws {
            Container.shared.fetchCatalogItemsUseCase.register { FetchCatalogItemsUseCaseMock(testCase: testCase) }
            
            let catalogListViewModel = CatalogListViewModel()
            await catalogListViewModel.refresh()
            
            if testCase.expectedError == nil {
                #expect(catalogListViewModel.catalog.data.items.isEmpty == testCase.itemsToReturn.isEmpty)
                #expect(catalogListViewModel.catalog.isSuccess)
            } else {
                #expect(catalogListViewModel.catalog.isFailed)
            }
        }

}
