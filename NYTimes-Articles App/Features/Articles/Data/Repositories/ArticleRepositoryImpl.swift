//
//  ArticleRepositoryImpl.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//
import Foundation
import Combine

final class ArticleRepositoryImpl: ArticleRepository {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }

    func fetchArticles(period: TimePeriod) -> AnyPublisher<NYTResponse, Error> {
        let endpoint = Endpoint.article(period: period.rawValue)

        return client.get(endpoint)
            .decode(type: NYTResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
