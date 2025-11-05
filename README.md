 # TestNews

A modern iOS application built with **SwiftUI** for browsing and reading articles with a clean interface featuring a hero layout, infinite scroll, and detailed article views.

## Prerequisites
- iOS 15.0+
- Xcode 14.2+
- CocoaPods
- Valid internet connection to fetch articles from DEV.to API

## Setup

Navigate to the project directory:
```bash
cd TestNews
```

Install the pods:
```bash
pod install
```

Open the `.xcworkspace` file in Xcode:
```bash
open TestNews.xcworkspace
```

Now you are ready to build and run it! The app is already configured to use the **DEV.to public API** which requires no authentication.

**Note:** The app fetches articles from `https://dev.to/api/articles` and displays them with full detail pages.

## App Overview

TestNews is a native SwiftUI article reading application that provides users with a seamless browsing experience. The app features:

- **Hero Layout**: The first article is prominently displayed in a featured hero card with a large image and gradient overlay
- **Article List**: Subsequent articles are displayed in a scrollable list with thumbnails, titles, descriptions, and metadata
- **Detail View**: Tapping any article navigates to a full-screen detail page with complete article content
- **Infinite Scroll**: Automatically loads more articles as you scroll down
- **Pull to Refresh**: Swipe down to refresh the article feed
- **Native SwiftUI**: Built entirely with SwiftUI for modern iOS development

## General Architecture

The project is built following the **MVVM (Model-View-ViewModel)** pattern using SwiftUI's native reactive framework and modern Swift concurrency (async/await).

## Features

✅ SwiftUI-based article list with hero layout for featured article
✅ Article detail page with full content display
✅ Pagination (infinite scroll) to load more articles
✅ Native pull-to-refresh functionality
✅ Smooth SwiftUI navigation between list and detail views
✅ Asynchronous image loading with caching via Kingfisher
✅ Clean, modern UI with native SwiftUI components
✅ Error handling with native SwiftUI alerts
✅ Modern async/await networking
✅ @MainActor for thread-safe UI updates

## Testing

The project structure supports comprehensive testing:

### Unit Tests (`TestNewsTests`)
- Can test ArticleViewModel with async/await test patterns
- Can test Article model decoding and computed properties
- Can test APIService networking layer

### UI Tests (`TestNewsUITests`)
- Can test SwiftUI navigation flows
- Can test article list and detail interactions

Run tests in Xcode:
- Unit Tests: `Cmd + U`
- UI Tests: Select UI test target and run

## Conclusion

TestNews demonstrates professional iOS development with:
- Modern SwiftUI architecture with native reactive bindings
- Clean MVVM pattern with ObservableObject and @Published
- Async/await networking for readable, maintainable code
- Native SwiftUI components and modifiers
- Production-ready code structure and error handling
- Best practices for dependency management and API integration
- Future-proof codebase using Apple's latest frameworks
