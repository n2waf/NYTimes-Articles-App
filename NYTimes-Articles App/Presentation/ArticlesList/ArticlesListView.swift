//
//  ArticlesListView.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//


import SwiftUI
import Combine

struct ArticlesListView: View {
    @StateObject var viewModel: ArticlesListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                pickerView()
                
                if viewModel.isLoading {
                    progressView()
                } else if let errorMessage = viewModel.errorMessage {
                    error(errorMessage)
                } else {
                    articlesListView()
                }
            }
            .navigationTitle("NYTimes Articles")
        }
    }
    
    // MARK: Views
    private func pickerView() -> some View {
        Picker("", selection: $viewModel.selectedPeriod) {
            Text("Today").tag(TimePeriod.day)
            Text("This Week").tag(TimePeriod.week)
            Text("This Month").tag(TimePeriod.month)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
    private func progressView() -> some View {
        ProgressView("Loading articles...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func error(_ message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
            
            Button("Try Again") {
                viewModel.loadArticles()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func articlesListView() -> some View {
        List(viewModel.articles, id: \.id) { article in
            ArticleRowView(article: article, viewModel: viewModel)
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.loadArticles()
        }
    }
}

struct ArticlesListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockRepository = MockArticleRepository()
        let viewModel = ArticlesListViewModel(repository: mockRepository)
        ArticlesListView(viewModel: viewModel)
    }
}

private class MockArticleRepository: ArticleRepository {
    func fetchArticles(period: TimePeriod) -> AnyPublisher<NYTResponse, Error> {
        Just(NYTResponse(results: [
            MockFactory.sampleArticle
        ]))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
