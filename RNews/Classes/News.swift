//
//  News.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/17/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import Foundation

struct News {
    var id: Int
    var title: String
    var url: String
    var descrption: String
    var pubDate: String
    var sourceId: Int
    init(id: Int, title: String, url: String, descrption: String, pubDate: String, sourceId: Int) {
        self.id = id
        self.title = title
        self.url = url
        self.descrption = descrption
        self.pubDate = pubDate
        self.sourceId = sourceId
    }
    
    init() {
        self.id = -1
        self.title = ""
        self.url = ""
        self.descrption = ""
        self.pubDate = ""
        self.sourceId = -1
    }
}
