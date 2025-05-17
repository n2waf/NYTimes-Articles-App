//
//  ArticleDetailView.swift
//  NYTimes-Articles App
//
//  Created by Nawaf  on 17/05/2025.
//

import Foundation
import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(article.byline)
                    .font(.subheadline)
                
                Text(article.publishedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Divider()
                
                Text(article.abstract)
                    .font(.body)
                
                Spacer(minLength: 20)
                
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArticleDetailView(article: MockFactory.sampleArticle)
        }
    }
}
