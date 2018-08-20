//
//  NewsController.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/16/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {

    // Data
    private var listNews: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Set navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 223/255.0, blue: 79/255.0, alpha: 1.0)
        
        // Set loading view
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 0/255.0, green: 112/255.0, blue: 19/255.0, alpha: 1.0)
        
        // Set table view loading
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.updateTable()
            self?.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 0/255.0, green: 223/255.0, blue: 79/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
        
        updateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    func updateTable() {
        let listSource = DataAccess.instance.getAllRSS()
        for source in listSource {
            RSSHandler.instance.parseRSS(url: source.url) { (sourceTmp, items) in
                for item in items {
                    DataAccess.instance.addNews(title: item.title, url: item.url, description: item.descrption, pubDate: item.pubDate, source: source.id)
                }
            }
        }
        listNews = DataAccess.instance.getAllNews()!
        self.tableView.reloadData()
    }
}


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
    
    /*var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }*/
}
