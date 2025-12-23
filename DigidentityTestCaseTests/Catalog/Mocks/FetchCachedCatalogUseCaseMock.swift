//
//  FetchCachedCatalogUseCaseMock.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 23.12.2025.
//
@testable import DigidentityTestCase

final class FetchCachedCatalogUseCaseMock: FetchCachedCatalogUseCase {
    var testCase: CatalogListViewModelTestCase

    init(testCase: CatalogListViewModelTestCase) {
        self.testCase = testCase
    }

    func execute() throws -> [CatalogItem] {
        if let error = testCase.expectedError {
            throw error
        }
        return testCase.itemsToReturn
    }
}
