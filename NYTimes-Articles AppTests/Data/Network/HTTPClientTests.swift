//
//  HTTPClientTests.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import XCTest
@testable import NYTimes_Articles_App

final class HTTPClientTests: XCTestCase {

    func test_makeBaseURL_returnsCorrectURL() throws {
        let url = MockHTTPClient().baseURL
        XCTAssertEqual(url.absoluteString, "https://api.nytimes.com")
    }
}
