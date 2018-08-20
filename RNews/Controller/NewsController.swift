//
//  NewsController.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/16/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {

    @IBOutlet var emptyView: UIView!
    
    var openUrlDelegate: OpenUrlDelegate? = nil
    
    // Data
    private var listNews: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set tab bar image
        setTabBar()
        
        // Set navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1.0)
        
        // Set loading view
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 0/255.0, green: 112/255.0, blue: 19/255.0, alpha: 1.0)
        
        // Set table view loading
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.async {
                self?.updateTable()
                self?.tableView.dg_stopLoading()
            }
        }, loadingView: loadingView)
        
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
        
        // Set empty view
        emptyView.center = self.tableView.center
        
        updateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNews.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        cell.titleLabel.text = listNews[indexPath.row].title
        cell.pubDateLabel.text = Converters.dateToString(date: listNews[indexPath.row].pubDate)
        cell.descriptionLabel.text = listNews[indexPath.row].descrption.htmlToAttributedString()?.string
        return cell
    }

    // Load data from database and refresh table view
    func updateTable() {
        let listSource = DataAccess.instance.getAllRSS()
        for source in listSource {
            RSSHandler.instance.parseRSS(url: source.url) { (sourceTmp, items) in
                if items == nil {
                    return
                }
                for item in items! {
                    DataAccess.instance.addNews(title: item.title, url: item.url, description: item.descrption, pubDate: item.pubDate, source: source.id)
                }
            }
        }
        listNews = DataAccess.instance.getAllNews()!
        if listNews.count == 0 {
            self.tableView.backgroundView = emptyView
            self.tableView.separatorStyle = .none
        }
        else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        self.tableView.reloadData()
    }
    
    // Open in web browser when clicking
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = listNews[indexPath.row].url
        
        self.performSegue(withIdentifier: "segueWebView", sender: self)
        self.openUrlDelegate?.openUrl(url: url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueWebView" {
            let webView = segue.destination as! WebController
            self.openUrlDelegate = webView
        }
    }
    
    // Set image for tab bar
    func setTabBar() {
        let newsItem = self.tabBarController?.tabBar.items![0]
        newsItem?.image = UIImage(named: "news")?.withRenderingMode(.alwaysOriginal)
        newsItem?.selectedImage = UIImage(named: "news")?.withRenderingMode(.alwaysOriginal)
        newsItem?.imageInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        
        let rssItem = self.tabBarController?.tabBar.items![1]
        rssItem?.image = UIImage(named: "rss")?.withRenderingMode(.alwaysOriginal)
        rssItem?.selectedImage = UIImage(named: "rss")?.withRenderingMode(.alwaysOriginal)
        rssItem?.imageInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
}

// Display HTML text
extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8)
            else {
                return NSAttributedString()
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            return NSAttributedString()
        }
    }
}
