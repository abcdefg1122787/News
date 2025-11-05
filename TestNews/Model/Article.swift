

import Foundation

// MARK: - User
struct User: Decodable, Equatable {
    let name: String
    let username: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case name
        case username
        case profileImage = "profile_image"
    }
}

// MARK: - Organization
struct Organization: Decodable, Equatable {
    let name: String
    let username: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case name
        case username
        case profileImage = "profile_image"
    }
}

// MARK: - Article
struct Article: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let description: String
    let coverImage: String?
    let publishedAt: String
    let readablePublishDate: String
    let user: User
    let organization: Organization?
    let url: String
    let tagList: [String]
    let readingTimeMinutes: Int

    // Detail-only fields (optional for list view)
    let bodyHtml: String?
    let bodyMarkdown: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case coverImage = "cover_image"
        case publishedAt = "published_at"
        case readablePublishDate = "readable_publish_date"
        case user
        case organization
        case url
        case tagList = "tag_list"
        case readingTimeMinutes = "reading_time_minutes"
        case bodyHtml = "body_html"
        case bodyMarkdown = "body_markdown"
    }

    // Custom decoding to handle API inconsistencies
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        coverImage = try container.decodeIfPresent(String.self, forKey: .coverImage)
        publishedAt = try container.decode(String.self, forKey: .publishedAt)
        readablePublishDate = try container.decode(String.self, forKey: .readablePublishDate)
        user = try container.decode(User.self, forKey: .user)
        organization = try container.decodeIfPresent(Organization.self, forKey: .organization)
        url = try container.decode(String.self, forKey: .url)
        readingTimeMinutes = try container.decode(Int.self, forKey: .readingTimeMinutes)
        bodyHtml = try container.decodeIfPresent(String.self, forKey: .bodyHtml)
        bodyMarkdown = try container.decodeIfPresent(String.self, forKey: .bodyMarkdown)

        // Handle tag_list which can be either array or string
        if let tags = try? container.decode([String].self, forKey: .tagList) {
            tagList = tags
        } else if let tagString = try? container.decode(String.self, forKey: .tagList), !tagString.isEmpty {
            tagList = tagString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        } else {
            tagList = []
        }
    }

    // Computed properties for convenience
    var authorName: String {
        return user.name
    }

    var authorUsername: String {
        return "@\(user.username)"
    }

    var sourceName: String? {
        return organization?.name
    }

    var imageUrl: String? {
        return coverImage
    }

    var content: String? {
        return bodyHtml ?? bodyMarkdown
    }

    var formattedDate: String {
        return readablePublishDate
    }

    var tagsString: String {
        guard !tagList.isEmpty else { return "" }
        return tagList.map { "#\($0)" }.joined(separator: " ")
    }
}
