//
//  CatalogListView.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit
import SwiftUI
import OSLog

/// Root view displaying a paginated list of catalog items.
struct CatalogListView: View {
    @InjectedObservable(\.catalogListViewModel)
    private var viewModel: CatalogListViewModel
    let onItemTap: (_ item: CatalogItemUIModel) -> Void

    var body: some View {
            List {
                ForEach(viewModel.catalog.data.items) { item in
                        CatalogListItem(model: item)
                            .onAppear {
                                Task{
                                    await viewModel.fetchIfNeeded(item)
                                }
                            }
                            .padding(.bottom, 20).onTapGesture {
                                Logger.userInterface.info("Tapped on item.")
                                onItemTap(item)
                            }
                    
                }

                if viewModel.catalog.isLoading {
                    ForEach(0..<3, id: \.self) { _ in
                        CatalogListItemSkeleton()
                    }
                }

                if let error = viewModel.catalog.error {
                    VStack(spacing: 8) {
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.red)

                        Button("Retry") {
                            Task {
                                Logger.userInterface.info("Tapped retry button.")
                                await viewModel.fetchIfNeeded()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .listStyle(.plain)
            .refreshable {
                        await viewModel.refresh()
                    }
            .task {
                Logger.userInterface.info("Initialized load of catalog.")
                await viewModel.initialLoad()
            }
        
    }
}

#Preview {
    CatalogListView(){item in 
        
    }
}
