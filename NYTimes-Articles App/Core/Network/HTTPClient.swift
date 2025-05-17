//
//  HTTPClient.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//
import Foundation
import Combine

protocol HTTPClient {
    func get(_ endpoint: Endpoint) -> AnyPublisher<Data, Error>
}

extension HTTPClient {
    var baseURL: URL {
        guard let baseURL = URL(string: "https://api.nytimes.com") else {
            fatalError("Invalid URL.")
        }
        return baseURL
    }
    
}
