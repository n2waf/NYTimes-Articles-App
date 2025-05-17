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
    
    private var sut: ArticleRepositoryImpl!
    private var mockHTTPClient: MockHTTPClient!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        sut = ArticleRepositoryImpl(client: mockHTTPClient)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockHTTPClient = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchArticles_requestsCorrectEndpoint() {
        let period = TimePeriod.week
        _ = sut.fetchArticles(period: period)
        XCTAssertEqual(mockHTTPClient.requestedEndpoint?.path, "svc/mostpopular/v2/viewed/7.json")
    }
    
    func test_fetchArticles_successfulResponse_deliversArticles() {
        let period = TimePeriod.day
        mockHTTPClient.stubbedResult = .success(MockJSONFile.articleResponse.data)
        
        let expectation = expectation(description: "Wait for completion")
        var receivedArticles: NYTResponse?
        var receivedError: Error?
        
        sut.fetchArticles(period: period)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { articles in
                    receivedArticles = articles
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedArticles)
        XCTAssertEqual(receivedArticles?.results.count, 2)
        XCTAssertEqual(receivedArticles?.results.first?.id, 1234567890)
    }
    
    func test_fetchArticles_emptyResponse_deliversEmptyArticles() {
        let period = TimePeriod.month
        mockHTTPClient.stubbedResult = .success(MockJSONFile.emptyResults.data)
        
        let expectation = expectation(description: "Wait for completion")
        var receivedArticles: NYTResponse?
        var receivedError: Error?
        
        sut.fetchArticles(period: period)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { articles in
                    receivedArticles = articles
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedArticles)
        XCTAssertEqual(receivedArticles?.results.count, 0)
    }
    
    func test_fetchArticles_invalidResponse_deliversError() {
        let period = TimePeriod.day
        mockHTTPClient.stubbedResult = .success(MockJSONFile.invalidData.data)
        
        let expectation = expectation(description: "Wait for completion")
        var receivedArticles: NYTResponse?
        var receivedError: Error?
        
        sut.fetchArticles(period: period)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { articles in
                    receivedArticles = articles
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(receivedError)
        XCTAssertNil(receivedArticles)
    }
    
    func test_fetchArticles_clientError_deliversError() {
        let period = TimePeriod.week
        let expectedError = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockHTTPClient.stubbedResult = .failure(expectedError)
        
        let expectation = expectation(description: "Wait for completion")
        var receivedArticles: NYTResponse?
        var receivedError: NSError?
        
        sut.fetchArticles(period: period)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error as NSError
                    }
                    expectation.fulfill()
                },
                receiveValue: { articles in
                    receivedArticles = articles
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(receivedError)
        XCTAssertNil(receivedArticles)
        XCTAssertEqual(receivedError?.code, expectedError.code)
    }
    
    func test_fetchArticles_allTimePeriods_requestCorrectEndpoints() {
        
        _ = sut.fetchArticles(period: .day)
        XCTAssertEqual(mockHTTPClient.requestedEndpoint?.path, "svc/mostpopular/v2/viewed/1.json")
        
        _ = sut.fetchArticles(period: .week)
        XCTAssertEqual(mockHTTPClient.requestedEndpoint?.path, "svc/mostpopular/v2/viewed/7.json")
        
        _ = sut.fetchArticles(period: .month)
        XCTAssertEqual(mockHTTPClient.requestedEndpoint?.path, "svc/mostpopular/v2/viewed/30.json")
    }

}

// MARK: - Mock HTTP Client
class MockHTTPClient: HTTPClient {
    var requestedEndpoint: Endpoint?
    var stubbedResult: Result<Data, Error> = .success(Data())
    
    func get(_ endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        requestedEndpoint = endpoint
        
        return stubbedResult.publisher
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
