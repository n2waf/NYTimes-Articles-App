//
//  ArticleMapper.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import Foundation

struct ArticleMapper {
    internal static func map(_ data: Data) throws -> NYTResponse {
        let response = try JSONDecoder().decode(NYTResponse.self, from: data)
        return response
    }
}
