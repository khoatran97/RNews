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
    
    // entity -> class
    func createRSS(entity: EntityRSS) -> RSS {
        var rss = RSS(id: Int(entity.id), title: entity.title!, url: entity.url!, descrption: entity.descrption!)
        return rss
    }
    
    func createNews(entity: EntityNews) -> News {
        var news = News(id: Int(entity.id), title: entity.title!, url: entity.url!, descrption: entity.descrption!, pubDate: entity.pubdate!, sourceId: Int(entity.sourceid))
        return news
    }
    
    // RSS resource
    func getAllRSS() -> [RSS] {
        var result: [EntityRSS]? = []
        var listRSS: [RSS] = []
        let fetchRequest: NSFetchRequest<EntityRSS> = EntityRSS.fetchRequest()
        do {
            result = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            result = nil
        }
        for rss in result! {
            listRSS.append(createRSS(entity: rss))
        }
        return listRSS
    }
    
    func addRSS(title: String, url: String, description: String) -> Int {
        let intCheck = checkRSS(url: url)
        
        if intCheck == NOT_EXIST_CODE {
            let objContext = self.appDelegate.persistentContainer.viewContext
            
            let id = UserDefaults.standard.integer(forKey: "numberOfRSS") as Int
            
            let newRSS = EntityRSS(context: objContext)
            newRSS.id = Int16(id)
            newRSS.title = title
            newRSS.descrption = description
            newRSS.url = url
            
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
        var resultRSS: [EntityRSS] = []
        var currentRSS: EntityRSS
        let fetchRequest: NSFetchRequest<EntityRSS> = EntityRSS.fetchRequest()
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
        var resultRSS: [EntityRSS] = []
        let fetchRequest: NSFetchRequest<EntityRSS> = EntityRSS.fetchRequest()
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
        var result: [EntityNews]? = []
        var listNews: [News] = []
        let fetchRequest: NSFetchRequest<EntityNews> = EntityNews.fetchRequest()
        do {
            result = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            result = nil
        }
        for rss in result! {
            listNews.append(createNews(entity: rss))
        }
        return listNews
    }
    
    func addNews(title: String, url: String, description: String, pubDate: String, source: Int) -> Int {
        let intCheck = checkNews(url: url)
        
        if intCheck == NOT_EXIST_CODE {
            let objContext = self.appDelegate.persistentContainer.viewContext
            
            let id = UserDefaults.standard.integer(forKey: "numberOfNews") as Int
            
            let newNews = EntityNews(context: objContext)
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
        var resultNews: [EntityNews] = []
        let fetchRequest: NSFetchRequest<EntityNews> = EntityNews.fetchRequest()
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
