//
//  RSS.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/17/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import Foundation

struct RSS {
    var id: Int
    var title: String
    var url: String
    var descrption: String
    var logo: String
    
    init(id: Int, title: String, url: String, descrption: String, logo: String) {
        self.id = id
        self.title = title
        self.url = url
        self.descrption = descrption
        self.logo = logo
    }
    
    init() {
        self.id = -1
        self.title = ""
        self.url = ""
        self.descrption = ""
        self.logo = ""
    }
}
