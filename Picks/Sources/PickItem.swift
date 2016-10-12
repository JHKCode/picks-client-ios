//
//  PickItem.swift
//  Picks
//
//  Created by Jinhong Kim on 9/30/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import Foundation


enum PickItemType {
    case Book
    case Film
    case Song
    case Album
}


protocol PickItem {
    // internal
    var id: String { get set }
    var type: PickItemType { get set }
    
    // external
    var title: String { get set }
    var imageURI: String { get set }
    var creator: String { get set }
    var date: Date { get set }
    var desc: String { get set }
}


struct Book: PickItem {
    // pick item
    var id: String
    var type: PickItemType
    var title: String
    var imageURI: String
    var creator: String
    var date: Date
    var desc: String
    
    // book specific item
    var isbn: String
    var publisher: String
    
    // description
    func description() {
        print("id: \(id)")
        print("type: \(type)")
        print("title: \(title)")
    }
}


struct Film: PickItem {
    // pick item
    var id: String
    var type: PickItemType
    var title: String
    var imageURI: String
    var creator: String
    var date: Date
    var desc: String
    
    // film specific item
    var cast: String
}
