//
//  URLSessionHTTPClient.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import Foundation
import Combine
final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(_ endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        let url = baseURL.appendingPathComponent(endpoint.path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "api-key", value: Configuration.apiKey)]
        
        guard let finalURL = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: finalURL)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
