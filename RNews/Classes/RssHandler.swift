//
//  RssHandler.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/16/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import Foundation

class RssHandler: NSObject, XMLParserDelegate {
    static let instance = RssHandler()
    
    private var source: RSS? = nil
    private var items: [News]? = []
    
    private var title: String = ""
    private var descrption: String = ""
    private var link: String = ""
    private var pubDate: String = ""
    
    private var titleSource: String = ""
    private var descrptionSource: String = ""
    private var linkSource: String = ""
    private var pubDateSource: String = ""
    
    private var flgItem: Bool = false
    private var currentElement: String = ""
    
    func parseRSS(url: String, completion: @escaping ((_ source: RSS, _ items: [News])->Void)) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, respond, error) in
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                completion(self.source!, self.items!)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" || elementName == "channel" {
            title = ""
            descrption = ""
            link = ""
        }
        
        if elementName == "item" {
            flgItem = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if flgItem {
            switch currentElement {
            case "title":
                title += string
            case "description":
                descrption += string
            case "link":
                link += string
            case "pubDate":
                pubDate += string
            default:
                print("default case")
            }
        }
        else {
            switch currentElement {
            case "title":
                titleSource += string
            case "description":
                descrptionSource += string
            case "link":
                linkSource += string
            case "pubDate":
                pubDateSource += string
            default:
                print("default case")
            }
        }
    }
    
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let news: News = News()
            news.title = title
            news.descrption = descrption
            news.url = link
            news.pubdate = pubDate
            
            items?.append(news)
            return
        }
        if elementName == "channel" {
            source = RSS()
            source?.title = titleSource
            source?.descrption = descrptionSource
            source?.url = linkSource
            
            return
        }
    }
}
