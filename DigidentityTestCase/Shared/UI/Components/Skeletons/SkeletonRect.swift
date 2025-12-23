//
//  SkeletonRect.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 11.12.2025.
//

import SwiftUI

struct SkeletonRect: View {
    var cornerRadius: CGFloat = 16
    var onlyTop: Bool = false
    var body: some View {
        Rectangle()
            .modifier(Shimmer())
            .foregroundStyle(.gray.opacity(0.5))
            .overlay(
                Rectangle()
                    .stroke(.gray.opacity(0.7))
            )
            .clipShape(.rect(
                topLeadingRadius: cornerRadius,
                bottomLeadingRadius: onlyTop ? 0 : cornerRadius,
                bottomTrailingRadius: onlyTop ? 0 : cornerRadius,
                topTrailingRadius: cornerRadius
            ))
    }
}

#Preview {
    SkeletonRect()
}
