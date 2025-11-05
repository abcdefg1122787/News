//
//  ArticleDetailView.swift
//  TestNews
//
//

import SwiftUI
import Kingfisher

struct ArticleDetailView: View {
    let articleId: Int
    let previewArticle: Article?

    @State private var article: Article?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Loading article...")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            } else if let errorMessage = errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundColor(.orange)
                    Text("Error Loading Article")
                        .font(.system(size: 20, weight: .bold))
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            } else if let article = article {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Cover Image
                        KFImage(URL(string: article.imageUrl ?? ""))
                            .placeholder {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                                    .frame(width: geometry.size.width)
                                    .frame(height: 250)
                                    .background(Color.gray.opacity(0.2))
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width)
                            .frame(height: 250)
                            .clipped()

                        VStack(alignment: .leading, spacing: 12) {
                            // Title
                            Text(article.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)

                            // Metadata
                            HStack(spacing: 8) {
                                Text("By \(article.authorName)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)

                                Text(article.formattedDate)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)

                                if let source = article.sourceName {
                                    Text("•")
                                        .foregroundColor(.secondary)

                                    Text(source)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.blue)
                                }
                            }

                            Divider()
                                .padding(.vertical, 4)

                            // Description
                            Text(article.description)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)

                            // Content
                            if let content = article.content, !content.isEmpty {
                                Text(cleanHTML(content))
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 4)
                            } else {
                                Text("Full article content is not available. Visit \(article.url) to read more.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 4)
                            }
                        }
                        .frame(width: geometry.size.width - 40, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .frame(width: geometry.size.width)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await fetchArticleDetail()
        }
    }

    private func fetchArticleDetail() async {
        do {
            let fetchedArticle = try await APIService.shared.fetchArticleDetail(id: articleId)
            await MainActor.run {
                self.article = fetchedArticle
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    // Helper function to strip HTML tags and code blocks
    private func cleanHTML(_ html: String) -> String {
        var cleanContent = html

        // Remove code blocks (both <pre><code> and standalone <code>)
        cleanContent = cleanContent.replacingOccurrences(
            of: "<pre[^>]*>.*?</pre>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        cleanContent = cleanContent.replacingOccurrences(
            of: "<code[^>]*>.*?</code>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )

        // Remove script and style tags
        cleanContent = cleanContent.replacingOccurrences(
            of: "<script[^>]*>.*?</script>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        cleanContent = cleanContent.replacingOccurrences(
            of: "<style[^>]*>.*?</style>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )

        // Remove all HTML tags
        cleanContent = cleanContent.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )

        // Decode HTML entities
        cleanContent = cleanContent
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&apos;", with: "'")

        // Remove excessive whitespace and newlines
        cleanContent = cleanContent
            .replacingOccurrences(of: "\n\n\n+", with: "\n\n", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return cleanContent
    }
}

// Convenience initializer for when you have the full article
extension ArticleDetailView {
    init(article: Article) {
        self.articleId = article.id
        self.previewArticle = article
        self._article = State(initialValue: nil)
    }
}
