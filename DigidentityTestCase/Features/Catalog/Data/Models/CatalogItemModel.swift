//
//  CatalogItemModel.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import SwiftData

/// SwiftData model used for local persistence of catalog items.
@Model
final class CatalogItemModel{
    @Attribute(.unique) var id: String
    var text: String
    var confidence: Float
    var imageURL: String
    
    init(id: String, text: String, confidence: Float, imageURL: String) {
        self.id = id
        self.text = text
        self.confidence = confidence
        self.imageURL = imageURL
    }
}

extension CatalogItemModel{
    convenience init(_ entity: CatalogItem){
        self.init(id: entity.id, text: entity.text, confidence: entity.confidence, imageURL: entity.imageURL)
    }
}

extension CatalogItemModel{
    func toEntity() -> CatalogItem{
        CatalogItem(id: id, text: text, confidence: confidence, imageURL: imageURL)
    }
}
