//
//  ArticleRepositoryImplTests.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//
import XCTest
import Combine
@testable import NYTimes_Articles_App

final class ArticleRepositoryTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func tearDown() {
        cancellables = []
        super.tearDown()
    }
    
    func test_fetchArticles_requestsCorrectEndpoint() {
        let (sut, client) = makeSUT()
        
        _ = sut.fetchArticles(period: .week)
        
        XCTAssertEqual(client.requestedEndpoint?.path, "/svc/mostpopular/v2/viewed/7.json")
    }
    
    func test_fetchArticles_allTimePeriods_requestCorrectEndpoints() {
        let (sut, client) = makeSUT()
        
        _ = sut.fetchArticles(period: .day)
        XCTAssertEqual(client.requestedEndpoint?.path, "/svc/mostpopular/v2/viewed/1.json")
        
        _ = sut.fetchArticles(period: .week)
        XCTAssertEqual(client.requestedEndpoint?.path, "/svc/mostpopular/v2/viewed/7.json")
        
        _ = sut.fetchArticles(period: .month)
        XCTAssertEqual(client.requestedEndpoint?.path, "/svc/mostpopular/v2/viewed/30.json")
    }
    
    func test_fetchArticles_successfulResponse_deliversArticles() {
        let (sut, client) = makeSUT()
        client.stubbedResult = .success(MockJSONFile.articleResponse.data)
        
        let result = executeRequest(on: sut, with: .day)
        
        XCTAssertNil(result.error)
        XCTAssertEqual(result.articles?.results.count, 2)
        XCTAssertEqual(result.articles?.results.first?.id, 1234567890)
    }
    
    func test_fetchArticles_emptyResponse_deliversEmptyArticles() {
        let (sut, client) = makeSUT()
        client.stubbedResult = .success(MockJSONFile.emptyResults.data)
        
        let result = executeRequest(on: sut, with: .month)
        
        XCTAssertNil(result.error)
        XCTAssertEqual(result.articles?.results.count, 0)
    }
    
    func test_fetchArticles_invalidResponse_deliversError() {
        let (sut, client) = makeSUT()
        client.stubbedResult = .success(MockJSONFile.invalidData.data)
        
        let result = executeRequest(on: sut, with: .day)
        
        XCTAssertNotNil(result.error)
        XCTAssertNil(result.articles)
    }
    
    func test_fetchArticles_clientError_deliversError() {
        let (sut, client) = makeSUT()
        let expectedError = NSError(domain: "test", code: 0, userInfo: nil)
        client.stubbedResult = .failure(expectedError)
        
        let result = executeRequest(on: sut, with: .week)
        
        XCTAssertEqual((result.error as NSError?)?.domain, expectedError.domain)
        XCTAssertEqual((result.error as NSError?)?.code, expectedError.code)
        XCTAssertNil(result.articles)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ArticleRepositoryImpl, client: MockHTTPClient) {
        let client = MockHTTPClient()
        let sut = ArticleRepositoryImpl(client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private func executeRequest(on sut: ArticleRepositoryImpl, with period: TimePeriod) -> (articles: NYTResponse?, error: Error?) {
        let exp = expectation(description: "Wait for completion")
        var receivedArticles: NYTResponse?
        var receivedError: Error?
        
        sut.fetchArticles(period: period)
            .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    exp.fulfill()
                },
                receiveValue: { articles in
                    receivedArticles = articles
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
        
        return (receivedArticles, receivedError)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
