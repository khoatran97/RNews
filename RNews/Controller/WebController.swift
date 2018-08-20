//
//  WebController.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/20/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController, OpenUrlDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    //
    var RequestedURL: String!
    var LoadingSpinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set spinner
        LoadingSpinner.hidesWhenStopped = true
        self.view.addSubview(LoadingSpinner)
        LoadingSpinner.center = self.webView.center
        
        // Load url
        let url = URL(string: RequestedURL)
        let request = URLRequest(url: url!)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openUrl(url: String) {
        RequestedURL = url
    }
}


extension WebController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        LoadingSpinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingSpinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        LoadingSpinner.stopAnimating()
    }
}
