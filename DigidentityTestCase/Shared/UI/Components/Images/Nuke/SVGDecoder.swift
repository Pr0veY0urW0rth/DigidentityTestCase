//
//  SVGDecoder.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 22.12.2025.
//


import Nuke
import SVGKit
import UIKit

final class SVGDecoder: ImageDecoding {

    func decode(_ data: Data) throws -> ImageContainer {
        guard let svg = SVGKImage(data: data) else {
            throw ImageDecodingError.unknown
        }

        let maxSide: CGFloat = 512
        svg.scaleToFit(inside: CGSize(width:maxSide, height:maxSide))

        guard let image = svg.uiImage else {
            throw ImageDecodingError.unknown
        }

        return ImageContainer(image: image)
    }
}
