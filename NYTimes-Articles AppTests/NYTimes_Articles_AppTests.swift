//
//  NYTimes_Articles_AppTests.swift
//  NYTimes-Articles AppTests
//
//  Created by Nawaf  on 17/05/2025.
//

import XCTest
import Combine
@testable import NYTimes_Articles_App

final class NYTimes_Articles_AppTests: XCTestCase {

    func test_makeBaseURL_returnsCorrectURL() throws {
        let url = MockHTTPClient().baseURL
        XCTAssertEqual(url.absoluteString, "https://api.nytimes.com")
    }
}
