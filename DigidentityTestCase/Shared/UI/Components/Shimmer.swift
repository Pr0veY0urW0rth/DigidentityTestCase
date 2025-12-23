//
//  Shimmer.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 25.11.2025.
//

import SwiftUI

struct Shimmer: ViewModifier {
    @State private var offset: CGFloat = -200

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.4), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: 100, height: geometry.size.height * 2)
                    .rotationEffect(.degrees(30))
                    .offset(x: offset)
                    .onAppear {
                        offset = -200
                        withAnimation(
                            .linear(duration: 1.5).repeatForever(autoreverses: false)
                        ) {
                            offset = geometry.size.width + 200
                        }
                    }
                }
                .mask(content)
            )
    }
}
