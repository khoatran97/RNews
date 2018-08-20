//
//  ViewController.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/16/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit

class UpdateController: UIViewController {

    // Outlet
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    //
    var RSS: RSS!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fill info
        logoImageView.image = ImageHandler.instance.getImage(name: "\(RSS.id).jpg")
        urlTextField.text = RSS.url
        titleTextField.text = RSS.title
        descriptionTextField.text = RSS.descrption
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Action
    @IBAction func updateButton_TouchUpInside(_ sender: Any) {
        let title = titleTextField.text!
        let descrption = descriptionTextField.text!
        
        let alertView = UIAlertController(title: "Confirmation", message: "Do you want to update it?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
            let result = DataAccess.instance.updateRSS(id: self.RSS.id, title: title, description: descrption)
            if result {
                let alert = UIAlertController(title: "Success", message: "Update Succeeded", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let time = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: time) {
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Cannot update at moment. Please try again!", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let time = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: time) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertView.addAction(yesAction)
        alertView.addAction(noAction)
        self.present(alertView, animated: true, completion: nil)
    }
}

extension UpdateController: UpdateRssDelegate {
    func updateRss(rss: RSS) {
        self.RSS = rss
    }
}

extension UpdateController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, distance: -150, isUp: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, distance: -150, isUp: true)
    }
    
    func moveTextField(_ textField: UITextField, distance: Int, isUp: Bool) {
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.3)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(isUp ? distance : -distance))
        UIView.commitAnimations()
    }
}

