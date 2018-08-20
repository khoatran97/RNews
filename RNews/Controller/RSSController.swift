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
    
    //
    var effect: UIVisualEffect!
    var updateRssDelegate: UpdateRssDelegate? = nil
    
    // Data
    var listRSS: [RSS] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set edit button
        setEditButton()
        
        // Set floating button
        self.mainAddButton.layer.shadowColor = UIColor.black.cgColor
        self.mainAddButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.mainAddButton.layer.shadowRadius = 10
        self.mainAddButton.layer.shadowOpacity = 0.5
        
        // Set blur effect
        effect = blurVisualEffectView.effect
        blurVisualEffectView.effect = nil
        self.view.sendSubview(toBack: blurVisualEffectView)
        
        // Set add view
        addView.layer.cornerRadius = 10
        
        // Add float button
        self.mainAddButton.layer.cornerRadius = 0.5 * self.mainAddButton.frame.width
        self.mainAddButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        
        // Set navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1.0)
        
        // Load data
        updateTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let result = DataAccess.instance.deleteRSS(rss: listRSS[indexPath.row])
            if result == true {
                self.updateTable()
                self.showAlert(title: "Success", message: "You deleted this RSS successfully!")
            }
            else {
                self.showAlert(title: "Error", message: "Cannot delete this RSS!")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueUpdate", sender: self)
        self.updateRssDelegate?.updateRss(rss: listRSS[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueUpdate" {
            let updateView = segue.destination as! UpdateController
            self.updateRssDelegate = updateView
        }
    }
    
    // Load data from database and update table view
    func updateTable() {
        listRSS = DataAccess.instance.getAllRSS()
        if listRSS.count == 0 {
            self.rssTableView.separatorStyle = .none
        }
        else {
            self.rssTableView.separatorStyle = .singleLine
        }
        self.rssTableView.reloadData()
    }
    
    // Show Add pop-up
    func showAddView() {
        self.view.bringSubview(toFront: self.blurVisualEffectView)
        self.view.addSubview(addView)
        self.addView.center = self.blurVisualEffectView.center
        self.addView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.addView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.blurVisualEffectView.effect = self.effect
            self.addView.alpha = 1
            self.addView.transform = CGAffineTransform.identity
        }
    }
    
    // Hide Add pop-up
    func hideAddView() {
        UIView.animate(withDuration: 0.3) {
            self.addView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.blurVisualEffectView.effect = nil
            self.addView.alpha = 0
            self.view.sendSubview(toBack: self.blurVisualEffectView)
        }
    }
    
    // Show alert (close automatically)
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: time) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // Initialize Edit button (edit table view)
    func setEditButton() {
        let editButton = UIButton(type: .custom)
        editButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        editButton.setImage(UIImage(named: "edit"), for: .normal)
        editButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        editButton.addTarget(self, action: #selector(editButton_TouchUpInside(sender: )), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    @objc func editButton_TouchUpInside(sender: UIButton) {
        if (self.rssTableView.isEditing) {
            self.rssTableView.setEditing(false, animated: true)
            sender.setImage(UIImage(named: "edit"), for: .normal)
        }
        else {
            if listRSS.count == 0 {
                return
            }
            self.rssTableView.setEditing(true, animated: true)
            sender.setImage(UIImage(named: "done"), for: .normal)
        }
    }
    
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        self.hideAddView()
    }
    
    @IBAction func addButton_TouchUpInside(_ sender: Any) {
        if urlTextField.text == nil {
            return
        }
        
        // Get data from RSS URL
        RSSHandler.instance.parseRSS(url: urlTextField.text!) {(source, items) in
            if source == nil {
                self.showAlert(title: "Error", message: "Cannot add this RSS. Please check URL and your connection and try again!")
                return
            }
            
            let source = source!
            let items = items!
            
            let title = self.titleTextField.text == "" ? source.title : self.titleTextField.text!
            let description = self.descriptionTextField.text == "" ? source.descrption : self.descriptionTextField.text!
            
            // Get logo of RSS source
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
            
            // Insert into database (Source information)
            let sourceId = DataAccess.instance.addRSS(title: title, url: source.url, description: description, logo: source.logo)
            if sourceId == Constants.ERROR_CODE {
                self.hideAddView()
                self.showAlert(title: "Error", message: "There are some errors. Please try again!")
                return
            }
            
            // Save logo to storage
            if logo != nil {
                ImageHandler.instance.saveImage(image: logo!, name: "\(sourceId).jpg")
            }
            
            // Insert into database (News)
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

// Move controls when keyboard appears
extension RSSController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, distance: -100, isUp: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, distance: -100, isUp: true)
    }
    
    func moveTextField(_ textField: UITextField, distance: Int, isUp: Bool) {
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(isUp ? distance : -distance))
        UIView.commitAnimations()
    }
}
