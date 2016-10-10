//
//  SearchManager.swift
//  Picks
//
//  Created by Jinhong Kim on 9/30/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import Foundation


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
            print("book title: \(item.title)")
            print("book img uri: \(item.imageURI)")
        }
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
            guard let title = item["title"]?.first?.value else {
                continue
            }
            
            guard let imgURI = item["image"]?.first?.value else {
                continue
            }
            
            bookItems.append(Book(title: title, imageURI: imgURI))
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


