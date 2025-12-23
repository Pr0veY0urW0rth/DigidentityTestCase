//
//  CatalogItemDTO.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit
import Foundation

/// A data transfer object representing a catalog item
/// returned by the remote API.
struct CatalogItemDTO: Codable {
    /// Backend identifier.
    let _id: String
    let text: String
    let confidence: Float
    let image: String
}

extension CatalogItemDTO {
    /// Maps the DTO into a domain ``CatalogItem``.
    func toEntity() -> CatalogItem {
        CatalogItem(
            id: _id,
            text: text,
            confidence: confidence,
            imageURL: image
        )
    }
}
