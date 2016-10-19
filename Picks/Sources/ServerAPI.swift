//
//  ServerAPI.swift
//  Picks
//
//  Created by Jinhong Kim on 10/5/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import Foundation


protocol ServerAPI: class {
    var url: URL? { get }
    
    var request: URLRequest? { get }

    var response: URLResponse? { get set }

    var completionHandler: ((Error?) -> Void)? { get set }
}


protocol FetchAPI: ServerAPI {
    var task: URLSessionDataTask? { get set }
    
    var data: Data? { get set }
    
    func fetch() -> Bool
    
    func cancel()
}


extension FetchAPI {
    func fetch() -> Bool {
        guard let fetchRequest = self.request else {
            return false
        }
        
        
        let taskHandler = { (data: Data?, response: URLResponse?, error: Error?) in
            print("\(response)")
            print("\(error)")
            
            self.data = data
            self.response = response
            
            if let handler = self.completionHandler {
                handler(error)
            }
        }
        
        
        task = URLSession.shared.dataTask(with: fetchRequest, completionHandler: taskHandler)
        task!.resume()
        
        return true
    }
    
    func cancel() {
        task?.cancel()
    }
}


class SearchBookAPI: FetchAPI {
    var url: URL? {
        var comps = URLComponents()
        
        comps.scheme = "https"
        comps.host = "openapi.naver.com"
        comps.path = "/v1/search/book.xml"

        if keyword.isEmpty == false {
            comps.query = "display=100&query=" + keyword
        }

        return comps.url
    }
    
    var request: URLRequest? {
        guard let apiURL = url else {
            return nil
        }
        
        let contentHeaders = ["X-Naver-Client-Id" : "sdWBtTMuVZWEshemnu2g",
                              "X-Naver-Client-Secret" : "HkGrOnINi7"]
        var request = URLRequest(url: apiURL)
        
        for (header, value) in contentHeaders {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        return request
    }

    var response: URLResponse?
    
    var completionHandler: ((Error?) -> Void)?
    
    var data: Data?
    
    var task: URLSessionDataTask?

    var keyword: String
    
    
    init(keyword: String) {
        self.keyword = keyword
    }
}


class SearchFilmAPI: FetchAPI {
    var url: URL? {
        var comps = URLComponents()
        
        comps.scheme = "https"
        comps.host = "openapi.naver.com"
        comps.path = "/v1/search/movie.xml"
        
        if keyword.isEmpty == false {
            comps.query = "display=100&query=" + keyword
        }
        
        return comps.url
    }
    
    var request: URLRequest? {
        guard let apiURL = url else {
            return nil
        }
        
        let contentHeaders = ["X-Naver-Client-Id" : "sdWBtTMuVZWEshemnu2g",
                              "X-Naver-Client-Secret" : "HkGrOnINi7"]
        var request = URLRequest(url: apiURL)
        
        for (header, value) in contentHeaders {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        return request
    }

    var response: URLResponse?
    
    var completionHandler: ((Error?) -> Void)?
    
    var data: Data?
    
    var task: URLSessionDataTask?
    
    var keyword: String
    
    
    init(keyword: String) {
        self.keyword = keyword
    }
}
