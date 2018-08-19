//
//  ViewController.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/16/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit

class AddController: UIViewController {

    // Outlet
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Action
    @IBAction func addButton_TouchUpInside(_ sender: Any) {
        RSSHandler.instance.parseRSS(url: urlTextField.text!) {(source, items) in
            let sourceId = DataAccess.instance.addRSS(title: source.title, url: source.url, description: source.descrption, logo: source.logo)
            for item in items {
                let resultCode = DataAccess.instance.addNews(title: item.title, url: item.url, description: item.descrption, pubDate: item.pubDate, source: sourceId)
                print(resultCode)
            }
        }
        
        //
    }
    
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        //
    }
}

