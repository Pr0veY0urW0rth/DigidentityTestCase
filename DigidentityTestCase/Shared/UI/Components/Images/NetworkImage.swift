//
//  NetworkImage.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 27.08.2025.
//

import Nuke
import NukeUI
import SwiftUI

/// Network image helper.
/// Gets data from network and caches it.
struct NetworkImage: View {
    /// URL for the image.
    let url: String
    /// Scale mode (fit or fill)
    let contentMode: ContentMode

    let preprocessedWidth: CGFloat

    init(url: String, contentMode: ContentMode = .fit, preprocessedWidth: CGFloat = 800) {
        self.url = url
        self.contentMode = contentMode
        self.preprocessedWidth = preprocessedWidth
    }

    var body: some View {
        LazyImage(url: URL(string: url)) { state in
            if let image = state.image {
                image.resizable().aspectRatio(contentMode: contentMode)
                    .clipped()
            } else if state.error != nil {
                ZStack {
                    Rectangle().foregroundStyle(.gray.opacity(0.5))
                    VStack {
                        IconImage(name: "photo.fill").frame(width: 64, height: 64)
                        Text("No Image").font(.system(size: 20, weight: .bold))
                    }.foregroundStyle(.gray)
                }
            } else {
                SkeletonRect().frame(maxWidth: 300, maxHeight: 300)
            }
        }.processors([.resize(width: preprocessedWidth)]).priority(.veryLow)
    }
}

#Preview {
    NetworkImage(
        url:
        "https://shorturl.at/micCO",
        contentMode: .fit
    ).scaledToFit().padding()
}
