//
//  NewsInfo.swift
//  NewsReader
//
//  Created by Harshit Kumar on 10/03/24.
//

import Foundation

struct News: Codable {
    var articles: [Article]?
}

struct Article: Codable, Hashable {
    var title: String?
    var description: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}
