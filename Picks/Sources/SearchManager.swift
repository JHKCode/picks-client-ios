//
//  SearchManager.swift
//  Picks
//
//  Created by Jinhong Kim on 9/30/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import Foundation
import Security


extension Book: InitializableWithXML {
    init?(xmlElement item: XMLElement) {
        guard let title = item["title"]?.first?.value else {
            return nil
        }
        
        guard let imgURI = item["image"]?.first?.value, imgURI.isEmpty == false else {
            return nil
        }

        guard let author = item["author"]?.first?.value else {
            return nil
        }
        
        guard let date = item["pubdate"]?.first?.value else {
            return nil
        }
        
        guard let description = item["description"]?.first?.value else {
            return nil
        }
        
        guard let isbn = item["isbn"]?.first?.value else {
            return nil
        }

        guard let publisher = item["publisher"]?.first?.value else {
            return nil
        }

        self.title = title
        self.imageURI = imgURI
        self.creator = author
        self.desc = description
        self.isbn = isbn
        self.publisher = publisher

        // convert date string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        self.date = dateFormatter.date(from: date) ?? Date()
        
        self.type = PickItemType.Book
        self.id = String("b" + isbn + date).SHA256()
    }
}


extension Film: InitializableWithXML {
    init?(xmlElement item: XMLElement) {
        guard let title = item["title"]?.first?.value else {
            return nil
        }
        
        guard let imgURI = item["image"]?.first?.value, imgURI.isEmpty == false else {
            return nil
        }
        
        guard let director = item["director"]?.first?.value else {
            return nil
        }
        
        guard let date = item["pubDate"]?.first?.value else {
            return nil
        }
        
        guard let actor = item["actor"]?.first?.value else {
            return nil
        }
        
        
        self.title = title
        self.imageURI = imgURI
        self.creator = director
        self.cast = actor
        self.desc = ""
        
        // convert date string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        self.date = dateFormatter.date(from: date) ?? Date()
        
        self.type = PickItemType.Film
        self.id = String("f" + title + date).SHA256()
    }
}


extension String {
    func SHA256() -> String {
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        if let messageData = self.data(using:String.Encoding.utf8) {
            let _ = digestData.withUnsafeMutableBytes {digestBytes in
                messageData.withUnsafeBytes {messageBytes in
                    CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
                }
            }
        }
        
        let hexStr = digestData.reduce("") {
            $0 + String(format: "%02X", $1)
        }
        
        return hexStr
    }
}


class SearchManager {
    static let SearchDidFinishNotificationName = NSNotification.Name(rawValue: "SearchDidFinish")
    
    var fetchAPI: FetchAPI?
    
    var items = Array<PickItem>()
    
    
    init () {
    }
    
    
    func createPickItems<T: InitializableWithXML>(data: Data?) -> Array<T>? {
        guard let xmlData = data else {
            return nil
        }
        
        guard let root = XMLDoc(data: xmlData).rootElement else {
            return nil
        }
        
        root.description()
        
        guard let channel = root["channel"]?.first else {
            return nil
        }
        
        var pickItems = Array<T>()
        
        
        // items
        guard let items = channel.elements(name: "item") else {
            return nil
        }
        
        for item in items {
            if let item = T(xmlElement: item) {
                pickItems.append(item)
            }
        }

        
        return pickItems
    }
    
    
    func search(keyword: String, category: String) {
        // clear previous results
        self.items.removeAll()
        
        let notifyDidFinish = {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: SearchManager.SearchDidFinishNotificationName, object: self)
            }
        }
        
        
        if category == "Book" {
            fetchAPI = SearchBookAPI(keyword: keyword)
            fetchAPI?.completionHandler = { (error: Error?) in
                if let fetchError = error {
                    print("\(fetchError)")
                    return
                }
                
                if let searchItems: Array<Book> = self.createPickItems(data: self.fetchAPI?.data) {
                    self.items = searchItems
                }
                
                notifyDidFinish()
            }
        }
        else {
            fetchAPI = SearchFilmAPI(keyword: keyword)
            fetchAPI?.completionHandler = { (error: Error?) in
                if let fetchError = error {
                    print("\(fetchError)")
                    return
                }
                
                if let searchItems: Array<Film> = self.createPickItems(data: self.fetchAPI?.data) {
                    self.items = searchItems
                }
                
                notifyDidFinish()
            }
        }

        
        if fetchAPI?.fetch() == false {
            print("fetch fail")
        }
    }
}


