//
//  MockJSONFile.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//
import Foundation

enum MockJSONFile: String {
    case articleResponse = "article_response"
    case invalidData = "invalid_structure"
    case emptyResults = "empty_results"

    var data: Data {
        let bundle = Bundle(for: Token.self)
        guard let url = bundle.url(forResource: self.rawValue, withExtension: "json") else {
            fatalError("Missing file: \(self.rawValue).json")
        }
        return (try? Data(contentsOf: url)) ?? Data()
    }

    private final class Token {}
}
