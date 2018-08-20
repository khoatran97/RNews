//
//  Converters.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/20/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import Foundation

class Converters {
    class func stringToDate(string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let date = formatter.date(from: string)
        return date!
    }
    
    class func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd/MM/yyyy HH:mm:ss Z"
        return formatter.string(from: date)
    }
}
