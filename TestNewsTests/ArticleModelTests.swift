//
//  ArticleModelTests.swift
//  TestNewsTests
//
//

import XCTest
@testable import TestNews

class ArticleModelTests: XCTestCase {

    func testArticleDecoding() throws {
        // Given
        let json = """
        {
            "id": 123,
            "title": "Test Article",
            "description": "Test Description",
            "cover_image": "https://example.com/image.jpg",
            "published_at": "2025-04-29T12:00:00Z",
            "readable_publish_date": "Apr 29",
            "user": {
                "name": "John Doe",
                "username": "johndoe",
                "profile_image": "https://example.com/avatar.jpg"
            },
            "url": "https://dev.to/test",
            "tag_list": ["swift", "ios"],
            "reading_time_minutes": 5
        }
        """.data(using: .utf8)!

        // When
        let decoder = JSONDecoder()
        let article = try decoder.decode(Article.self, from: json)

        // Then
        XCTAssertEqual(article.id, 123)
        XCTAssertEqual(article.title, "Test Article")
        XCTAssertEqual(article.description, "Test Description")
        XCTAssertEqual(article.coverImage, "https://example.com/image.jpg")
        XCTAssertEqual(article.publishedAt, "2025-04-29T12:00:00Z")
        XCTAssertEqual(article.readablePublishDate, "Apr 29")
        XCTAssertEqual(article.user.name, "John Doe")
        XCTAssertEqual(article.user.username, "johndoe")
        XCTAssertEqual(article.url, "https://dev.to/test")
        XCTAssertEqual(article.tagList, ["swift", "ios"])
        XCTAssertEqual(article.readingTimeMinutes, 5)
    }

    func testArticleDecodingWithOptionalFields() throws {
        // Given
        let json = """
        {
            "id": 456,
            "title": "Minimal Article",
            "description": "Minimal Description",
            "published_at": "2025-04-29T12:00:00Z",
            "readable_publish_date": "Apr 29",
            "user": {
                "name": "Jane Smith",
                "username": "janesmith"
            },
            "url": "https://dev.to/test2",
            "tag_list": [],
            "reading_time_minutes": 3
        }
        """.data(using: .utf8)!

        // When
        let decoder = JSONDecoder()
        let article = try decoder.decode(Article.self, from: json)

        // Then
        XCTAssertEqual(article.id, 456)
        XCTAssertEqual(article.title, "Minimal Article")
        XCTAssertNil(article.coverImage)
        XCTAssertNil(article.organization)
        XCTAssertNil(article.bodyHtml)
        XCTAssertNil(article.bodyMarkdown)
    }

    func testArticleWithOrganization() throws {
        // Given
        let json = """
        {
            "id": 789,
            "title": "Organization Article",
            "description": "Description",
            "published_at": "2025-04-29T12:00:00Z",
            "readable_publish_date": "Apr 29",
            "user": {
                "name": "Author Name",
                "username": "authoruser"
            },
            "organization": {
                "name": "Tech Company",
                "username": "techcompany",
                "profile_image": "https://example.com/org.jpg"
            },
            "url": "https://dev.to/test3",
            "tag_list": ["technology"],
            "reading_time_minutes": 10
        }
        """.data(using: .utf8)!

        // When
        let decoder = JSONDecoder()
        let article = try decoder.decode(Article.self, from: json)

        // Then
        XCTAssertNotNil(article.organization)
        XCTAssertEqual(article.organization?.name, "Tech Company")
        XCTAssertEqual(article.sourceName, "Tech Company")
    }

    func testArticleComputedProperties() {
        // Given
        let user = User(name: "Test User", username: "testuser", profileImage: nil)
        let article = Article(
            id: 1,
            title: "Title",
            description: "Description",
            coverImage: "https://example.com/image.jpg",
            publishedAt: "2025-04-29T12:00:00Z",
            readablePublishDate: "Apr 29",
            user: user,
            organization: nil,
            url: "https://dev.to/test",
            tagList: ["swift", "ios", "testing"],
            readingTimeMinutes: 5,
            bodyHtml: "<p>HTML Content</p>",
            bodyMarkdown: "Markdown Content"
        )

        // Then
        XCTAssertEqual(article.authorName, "Test User")
        XCTAssertEqual(article.authorUsername, "@testuser")
        XCTAssertEqual(article.imageUrl, "https://example.com/image.jpg")
        XCTAssertEqual(article.content, "<p>HTML Content</p>")
        XCTAssertEqual(article.formattedDate, "Apr 29")
        XCTAssertEqual(article.tagsString, "#swift #ios #testing")
    }

    func testArticleEquality() {
        // Given
        let user1 = User(name: "User", username: "user", profileImage: nil)
        let user2 = User(name: "User", username: "user", profileImage: nil)

        let article1 = Article(
            id: 1,
            title: "Title",
            description: "Description",
            coverImage: nil,
            publishedAt: "2025-04-29T12:00:00Z",
            readablePublishDate: "Apr 29",
            user: user1,
            organization: nil,
            url: "https://dev.to/test",
            tagList: [],
            readingTimeMinutes: 5,
            bodyHtml: nil,
            bodyMarkdown: nil
        )

        let article2 = Article(
            id: 1,
            title: "Title",
            description: "Description",
            coverImage: nil,
            publishedAt: "2025-04-29T12:00:00Z",
            readablePublishDate: "Apr 29",
            user: user2,
            organization: nil,
            url: "https://dev.to/test",
            tagList: [],
            readingTimeMinutes: 5,
            bodyHtml: nil,
            bodyMarkdown: nil
        )

        let article3 = Article(
            id: 2,
            title: "Different Title",
            description: "Description",
            coverImage: nil,
            publishedAt: "2025-04-29T12:00:00Z",
            readablePublishDate: "Apr 29",
            user: user1,
            organization: nil,
            url: "https://dev.to/test2",
            tagList: [],
            readingTimeMinutes: 5,
            bodyHtml: nil,
            bodyMarkdown: nil
        )

        // Then
        XCTAssertEqual(article1, article2)
        XCTAssertNotEqual(article1, article3)
    }

    func testTagsStringFormatting() {
        // Given
        let user = User(name: "User", username: "user", profileImage: nil)
        let articleWithTags = Article(
            id: 1,
            title: "Title",
            description: "Description",
            coverImage: nil,
            publishedAt: "2025-04-29T12:00:00Z",
            readablePublishDate: "Apr 29",
            user: user,
            organization: nil,
            url: "https://dev.to/test",
            tagList: ["swift", "ios"],
            readingTimeMinutes: 5,
            bodyHtml: nil,
            bodyMarkdown: nil
        )

        let articleWithoutTags = Article(
            id: 2,
            title: "Title",
            description: "Description",
            coverImage: nil,
            publishedAt: "2025-04-29T12:00:00Z",
            readablePublishDate: "Apr 29",
            user: user,
            organization: nil,
            url: "https://dev.to/test",
            tagList: [],
            readingTimeMinutes: 5,
            bodyHtml: nil,
            bodyMarkdown: nil
        )

        // Then
        XCTAssertEqual(articleWithTags.tagsString, "#swift #ios")
        XCTAssertEqual(articleWithoutTags.tagsString, "")
    }
}
