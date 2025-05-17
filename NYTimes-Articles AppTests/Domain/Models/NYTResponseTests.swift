//
//  NYTResponseTests.swift
//  NYTimes-Articles AppTests
//
//  Created by Nawaf  on 17/05/2025.
//

import Foundation
@testable import NYTimes_Articles_App
import XCTest

final class NYTResponseTests: XCTestCase {
    func test_decode_validData_succeeds() throws {
        let data = MockJSONFile.articleResponse.data
        let response = try ArticleMapper.map(data)
        XCTAssertFalse(response.results.isEmpty)
        XCTAssertEqual(response.results.first?.id, 1234567890)
    }
    
    func test_decode_invalidData_fails() {
        let data = MockJSONFile.invalidData.data
        XCTAssertThrowsError(try ArticleMapper.map(data))
    }
    
    func test_decode_emptyResults_succeeds() throws {
        let data = MockJSONFile.emptyResults.data
        let response = try ArticleMapper.map(data)
        XCTAssertTrue(response.results.isEmpty)
    }
}
