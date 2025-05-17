//
//  URLSessionHTTPClientTests.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//
import XCTest
import Combine
@testable import NYTimes_Articles_App

final class URLSessionHTTPClientTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
        cancellables = []
    }
    
    override func tearDown() {
        URLProtocolStub.stopInterceptingRequests()
        cancellables = []
        super.tearDown()
    }
    
    // MARK: - Tests
    func test_get_performsGETRequestWithURL() {
        let endpoint = Endpoint.article(period: "7")
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url?.path, endpoint.path)
            XCTAssertEqual(request.httpMethod, "GET")
            
            let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            XCTAssertTrue(components?.queryItems?.contains(where: { $0.name == "api-key" }) ?? false)
            
            exp.fulfill()
        }
        
        makeSUT().get(endpoint)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_get_failsOnRequestError() {
        let requestError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_get_failsOnNonHTTPResponse() {
        let nonHTTPResponse = URLResponse(url: anyURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let receivedError = resultErrorFor(data: anyData, response: nonHTTPResponse, error: nil)
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_get_failsOnHTTPErrorResponse() {
        let errorResponse = HTTPURLResponse(url: anyURL, statusCode: 400, httpVersion: nil, headerFields: nil)!
        let receivedError = resultErrorFor(data: anyData, response: errorResponse, error: nil)
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_get_succeedsOnHTTPResponseWithData() {
        let data = anyData
        let response = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        let receivedData = resultDataFor(data: data, response: response, error: nil)
        
        XCTAssertEqual(receivedData, data)
    }
    
    func test_get_succeedsWithEmptyDataOnHTTPResponseWithNilData() {
        let response = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        let receivedData = resultDataFor(data: nil, response: response, error: nil)
        
        XCTAssertEqual(receivedData, Data())
    }
    
    // MARK: - Helpers
    private var anyURL: URL {
        URL(string: "https://any-url.com")!
    }
    
    private var anyData: Data {
        Data("any data".utf8)
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?) -> Error? {
        let result = resultFor(data: data, response: response, error: error)
        
        switch result {
        case .failure(let error):
            return error
        case .success:
            XCTFail("Expected failure, got success instead")
            return nil
        }
    }
    
    private func resultDataFor(data: Data?, response: URLResponse?, error: Error?) -> Data? {
        let result = resultFor(data: data, response: response, error: error)
        
        switch result {
        case .success(let data):
            return data
        case .failure:
            XCTFail("Expected success, got failure instead")
            return nil
        }
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let sut = makeSUT()
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: Result<Data, Error>!
        
        sut.get(Endpoint.article(period: "7"))
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        receivedResult = .failure(error)
                        exp.fulfill()
                    }
                },
                receiveValue: { data in
                    receivedResult = .success(data)
                    exp.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
    
    private func makeSUT() -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        return URLSessionHTTPClient(session: session)
    }
    
    // MARK: - URLProtocol Stub
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver {
                DispatchQueue.main.async {
                    requestObserver(self.request)
                }
            }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
