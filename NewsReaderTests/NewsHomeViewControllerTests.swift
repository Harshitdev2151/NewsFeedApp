//
//  NewsHomeViewControllerTests.swift
//  NewsReaderTests
//
//  Created by Harshit Kumar on 15/03/24.
//

import XCTest
@testable import NewsReader

final class NewsHomeViewControllerTests: XCTestCase {

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

    func testImageLoaderForSuccess() {
        let myExpectation = expectation(description: "Expected the successful API for news articles called")

        sut.news = News(articles: [Article(title: "NewsTitle", description: "NewsDesc")])
        mockimageLoader.successRetrievalOfImage = true
        let newsTableViewCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! NewsTableViewCell
        DispatchQueue.main.async {
            guard let data1 = newsTableViewCell.img.image?.pngData(), let data2 = UIImage(named: "flower")!.pngData() else {
                XCTFail("Data should not be nil")
                return
            }
            XCTAssertEqual(data1, data2)
            XCTAssertNotNil(newsTableViewCell.img.image)
            myExpectation.fulfill()
        }
        self.wait(for: [myExpectation], timeout: 5)
    }


    func testImageLoaderForFailure() {
        let myExpectation = expectation(description: "Expected the successful API for news articles called")

        sut.news = News(articles: [Article(title: "NewsTitle", description: "NewsDesc")])
        mockimageLoader.successRetrievalOfImage = false
        let newsTableViewCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! NewsTableViewCell
        DispatchQueue.main.async {
            guard let data1 = newsTableViewCell.img.image?.pngData(), let data2 = UIImage(named: "flower123")!.pngData() else {
                XCTFail("Data should not be nil")
                return
            }
            XCTAssertEqual(data1, data2)
            XCTAssertNotNil(newsTableViewCell.img.image)
            myExpectation.fulfill()
        }
        self.wait(for: [myExpectation], timeout: 5)
    }

    func testCellForRowAtIndexPath() {
        let newsTableViewCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! NewsTableViewCell
        XCTAssertNotNil(newsTableViewCell)
    }

    func testNumberOfRows() {
        sut.news = News(articles: [Article(title: "NewsTitle", description: "NewsDesc")])
        let numberOfRows =  sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, sut.news?.articles?.count)
    }

    func testTableCellsModel() {
        let article = Article(title: "NewsTitle", description: "NewsDesc", publishedAt: "2024-03-13T18:56:10Z")
        let newsTableViewCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! NewsTableViewCell
        newsTableViewCell.configgureWith(article)
        XCTAssertEqual(newsTableViewCell.publishedAt.text, article.publishedAt?.convertDateFormat())
    }

    func testDidSelectRow() {
        sut.news = News(articles: [Article(title: "NewsTitle", description: "NewsDesc")])
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(sut.calledSegue.destination as? DetailViewController)
    }

    func testDetailVC() {
        sut.news = News(articles: [Article(title: "NewsTitle", description: "NewsDesc", content: "Content")])
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        if let detailVC = sut.calledSegue.destination as? DetailViewController {
            detailVC.loadViewIfNeeded()
            detailVC.article = sut.news?.articles?[0]
            detailVC.viewModel = NewsListViewModel(newsServiceProtocol: NewsService(), imageLoader: MockImageLoader())
            XCTAssertNotNil(detailVC.contentLbl.text)
            XCTAssertNotNil(detailVC.imageView.image)
        }
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
