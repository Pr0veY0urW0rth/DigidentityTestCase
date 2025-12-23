//
//  IconImage.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 02.10.2025.
//

import SwiftUI

/// Image helper.
/// If name was defined in SF symbols - returns SF symbol.
/// If not - return custom local symbol.
struct IconImage: View {
    /// Name of the symbol.
    let name: String

    var body: some View {
        if UIImage(systemName: name) != nil {
            Image(systemName: name)
                .resizable()
                .scaledToFit()
        } else {
            Image(name)
                .resizable()
                .scaledToFit()
        }
    }
}
