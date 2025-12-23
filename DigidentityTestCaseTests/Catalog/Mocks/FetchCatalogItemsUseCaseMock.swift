//
//  FetchCatalogItemsUseCaseMock.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 23.12.2025.
//
import Testing
@testable import DigidentityTestCase

final class FetchCatalogItemsUseCaseMock: FetchCatalogItemsUseCase {
    var testCase: CatalogListViewModelTestCase

    init(testCase: CatalogListViewModelTestCase) {
        self.testCase = testCase
    }

    func execute(sinceId: String?, maxID: String?) async throws -> [CatalogItem] {
        if let error = testCase.expectedError {
            print("Found an error to throw")
            throw error
        }
        
        
        return testCase.itemsToReturn
    }
}
