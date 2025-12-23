//
//  CatalogItem.swift
//  DigidentityTestCaseTests
//
//  Created by Daniil Bugaenko on 23.12.2025.
//

internal import Foundation
@testable import DigidentityTestCase

extension CatalogItem {
    static func random(id: Int) -> CatalogItem {
        CatalogItem(
            id: "\(id)",
            text: "Random Item \(id)",
            confidence: Float.random(in: 0...1),
            imageURL: "https://picsum.photos/200?random=\(id)"
        )
    }
}

