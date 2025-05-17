//
//  MockHTTPClient.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import XCTest
import Combine
@testable import NYTimes_Articles_App

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
