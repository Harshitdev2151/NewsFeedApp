//
//  DetailViewController.swift
//  NewsReader
//
//  Created by Harshit Kumar on 13/03/24.
//

import UIKit

class DetailViewController: UIViewController {
    var article: Article?
    var viewModel: NewsListViewModel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLbl: UILabel!
    let urlString = EndPointURLs.defaultImageURL

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Article in detailVC is \(String(describing: article))")
        initializeData()
    }

    private func initializeData() {
        self.viewModel?.fetchImage(article?.urlToImage ?? urlString, completion: { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.imageView.image = image
                }
            }
        })
        self.contentLbl.text = article?.content
        self.title = "NewsDetail"
    }
}
