//
//  CatalogItemDetails.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 23.12.2025.
//

import SwiftUI

struct CatalogItemDetails: View {
    let model: CatalogItemUIModel
    var body: some View {
        VStack{
            NetworkImage(url: model.imageURL).frame(maxWidth: 300,maxHeight: 300).padding()
            HStack{
                Text("ID: \(model.id)")
                Spacer()
                Text("Confidence: \(model.confidence)")
            }
            Text(model.text)
        }
    }
}
