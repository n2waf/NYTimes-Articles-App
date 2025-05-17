//
//  ArticlesListViewModelTests.swift
//  NYTimes-Articles AppTests
//
//  Created by Nawaf  on 17/05/2025.
//

import XCTest
import Combine
@testable import NYTimes_Articles_App

final class ArticlesListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    override func tearDown() {
        cancellables = []
        super.tearDown()
    }
    
    func test_init_setsDefaultPeriodToWeek() {
        let (_, viewModel) = makeSUT()
        XCTAssertEqual(viewModel.selectedPeriod, .week)
    }

    func test_loadArticles_showsLoadingState() {
        let (_, viewModel) = makeSUT()
        viewModel.loadArticles()
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func test_loadArticles_successfulResponse_deliversArticlesAndHidesLoading() {
        let (client, viewModel) = makeSUT()
        let expectedData = MockFactory.sampleResponse
        client.stubbedResult = .success(MockFactory.validArticleData)
        
        let expectation = XCTestExpectation(description: "Wait for articles")
        viewModel.$articles
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.loadArticles()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.articles, expectedData.results)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_loadArticles_failureResponse_setsErrorMessageAndHidesLoading() {
        let (client, viewModel) = makeSUT()
        let error = NSError(domain: "test", code: 1, userInfo: nil)
        client.stubbedResult = .failure(error)
        
        let expectation = XCTestExpectation(description: "Wait for error")
        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.loadArticles()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (client: MockHTTPClient, viewModel: ArticlesListViewModel) {
        let client = MockHTTPClient()
        let repository = ArticleRepositoryImpl(client: client)
        let viewModel = ArticlesListViewModel(repository: repository)
        return (client, viewModel)
    }
    
}
