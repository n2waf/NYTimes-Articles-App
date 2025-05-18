# NYTimes Articles App

SwiftUI app displays the most popular articles from The New York Times using their public API. 

## Features

- Display a list of the most popular NYTimes articles
- Filter articles by time period (day, week, month)
- Open Article details

## Architecture

MVVM (Model-View-ViewModel) architecture:

- **Model**: Represents the data layer with entities: `Article`
- **View**: SwiftUI views that display the UI (`ArticlesListView`, `ArticleDetailView`)
- **ViewModel**: Business logic and the state (`ArticlesListViewModel`)
- **Repository**: Data access (`ArticleRepository`, `ArticleRepositoryImpl`)
- **Network**: API communication (`HTTPClient`, `URLSessionHTTPClient`)

## Getting Started

### Installation

1. Clone the repository:
```bash
git clone https://github.com/n2waf/nytimes-articles.git
cd nytimes-articles
```

2. Open the project in Xcode:
```bash
open NYTimes-Articles.xcodeproj
```

3. Configure your NY Times API key in your user-specific scheme:

- Go to Product → Scheme → Edit Scheme.
- Select the "Run" action and go to the "Arguments" tab.
- Under "Environment Variables", add NYTIMES_API_KEY with your API key as the value.
- These settings will stay in your local environment and won't be committed to Git.

4. Build and run the project in Xcode


## Project Structure

```
NYTimes-Articles App/
├── App/
│   ├── NYTimesArticlesApp.swift  (App entry point)
│   └── DependencyContainer.swift
├── Data/
│   ├── Network/
│   │   ├── Client/
│   │   │   ├── HTTPClient.swift
│   │   │   └── URLSessionHTTPClient.swift
│   │   ├── Endpoint/
│   │   │   └── Endpoint.swift
│   │   └── Configuration/
│   │       └── Configuration.swift
│   ├── Repository/
│   │   ├── ArticleRepository.swift
│   │   └── ArticleRepositoryImpl.swift
│   └── Mapping/
│       └── ArticleMapper.swift
├── Domain/
│   └── Models/
│       └── Article.swift
├── Presentation/
│   ├── ArticlesList/
│   │   ├── ArticlesListView.swift
│   │   └── ArticlesListViewModel.swift
│   └── ArticleDetail/
│       └── ArticleDetailView.swift

```

## Testing

The project includes unit tests for:
- Network layer
- Repository implementation
- View models
- Model parsing

The current test coverage is **80%** of the codebase.

Run tests in Xcode using `Cmd+U` or from the Product menu.
