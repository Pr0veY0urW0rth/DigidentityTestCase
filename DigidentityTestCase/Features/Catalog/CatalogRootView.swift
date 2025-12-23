//
//  CatalogRootView.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 23.12.2025.
//

import SwiftUI

struct CatalogRootView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            CatalogListView { item in
                path.append(CatalogRoutes.details(item: item))
            }
            .navigationDestination(for: CatalogRoutes.self) { route in
                switch route {
                case .details(let item):
                    CatalogItemDetails(model: item)
                }
            }
        }
    }
}

#Preview {
    CatalogRootView()
}
