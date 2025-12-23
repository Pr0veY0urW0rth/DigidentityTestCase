//
//  CatalogItemUIModel.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import Foundation

/// UI-friendly representation of ``CatalogItem``.
struct CatalogItemUIModel: Identifiable,Equatable, Hashable{
    let id: String
    let text: String
    let confidence: String
    let imageURL: String
}

extension CatalogItemUIModel{
    init(_ entity: CatalogItem){
        self.init(id: entity.id, text: entity.text, confidence: entity.confidence.formatted(), imageURL: entity.imageURL)
    }
}
