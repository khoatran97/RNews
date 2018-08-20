//
//  RSSController.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/19/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit

class RSSController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var rssTableView: UITableView!
    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    @IBOutlet var addView: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mainAddButton: UIButton!
    
    var effect: UIVisualEffect!
    
    // Data
    var listRSS: [RSS] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set blur effect
        effect = blurVisualEffectView.effect
        blurVisualEffectView.effect = nil
        
        // Set add view
        addView.layer.cornerRadius = 10
        
        // Add float button
        self.mainAddButton.layer.cornerRadius = 0.5 * self.mainAddButton.frame.width
        
        // Set navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 223/255.0, blue: 79/255.0, alpha: 1.0)
        
        // Load data
        updateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRSS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSCell", for: indexPath) as! RSSCell
        
        cell.titleLabel.text = listRSS[indexPath.row].title
        cell.descriptionLabel.text = listRSS[indexPath.row].url
        let logo = ImageHandler.instance.getImage(name: "\(listRSS[indexPath.row].id).jpg")
        cell.logoImage.image = logo
        
        return cell
    }

    func updateTable() {
        listRSS = DataAccess.instance.getAllRSS()
        self.rssTableView.reloadData()
    }
    
    func showAddView() {
        self.view.addSubview(addView)
        self.addView.center = self.view.center
        self.addView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.addView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.blurVisualEffectView.effect = self.effect
            self.addView.alpha = 1
            self.addView.transform = CGAffineTransform.identity
        }
    }
    
    func hideAddView() {
        UIView.animate(withDuration: 0.3) {
            self.addView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.blurVisualEffectView.effect = nil
            self.addView.alpha = 0
        }
        
        self.view.bringSubview(toFront: (self.tabBarController?.view)!)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: time) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        self.hideAddView()
    }
    
    @IBAction func addButton_TouchUpInside(_ sender: Any) {
        if urlTextField.text == nil {
            return
        }
        
        RSSHandler.instance.parseRSS(url: urlTextField.text!) {(source, items) in
            let title = self.titleTextField.text == "" ? source.title : self.titleTextField.text
            let description = self.descriptionTextField.text == "" ? source.descrption : self.descriptionTextField.text
            
            var logo: UIImage? = nil
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            ImageHandler.instance.getImageFromUrl(url: source.logo) { (image, error) in
                if image != nil {
                    logo = image
                }
                dispatchGroup.leave()
            }
            dispatchGroup.wait(timeout: .now() + 5)
            
            let sourceId = DataAccess.instance.addRSS(title: source.title, url: source.url, description: source.descrption, logo: source.logo)
            if sourceId == Constants.ERROR_CODE {
                self.hideAddView()
                self.showAlert(title: "Error", message: "There are some errors. Please try again!")
                return
            }
            if logo != nil {
                ImageHandler.instance.saveImage(image: logo!, name: "\(sourceId).jpg")
            }
            for item in items {
                let resultCode = DataAccess.instance.addNews(title: item.title, url: item.url, description: item.descrption, pubDate: item.pubDate, source: sourceId)
                print(resultCode)
            }
            self.hideAddView()
            self.showAlert(title: "Success", message: "You added new RSS successfully")
            self.updateTable()
        }
    }
    
    @IBAction func mainAddButton_TouchUpInside(_ sender: Any) {
        self.showAddView()
    }
    
}

extension RSSController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
