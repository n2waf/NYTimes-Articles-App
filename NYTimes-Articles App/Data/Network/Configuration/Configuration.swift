//
//  Configuration.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 18/05/2025.
//
import Foundation

enum Configuration {
    static let apiKey: String = {
        let environmentKey = ProcessInfo.processInfo.environment["NYTIMES_API_KEY"]
        if let key = environmentKey, !key.isEmpty {
            return key
        } else {
            fatalError("Missing required environment variable: NYTIMES_API_KEY")
        }
    }()
}
