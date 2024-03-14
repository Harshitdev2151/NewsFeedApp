//
//  NewsTableViewCell.swift
//  NewsReader
//
//  Created by Harshit Kumar on 10/03/24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var img: UIImageView!
    func configgureWith(_ article: Article) {
        self.title.text = article.title
        self.desc.text = article.description?.filter { !" \n\t\r".contains($0) }
        self.publishedAt.text = article.publishedAt?.convertDateFormat()
        self.img.image = UIImage(named: "flower123")
    }

    func setImage(_ img: UIImage?) {
        DispatchQueue.main.async {
            self.img.image = img
            self.img.reloadInputViews()
        }
    }

    override func prepareForReuse() {
        self.img.image = nil
    }
}
