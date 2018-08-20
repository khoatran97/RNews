//
//  NewsCell.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/16/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    // Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.text = ""
        descriptionLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
