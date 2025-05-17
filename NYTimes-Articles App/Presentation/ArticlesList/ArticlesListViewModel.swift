//
//  ArticlesListViewModel.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//
import Foundation
import Combine

class ArticlesListViewModel: ObservableObject {

    @Published private(set) var articles: [Article] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var selectedPeriod: TimePeriod = .week
    
    
    private let repository: ArticleRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ArticleRepository) {
        self.repository = repository
        $selectedPeriod
            .dropFirst()
            .sink { [weak self] _ in
                self?.articles = []
                self?.loadArticles()
            }
            .store(in: &cancellables)
    }
    
    func loadArticles() {
        isLoading = true
        errorMessage = nil
        
        repository.fetchArticles(period: selectedPeriod)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.articles = response.results
                }
            )
            .store(in: &cancellables)
    }
    
    func setPeriod(_ period: TimePeriod) {
        selectedPeriod = period
    }
    
    private func handleError(_ error: Error) {
        errorMessage = "Failed to load articles. Please try again later."
    }
    
}
