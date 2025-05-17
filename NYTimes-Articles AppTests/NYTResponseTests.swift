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
        let data = try MockFactory.loadJSON(.articleResponse)
        let response = try JSONDecoder().decode(NYTResponse.self, from: data)
        
        XCTAssertFalse(response.results.isEmpty)
        XCTAssertEqual(response.results.first?.id, 1234567890)
    }
    
    func test_decode_invalidData_fails() throws {
        let data = try MockFactory.loadJSON(.invalidData)
        XCTAssertThrowsError(try JSONDecoder().decode(NYTResponse.self, from: data))
    }
    
    func test_decode_emptyResults_succeeds() throws {
        let data = try MockFactory.loadJSON(.emptyResults)
        let response = try JSONDecoder().decode(NYTResponse.self, from: data)
        XCTAssertTrue(response.results.isEmpty)
    }
}
