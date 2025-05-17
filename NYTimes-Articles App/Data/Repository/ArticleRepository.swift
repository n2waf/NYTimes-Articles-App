//
//  ArticleRepository.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//
import Combine

enum TimePeriod: String {
    case day = "1"
    case week = "7"
    case month = "30"
}

protocol ArticleRepository {
    func fetchArticles(period: TimePeriod) -> AnyPublisher<NYTResponse, Error>
}
