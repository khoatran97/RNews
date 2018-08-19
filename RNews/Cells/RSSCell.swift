//
//  RSSCell.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/19/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit

class RSSCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
