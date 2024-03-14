//
//  ViewController.swift
//  NewsReader
//
//  Created by Harshit Kumar on 10/03/24.
//

import UIKit

class NewsHomeViewController: UIViewController {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: NewsListViewModel!
    var news: News?
    open var calledSegue: UIStoryboardSegue!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        self.initializeViewModel()
        activityIndicatorView.startAnimating()
        self.title = "News"
    }

    func initializeViewModel() {
        self.viewModel = NewsListViewModel(delegate: self, newsServiceProtocol: NewsService())
        viewModel.fetchUsers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension NewsHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
         return viewModel.numberOfUsers()
         */
        print("article clount is ")
        print(news?.articles?.count ?? 0)
        return news?.articles?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell
        let news = news?.articles?[indexPath.row] ?? Article()
        cell?.configgureWith(news)
        viewModel.fetchImage(news.urlToImage ?? EndPointURLs.defaultImageURL) { img in
            cell?.setImage(img ?? UIImage(named: "flower123"))
        }
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //  return 400
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = news?.articles?[indexPath.row] ?? Article()
        self.performSegue(withIdentifier: "DestinationVC", sender: article)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailViewController, let article = sender as? Article {
            calledSegue = segue
            destinationVC.article = article
            destinationVC.viewModel = self.viewModel
        }
    }
}

extension NewsHomeViewController: NewsViewModelDelegate {
    func fetchUsersDelegate(_ news: News?) {
        self.news = news
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.tableView.reloadData()
        }
    }

    func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()

            let alertController = UIAlertController(title: "Error",
                                                    message: message.localizedUppercase, preferredStyle: UIAlertController.Style.alert)

            alertController.addAction(UIAlertAction(title: "Reload", 
                                                    style: UIAlertAction.Style.default) { [weak self] _ in
                // Put your code here
                self?.activityIndicatorView.startAnimating()
                self?.viewModel.fetchUsers()
            })
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
