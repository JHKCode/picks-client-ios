//
//  SearchManager.swift
//  Picks
//
//  Created by Jinhong Kim on 9/30/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import Foundation
import Security


struct Books {
    var items = Array<Book>()
    var total: Int = 0
    var count: Int {
        return items.count
    }
    
    func description() {
        print("book total: \(total)")
        print("book count: \(count)")
        
        for item in items {
            item.description()
        }
    }
}


extension Book {
    init?(xmlElement item: XMLElement) {
        guard let title = item["title"]?.first?.value else {
            return nil
        }
        
        guard let imgURI = item["image"]?.first?.value else {
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
    var bookAPI: SearchBookAPI?
    var books: Books
    
    init () {
        books = Books()
    }
    
    
    func createBooks(data: Data) -> Books? {
        guard let root = XMLDoc(data: data).rootElement else {
            return nil
        }
        
        root.description()
        
        guard let channel = root["channel"]?.first else {
            return nil
        }
        
        guard let total = channel["total"]?.first else {
            return nil
        }

        
        var books = Books()
        var bookItems = Array<Book>()
        
        // total
        if let totalCount = Int(total.value) {
            books.total = totalCount
        }
        
        
        // items
        guard let items = channel.elements(name: "item") else {
            return nil
        }
        
        for item in items {
            if let book = Book(xmlElement: item) {
                bookItems.append(book)
            }
        }
        
        books.items = bookItems
        
        
        return books
    }
    
    
    func search(keyword: String) {
        bookAPI = SearchBookAPI(keyword: keyword)
        bookAPI?.fetch(completionHandler: { (data: Data?, error: Error?) in
            guard let bookData = data else {
                return
            }
            
            guard let newBooks = self.createBooks(data: bookData) else {
                return
            }
            
            if self.books.total == 0 {
                self.books.total = newBooks.total
            }
            
            self.books.items.append(contentsOf: newBooks.items)
            self.books.description()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BookSearchDidFinish"), object: self)
            }
        })
    }
}


