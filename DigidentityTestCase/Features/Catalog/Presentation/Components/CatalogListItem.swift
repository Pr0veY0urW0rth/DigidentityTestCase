//
//  CatalogListItem.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 23.12.2025.
//


import SwiftUI

struct CatalogListItem: View {
    let model: CatalogItemUIModel
    
    var body: some View {
        VStack{
            NetworkImage(url: model.imageURL).frame(maxWidth: 300,maxHeight: 300).padding()
            Text("ID: \(model.id)")
            Text(model.text)
            Text("Confidence: \(model.confidence)")
        }.background(RoundedRectangle(cornerRadius: 16).stroke(.black)).padding()
    }
}

struct CatalogListItemSkeleton: View {
    var body: some View {
        VStack{
            SkeletonRect().frame(maxWidth: 300,maxHeight: 300).padding()
            HStack{
                Text("ID:")
                SkeletonRect().frame(maxWidth: 40)
            }.frame(maxHeight: 30)
            SkeletonRect().frame(maxWidth: 80).frame(maxHeight: 30)
            HStack{
                Text("Confidence:")
                SkeletonRect().frame(maxWidth: 40)
            }.frame(maxHeight: 30)
        }.background(RoundedRectangle(cornerRadius: 16).stroke(.black)).padding()
    }
}
