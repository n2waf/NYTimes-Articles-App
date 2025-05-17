//
//  DependencyContainer.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import Foundation

final class DependencyContainer {
    
    lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient()
    }()
    
    lazy var articleRepository: ArticleRepository = {
        return ArticleRepositoryImpl(client: httpClient)
    }()
    
    func makeArticlesListViewModel() -> ArticlesListViewModel {
        return ArticlesListViewModel(repository: articleRepository)
    }
}
