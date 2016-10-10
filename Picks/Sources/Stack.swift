//
//  Stack.swift
//  XMLDoc
//
//  Created by Jinhong Kim on 9/21/16.
//  Copyright © 2016 Naver. All rights reserved.
//

import Foundation


struct Stack<Element> {
    var stack = Array<Element>()
    
    
    func count() -> Int {
        return stack.count
    }
    
    
    mutating func push(element: Element) {
        stack.append(element)
    }
    
    
    mutating func pop() -> Element? {
        if stack.count == 0 {
            return nil
        }
        
        return stack.removeLast()
    }
    
    
    func top() -> Element? {
        return stack.last
    }
    
    
    mutating func replaceTop(element: Element) {
        stack.removeLast()
        stack.append(element)
    }
    
    
    mutating func clear() {
        stack.removeAll()
    }
}
