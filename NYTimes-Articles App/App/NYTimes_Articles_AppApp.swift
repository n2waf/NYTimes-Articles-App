//
//  NYTimes_Articles_AppApp.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import SwiftUI

@main
struct NYTimes_Articles_AppApp: App {
    
    private let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            ArticlesListView(viewModel: container.makeArticlesListViewModel())
        }
    }
}
