//
//   MockFactory.swift
//  NYTimes-Articles AppTests
//
//  Created by Nawaf  on 17/05/2025.
//

import Foundation
@testable import NYTimes_Articles_App

enum MockFactory {
    
    static func loadJSON(_ file: MockJSONFile) throws -> Data {
        let bundle = Bundle(for: MockFactoryToken.self)
        guard let url = bundle.url(forResource: file.rawValue, withExtension: "json") else {
            throw NSError(domain: "Missing file: \(file.rawValue).json", code: -1)
        }
        return try Data(contentsOf: url)
    }
    
    static var sampleMediaMetadata: MediaMetadata {
        MediaMetadata(
            url: "https://example.com/thumb.jpg",
            format: "JPG",
            height: 75,
            width: 75
        )
    }

    static var sampleMedia: Media {
        Media(
            type: "image",
            subtype: "photo",
            mediaMetadata: [sampleMediaMetadata]
        )
    }

    static var sampleArticle: Article {
        Article(
            uri: "nyt://article/1",
            url: "https://www.nytimes.com",
            id: 100000010172522,
            assetId: 100000010172522,
            source: "NYTimes",
            publishedDate: "2025-05-16",
            section: "Opinion",
            title: "Title",
            abstract: "Abstract",
            byline: "Byline",
            media: [sampleMedia]
        )
    }

    static var sampleResponse: NYTResponse {
        NYTResponse(results: [sampleArticle])
    }

    static var validArticleData: Data {
        try! JSONEncoder().encode(sampleResponse)
    }

    static var invalidArticleData: Data {
        "{}".data(using: .utf8)!
    }
}

private final class MockFactoryToken {}
