//
//  MockNewsService.swift
//  NewsReaderTests
//
//  Created by Harshit Kumar on 10/03/24.
//

import Foundation
import UIKit
@testable import NewsReader


class MockNewsService: NewsServiceProtocol {
     var isFailedService = false
     func fetchUsers(completion: @escaping (Result<NewsReader.News, NewsReader.NetworkError>) -> Void) {
        if !isFailedService {
            completion(.success(news))
        } else {
            completion(.failure(.requestFailed))
        }
    }
    
     var news: News {
        return News(articles: [Article(title: "NewsTitle", description: "NewsDesc")])
    }
    
}

class MockImageLoader: ImageLoaderProtocol {
    var image: UIImage?
   
   var successRetrievalOfImage = true
    
    func fetchImage(_ url: String, completion: @escaping (UIImage?) -> Void) {
        if successRetrievalOfImage {
            self.image = UIImage(named: "flower")!
            completion(UIImage(named: "flower")!)
        } else {
            self.image = nil
            completion(nil)
        }
    }

}
