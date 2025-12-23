//
//  CatalogListViewModelTestCases.swift
//  DigidentityTestCaseTests
//
//  Created by Daniil Bugaenko on 23.12.2025.
//

internal import Foundation
@testable import DigidentityTestCase

struct CatalogListViewModelTestCase {
    var expectedError: APIError?
    var itemsToReturn: [CatalogItem]

    init(expectedError: APIError? = nil, itemsToReturn: [CatalogItem]? = nil) {
        self.expectedError = expectedError
        self.itemsToReturn = itemsToReturn ?? (1...10).map { CatalogItem(id: "\($0)", text: "Item \($0)", confidence: Float.random(in: 0...1), imageURL: "https://placehold.co/512x512?text=Item\($0)") }
    }

    static var testCases: [Self] = [
        .init(), 
        .init(expectedError: .serverError),
    ]
}
