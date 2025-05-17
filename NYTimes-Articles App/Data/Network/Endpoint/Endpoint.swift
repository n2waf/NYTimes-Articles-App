//
//  Endpoint.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import Foundation

enum Endpoint {
    case article(period: String)
    
    var path: String {
        switch self {
        case .article(let period):
            return "/svc/mostpopular/v2/viewed/\(period).json"
        }
    }
}

