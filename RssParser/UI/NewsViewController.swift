//
//  NewsViewController.swift
//  RssParser
//
//  Created by Константин Киски on 18.06.2020.
//  Copyright © 2020 Константин Киски. All rights reserved.
//

import UIKit
import Foundation

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    // MARK: - UI Elements
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()

    // MARK: - Variables
    
    private var posts = [Post]()
    private var parser = XMLParser()
    private var tempPost: Post?
    private var tempElement: String?
    
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoad()
        initRefreshControl()
    }

    // MARK: - Private function
    
    private func startLoad() {
        tableView.isHidden = true
        loader.startAnimating()
        loader.isHidden = false
        loadNews()
    }
    
    private func stopLoad() {
        tableView.isHidden = false
        loader.isHidden = true
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    private func loadNews() {
        posts.removeAll()
        parser = XMLParser(contentsOf: (URL(string:"https://www.vesti.ru/vesti.rss")!))!
        parser.delegate = self
        parser.parse()
    }
    
    private func initRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .systemBlue
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadNews()
    }
    
    // MARK: - XMLParser Delegate
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        let alert = UIAlertController(title: "Error", message: parseError.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        tempElement = elementName
        if elementName == "item" {
            tempPost = Post(title: "", link: "", date: "")
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let post = tempPost {
                posts.append(post)
            }
            tempPost = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let post = tempPost {
            if tempElement == "title" {
                tempPost?.title = post.title+string
            } else if tempElement == "link" {
                tempPost?.link = post.link+string
            } else if tempElement == "pubDate" {
                tempPost?.date = post.date+string
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.stopLoad()
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        let currentPost = posts[indexPath.row]
        cell.setData(data: NewsTableViewCell.NewsCellData(title: currentPost.title, pubDate: currentPost.date))
        return cell
    }
}

