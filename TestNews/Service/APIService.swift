

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case noData

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed:
            return "Network request failed"
        case .decodingFailed:
            return "Failed to decode response"
        case .noData:
            return "No data received"
        }
    }
}

class APIService {
    static let shared = APIService()

    private init() {}
    private let session = URLSession.shared

    // MARK: - Fetch Articles
    /// Fetches articles with pagination from DEV.to API
    /// - Parameters:
    ///   - page: Page number for pagination (default: 1)
    ///   - perPage: Number of articles per page (default: 30, max: 1000)
    /// - Returns: Array of Article
    func fetchArticles(page: Int = 1, perPage: Int = 30) async throws -> [Article] {
        // DEV.to API returns array directly, supports ?page=X&per_page=Y
        let urlString = "\(Constants.articlesBaseURL)?page=\(page)&per_page=\(perPage)"

        return try await request(urlString: urlString, type: [Article].self)
    }

    // MARK: - Fetch Article Detail
    /// Fetches a single article with full content by ID
    /// - Parameter id: Article ID
    /// - Returns: Article with body_html/body_markdown
    func fetchArticleDetail(id: Int) async throws -> Article {
        let urlString = "\(Constants.articlesBaseURL)/\(id)"

        return try await request(urlString: urlString, type: Article.self)
    }

    // MARK: - Generic Request
    private func request<T: Decodable>(urlString: String, type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            throw APIError.invalidURL
        }

        print("🌐 Fetching: \(urlString)")

        var request = URLRequest(url: url)

        // DEV.to API doesn't require authentication for public articles
        // But we can add API key if provided in Constants
        if !Constants.apiKey.isEmpty {
            request.addValue(Constants.apiKey, forHTTPHeaderField: "api-key")
        }

        do {
            let (data, response) = try await session.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status code: \(httpResponse.statusCode)")
            }

            print("📦 Received data: \(data.count) bytes")

            // Debug: print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON: \(jsonString.prefix(500))...")
            }

            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            print("✅ Successfully decoded response")
            return decodedObject
        } catch let decodingError as DecodingError {
            print("❌ Decoding error: \(decodingError)")
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Missing key: \(key.stringValue) - \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type mismatch for type: \(type) - \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("Value not found for type: \(type) - \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("Data corrupted: \(context.debugDescription)")
            @unknown default:
                print("Unknown decoding error")
            }
            throw APIError.decodingFailed
        } catch {
            print("❌ Network error: \(error.localizedDescription)")
            throw error
        }
    }
}
