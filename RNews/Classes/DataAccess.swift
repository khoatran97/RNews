//
//  DataAccess.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/16/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import UIKit
import CoreData

class DataAccess {
    private let NOT_EXIST_CODE = -1
    private let ERROR_CODE = -2
    
    static let instance = DataAccess()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private init(){
        // Do something
    }
    
    // RSS resource
    func getAllRSS() -> [RSS]? {
        var result: [RSS]? = []
        let fetchRequest: NSFetchRequest<RSS> = RSS.fetchRequest()
        do {
            result = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            result = nil
        }
        
        return result
    }
    
    func addRSS(title: String, url: String, logo: String, description: String) -> Int {
        let intCheck = checkRSS(url: url)
        
        if intCheck == NOT_EXIST_CODE {
            let objContext = self.appDelegate.persistentContainer.viewContext
            
            let id = UserDefaults.standard.integer(forKey: "numberOfRSS") as Int
            
            let newRSS = RSS(context: objContext)
            newRSS.id = Int16(id)
            newRSS.title = title
            newRSS.descrption = description
            newRSS.url = url
            newRSS.logo = logo
            
            try self.appDelegate.saveContext()
            UserDefaults.standard.set(id + 1, forKey: "numberOfRSS")
            
            return id
        }
        
        if intCheck == ERROR_CODE {
            return -1
        }
        
        if intCheck != ERROR_CODE && intCheck != NOT_EXIST_CODE {
            return intCheck
        }
        
        return -1
    }
    
    func updateRSS(id: Int, title: String, url: String, logo: String, description: String) -> Bool {
        var resultRSS: [RSS] = []
        var currentRSS: RSS
        let fetchRequest: NSFetchRequest<RSS> = RSS.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [String(id)])
        do {
            resultRSS = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            return false
        }
        
        if resultRSS.count == 1 {
            currentRSS = resultRSS.first!
            
            currentRSS.title = title
            currentRSS.descrption = description
            currentRSS.url = url
            currentRSS.logo = logo
            
            do {
                try self.appDelegate.saveContext()
            } catch {
                return false
            }
            return true
        }
        return false
    }
    
    func checkRSS(url: String) -> Int {
        var resultRSS: [RSS] = []
        let fetchRequest: NSFetchRequest<RSS> = RSS.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", argumentArray: [url])
        do {
            resultRSS = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            return ERROR_CODE
        }
        
        if resultRSS.count == 0 {
            return NOT_EXIST_CODE
        }
        else {
            return Int(resultRSS.first!.id)
        }
    }
    
    // Offline news
    func getAllNews() -> [News]? {
        var result: [News]? = []
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        do {
            result = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            result = nil
        }
        
        return result
    }
    
    func addNews(title: String, url: String, description: String, pubDate: String, source: Int) -> Int {
        let intCheck = checkNews(url: url)
        
        if intCheck == NOT_EXIST_CODE {
            let objContext = self.appDelegate.persistentContainer.viewContext
            
            let id = UserDefaults.standard.integer(forKey: "numberOfNews") as Int
            
            let newNews = News(context: objContext)
            newNews.id = Int16(id)
            newNews.title = title
            newNews.descrption = description
            newNews.url = url
            newNews.pubdate = pubDate
            newNews.sourceid = Int16(source)
            
            self.appDelegate.saveContext()
            
            UserDefaults.standard.set(id + 1, forKey: "numberOfNews")
            
            return id
        }
        
        if intCheck == ERROR_CODE {
            return -1
        }
        
        if intCheck != ERROR_CODE && intCheck != NOT_EXIST_CODE {
            return intCheck
        }
        
        return -1
    }
    
    func checkNews(url: String) -> Int {
        var resultNews: [News] = []
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", argumentArray: [url])
        do {
            resultNews = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            return ERROR_CODE
        }
        
        if resultNews.count == 0 {
            return NOT_EXIST_CODE
        }
        else {
            return Int(resultNews.first!.id)
        }
    }
}
