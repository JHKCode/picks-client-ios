//
//  ServerAPI.swift
//  Picks
//
//  Created by Jinhong Kim on 10/5/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import Foundation


protocol FetchAPI {
    var url: URL? { get }
    var request: URLRequest? { get }
    var task: URLSessionDataTask? { get set }
    var completionHandler: ((Data?, Error?) -> Void)? { get set }
    
    mutating func fetch() -> Bool
    mutating func fetch(completionHandler: @escaping (Data?, Error?) -> Void) -> Bool
    func cancel()
}


extension FetchAPI {
    mutating func fetch() -> Bool {
        guard let handler = self.completionHandler else {
            return false;
        }
        
        return self.fetch(completionHandler: handler)
    }
    
    mutating func fetch(completionHandler: @escaping (Data?, Error?) -> Void) -> Bool {
        guard let fetchRequest = self.request else {
            return false
        }
        
        self.task = URLSession.shared.dataTask(with: fetchRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            print("\(response)")
            print("\(error)")
            
            completionHandler(data, error)
        }
        
        self.task!.resume()
        
        return true
    }
    
    func cancel() {
        task?.cancel()
    }
}


class SearchBookAPI: FetchAPI {
    internal var task: URLSessionDataTask?
    
    private let scheme = "https"
    private let host = "openapi.naver.com"
    private let path = "/v1/search/book.xml"
    private var query: String {
        if keyword.isEmpty {
            return ""
        }
        
        return "display=100&query=" + keyword
    }
    
    var keyword: String
    
    var url: URL? {
        var comps = URLComponents()
        comps.scheme = scheme
        comps.host = host
        comps.path = path
        comps.query = query
        
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
    
    var completionHandler: ((Data?, Error?) -> Void)?
    
    
    init(keyword: String) {
        self.keyword = keyword
    }
}


class SearchFilmAPI: FetchAPI {
    internal var task: URLSessionDataTask?
    
    private let scheme = "https"
    private let host = "openapi.naver.com"
    private let path = "/v1/search/movie.xml"
    private var query: String {
        if keyword.isEmpty {
            return ""
        }
        
        return "display=100&query=" + keyword
    }
    
    var keyword: String
    
    var url: URL? {
        var comps = URLComponents()
        comps.scheme = scheme
        comps.host = host
        comps.path = path
        comps.query = query
        
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

    var completionHandler: ((Data?, Error?) -> Void)?

    
    init(keyword: String) {
        self.keyword = keyword
    }
}
