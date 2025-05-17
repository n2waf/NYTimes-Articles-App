//
//  Article.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import Foundation


struct NYTResponse: Decodable {
    let results: [Article]
}

struct Article: Decodable, Equatable {
    let uri: String
    let url: String
    let id: Int
    let assetId: Int
    let source: String
    let publishedDate: String
    let section: String
    let title: String
    let abstract: String
    let byline: String
    let media: [Media]

    enum CodingKeys: String, CodingKey {
        case uri, url, id, source, section, title, abstract, byline, media
        case assetId = "asset_id"
        case publishedDate = "published_date"
    }
}

struct Media: Decodable, Equatable {
    let type: String
    let subtype: String
    let mediaMetadata: [MediaMetadata]

    enum CodingKeys: String, CodingKey {
        case type, subtype
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadata: Decodable, Equatable {
    let url: String
    let format: String
    let height: Int
    let width: Int
}
