//
//  NewsListViewModelTest.swift
//  NewsReaderTests
//
//  Created by Harshit Kumar on 10/03/24.
//

import XCTest
@testable import NewsReader

final class NewsListViewModelTest: XCTestCase {
    var storyboard: UIStoryboard!
    var sut: NewsHomeViewController!
    var newsListViewModel: NewsListViewModel!
    var mockNewsService: MockNewsService!
    var mockimageLoader: MockImageLoader!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "NewsHomeViewController") as NewsHomeViewController
        sut.loadViewIfNeeded()
        mockNewsService = MockNewsService()
        mockimageLoader = MockImageLoader()
        sut.viewModel = NewsListViewModel(delegate: sut, newsServiceProtocol: mockNewsService,imageLoader: mockimageLoader )
    }

    override func tearDownWithError() throws {
        storyboard = nil
        mockNewsService = nil
        mockimageLoader = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNewsListForSuccessScenario() throws {
        let myExpectation = expectation(description: "Expected the successful API for news articles called")

        mockNewsService.isFailedService = false
        sut.viewModel.fetchUsers()
        myExpectation.fulfill()

        XCTAssertEqual(sut.viewModel.news.articles?.count, 1)
        self.wait(for: [myExpectation], timeout: 5)
    }


    func testNewsListForfailedRequestScenario() throws {
        let myExpectation = expectation(description: "Expected the failed API for news articles called")
        mockNewsService.isFailedService = true
        sut.viewModel.fetchUsers()
        myExpectation.fulfill()

        XCTAssertNil(sut.viewModel.news.articles)
        self.wait(for: [myExpectation], timeout: 5)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}



