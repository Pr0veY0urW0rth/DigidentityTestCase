//
//  NukePipelines.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 22.12.2025.
//

import Nuke
import Foundation

final class NukePipelines{
    static func registerSVGDecoder() {
        ImageDecoderRegistry.shared.register { context in
            if context.urlResponse?.url?.pathExtension.lowercased() == "svg" ||
               context.urlResponse?.mimeType == "image/svg+xml" {
                return SVGDecoder()
            }
            return nil
        }
    }
}


