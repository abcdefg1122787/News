//
//  ArticleViewModelTests.swift
//  TestNewsTests
//
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import TestNews

class ArticleViewModelTests: XCTestCase {

    var viewModel: ArticleViewModel!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        viewModel = ArticleViewModel()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }

    func testInitialState() {
        // Given & When
        let articles = viewModel.articles.value
        let isLoading = viewModel.isLoading.value

        // Then
        XCTAssertTrue(articles.isEmpty, "Articles should be empty initially")
        XCTAssertFalse(isLoading, "Should not be loading initially")
    }

    func testArticlesAreEmptyInitially() {
        // Given
        let expectation = XCTestExpectation(description: "Articles should be empty initially")

        // When
        viewModel.articles
            .subscribe(onNext: { articles in
                if articles.isEmpty {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testRefreshTriggerClearsArticles() {
        // Given
        let mockArticles = [
            Article(
                id: "1",
                title: "Test",
                description: "Test",
                content: nil,
                imageUrl: nil,
                publishedDate: "2025-04-29T12:00:00Z",
                author: nil,
                source: nil
            )
        ]
        viewModel.articles.accept(mockArticles)

        let expectation = XCTestExpectation(description: "Articles should be cleared after refresh")

        // When
        viewModel.articles
            .skip(1) // Skip initial value
            .subscribe(onNext: { articles in
                if articles.isEmpty {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        viewModel.refreshTrigger.onNext(())

        // Then
        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadingStateChanges() {
        // Given
        let expectation = XCTestExpectation(description: "Loading state should change")
        var loadingStates: [Bool] = []

        // When
        viewModel.isLoading
            .subscribe(onNext: { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count >= 2 {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 3.0)
        XCTAssertTrue(loadingStates.contains(true), "Should have loading state as true at some point")
    }

    func testErrorHandling() {
        // Given
        let expectation = XCTestExpectation(description: "Error should be published")

        // When
        viewModel.error
            .subscribe(onNext: { error in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        // Note: This will trigger an error due to invalid URL in Constants
        // Wait a bit to allow the API call to fail
        wait(for: [expectation], timeout: 5.0)
    }
}
