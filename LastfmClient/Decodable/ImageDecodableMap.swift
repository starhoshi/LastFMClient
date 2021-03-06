//
//  ImageDecodableMap.swift
//  LastfmClient
//
//  Created by kensuke-hoshikawa on 2018/02/25.
//  Copyright © 2018年 star__hoshi. All rights reserved.
//

import Foundation

struct ImageDecodableMap: Decodable {
    var decoded: Image

    private enum Size: String, Codable {
        case small
        case medium
        case large
        case extralarge
    }

    private struct _Image: Decodable {
        let text: String
        let size: Size

        enum CodingKeys: String, CodingKey {
            case text = "#text"
            case size
        }
    }

    init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        var small: URL?
        var medium: URL?
        var large: URL?
        var extralarge: URL?
        while !unkeyedContainer.isAtEnd {
            let image = try unkeyedContainer.decode(_Image.self)
            let url = URL(string: image.text)
            switch image.size {
            case .small:
                small = url
            case .medium:
                medium = url
            case .large:
                large = url
            case .extralarge:
                extralarge = url
            }
        }

        self.decoded = Image(small: small, medium: medium, large: large, extralarge: extralarge)
    }
}


struct TagsDecodableMap: Decodable {
    var decoded: [Tag]

    private enum TagKeys: String, CodingKey {
        case tag
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TagKeys.self)
        decoded = try container.decode([Tag].self, forKey: .tag)
    }
}
