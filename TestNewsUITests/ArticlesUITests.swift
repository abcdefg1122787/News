//
//  ArticlesUITests.swift
//  TestNewsUITests
//
//

import XCTest

class ArticlesUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testAppLaunches() throws {
        // Given & When
        let app = XCUIApplication()
        app.launch()

        // Then
        XCTAssertTrue(app.navigationBars["Articles"].exists, "Articles navigation bar should exist")
    }

    func testNavigationBarExists() throws {
        // Then
        let navigationBar = app.navigationBars["Articles"]
        XCTAssertTrue(navigationBar.exists, "Navigation bar with 'Articles' title should exist")
    }

    func testCollectionViewExists() throws {
        // Then
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.exists, "Collection view should exist")
    }

    func testArticleCellTapNavigatesToDetail() throws {
        // Given
        let collectionView = app.collectionViews.firstMatch

        // Wait for collection view to load
        let exists = collectionView.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Collection view should load within 5 seconds")

        // When
        let cells = collectionView.cells
        if cells.count > 1 {
            // Tap the second cell (first is hero)
            let secondCell = cells.element(boundBy: 1)
            if secondCell.exists {
                secondCell.tap()

                // Then
                // Check if we navigated by looking for back button
                let backButton = app.navigationBars.buttons.element(boundBy: 0)
                XCTAssertTrue(backButton.exists, "Back button should exist after navigation")
            }
        }
    }

    func testHeroCellTapNavigatesToDetail() throws {
        // Given
        let collectionView = app.collectionViews.firstMatch

        // Wait for collection view to load
        let exists = collectionView.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Collection view should load within 5 seconds")

        // When
        let cells = collectionView.cells
        if cells.count > 0 {
            // Tap the first cell (hero)
            let heroCell = cells.element(boundBy: 0)
            if heroCell.exists {
                heroCell.tap()

                // Then
                // Check if we navigated by looking for back button
                let backButton = app.navigationBars.buttons.element(boundBy: 0)
                XCTAssertTrue(backButton.exists, "Back button should exist after navigation to detail")
            }
        }
    }

    func testNavigateToDetailAndBack() throws {
        // Given
        let collectionView = app.collectionViews.firstMatch
        let exists = collectionView.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Collection view should load")

        // When - Navigate to detail
        let cells = collectionView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            if firstCell.exists {
                firstCell.tap()

                // Wait for navigation
                let backButton = app.navigationBars.buttons.element(boundBy: 0)
                XCTAssertTrue(backButton.waitForExistence(timeout: 2), "Back button should appear")

                // Then - Navigate back
                backButton.tap()

                // Verify we're back at articles list
                let articlesNavBar = app.navigationBars["Articles"]
                XCTAssertTrue(articlesNavBar.waitForExistence(timeout: 2), "Should navigate back to Articles")
            }
        }
    }

    func testPullToRefresh() throws {
        // Given
        let collectionView = app.collectionViews.firstMatch
        let exists = collectionView.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Collection view should load")

        // When
        let start = collectionView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let end = collectionView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6))
        start.press(forDuration: 0.1, thenDragTo: end)

        // Then
        // Wait a moment for refresh to trigger
        sleep(1)
        XCTAssertTrue(collectionView.exists, "Collection view should still exist after refresh")
    }

    func testScrolling() throws {
        // Given
        let collectionView = app.collectionViews.firstMatch
        let exists = collectionView.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Collection view should load")

        // When - Scroll down
        collectionView.swipeUp()
        collectionView.swipeUp()

        // Then
        XCTAssertTrue(collectionView.exists, "Collection view should exist after scrolling")
    }

    func testDetailViewDisplaysContent() throws {
        // Given
        let collectionView = app.collectionViews.firstMatch
        let exists = collectionView.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Collection view should load")

        // When
        let cells = collectionView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            if firstCell.exists {
                firstCell.tap()

                // Then - Check if scroll view exists (detail page uses scroll view)
                let scrollView = app.scrollViews.firstMatch
                XCTAssertTrue(scrollView.waitForExistence(timeout: 2), "Detail view scroll view should exist")
            }
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
