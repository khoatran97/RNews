//
//  RssHandler.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/16/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import Foundation

class RSSHandler: NSObject, XMLParserDelegate {
    static let instance = RSSHandler()
    
    private var source: RSS? = nil
    private var items: [News]? = []
    
    private var title: String = "" {
        didSet {
            title = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var descrption: String = "" {
        didSet {
            descrption = descrption.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var link: String = "" {
        didSet {
            link = link.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var pubDate: String = "" {
        didSet {
            pubDate = pubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var titleSource: String = "" {
        didSet {
            titleSource = titleSource.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var descrptionSource: String = "" {
        didSet {
            descrptionSource = descrptionSource.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var linkSource: String = "" {
        didSet {
            linkSource = linkSource.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var pubDateSource: String = "" {
        didSet {
            pubDateSource = pubDateSource.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var logoSource: String = "" {
        didSet {
            logoSource = logoSource.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var flgImage: Bool = false
    private var flgItem: Bool = false
    private var currentElement: String = ""
    
    func parseRSS(url: String, completion: @escaping ((_ source: RSS, _ items: [News])->Void)) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        /*let task = URLSession.shared.dataTask(with: urlRequest) {(data, respond, error) in
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
        }*/
        let parser = XMLParser(contentsOf: URL(string: url)!)
        parser?.delegate = self
        if (parser?.parse())! {
            completion(self.source!, self.items!)
        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" || elementName == "channel" {
            title = ""
            descrption = ""
            link = ""
            pubDate = ""
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
                if !flgImage {
                    linkSource += string
                }
            case "pubDate":
                pubDateSource += string
            case "image":
                if !flgItem {
                    flgImage = true
                }
            case "url":
                if flgImage {
                    logoSource += string
                }
            default:
                print("default case")
            }
        }
    }
    
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            var news = News(id: -1, title: title, url: link, descrption: descrption, pubDate: pubDate, sourceId: -1)
            
            items?.append(news)
            flgItem = false
            return
        }
        if elementName == "channel" {
            source = RSS(id: -1, title: titleSource, url: linkSource, descrption: descrptionSource, logo: logoSource)
            return
        }
        
        if elementName == "image" {
            flgImage = false
        }
    }
}
