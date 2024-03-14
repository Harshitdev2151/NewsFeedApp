//
//  NewsViewModel.swift
//  NewsReader
//
//  Created by Harshit Kumar on 10/03/24.
//

import Foundation
import UIKit

protocol NewsViewModelDelegate: AnyObject {
    func  fetchUsersDelegate(_ news: News?)
    func showError(message: String)
}

class NewsListViewModel {
    weak var delegate: NewsViewModelDelegate?
    var newsServiceProtocol: NewsServiceProtocol
    var imageLoader: ImageLoaderProtocol
    var news = News()
    init(delegate: NewsViewModelDelegate? = nil, newsServiceProtocol: NewsServiceProtocol, news: News = News(), imageLoader: ImageLoaderProtocol = AsyncImageView()) {
        self.delegate = delegate
        self.newsServiceProtocol = newsServiceProtocol
        self.news = news
        self.imageLoader = imageLoader
    }
    
    func fetchUsers() {
        // Assume a UserService for fetching users from an API
        self.newsServiceProtocol.fetchUsers { [weak self] result in
            switch result {
            case .success(let fetchedUsers):
                self?.news = fetchedUsers
                print("self.news is \(String(describing: self?.news))")
                self?.delegate?.fetchUsersDelegate(self?.news)
            case .failure(let error):
                self?.delegate?.showError(message: error.localizedDescription)
            }
        }
    }

    func fetchImage(_ url: String,completion: @escaping (UIImage?) -> Void) {
        imageLoader.fetchImage(url) { image in
            completion(image)
        }
    }
    /*
    func numberOfUsers() -> Int {
        return news.articles?.count ?? 0
    }
    
    func news(at index: Int) -> Article {
        return news.articles?[index] ?? Article()
    }
     */
}
