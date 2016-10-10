//
//  PickItem.swift
//  Picks
//
//  Created by Jinhong Kim on 9/30/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import Foundation

protocol PickItem {
    var title: String { get set }
    var imageURI: String { get set }
}


struct Book: PickItem {
    var title: String
    var imageURI: String
}
