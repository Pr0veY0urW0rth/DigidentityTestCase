//
//  SwiftDataStack.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import SwiftData


enum SwiftDataStack {
    static let container: ModelContainer = {
        try! ModelContainer(for: CatalogItemModel.self)
    }()
}
