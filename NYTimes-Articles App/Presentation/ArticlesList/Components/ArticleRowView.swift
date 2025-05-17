//
//  ArticleRowView.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//
import SwiftUI
import Combine

struct ArticleRowView: View {
    let article: Article
    let viewModel: ArticlesListViewModel
    
    var body: some View {
        NavigationLink(destination: ArticleDetailView(article: article)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(article.byline)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(article.publishedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
