import Foundation
import SwiftUI

@MainActor
class ArticleViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var currentPage = 1
    private let perPage = 30
    private var isLastPage = false

    init() {
        // Initial fetch
        Task {
            await fetchArticles()
        }
    }

    // MARK: - Public Methods
    func refresh() async {
        currentPage = 1
        isLastPage = false
        articles = []
        await fetchArticles()
    }

    func loadMore() async {
        guard !isLastPage, !isLoading else { return }
        currentPage += 1
        await fetchArticles()
    }

    // MARK: - Private Methods
    private func fetchArticles() async {
        guard !isLoading else { return }
        guard !isLastPage else { return }

        isLoading = true
        errorMessage = nil

        do {
            let newArticles = try await APIService.shared.fetchArticles(page: currentPage, perPage: perPage)

            if currentPage == 1 {
                articles = newArticles
            } else {
                articles.append(contentsOf: newArticles)
            }

            // Check if this is the last page
            // DEV.to returns empty array or fewer articles when reaching the end
            if newArticles.isEmpty || newArticles.count < perPage {
                isLastPage = true
            }

            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
