//
//  PickImageView.swift
//  Picks
//
//  Created by Jinhong Kim on 10/6/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import UIKit
import CoreGraphics


extension UIImage {
    convenience init?(contentsOf fileURL: URL) {
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        self.init(data: imageData)
    }
}


class PickImageView: UIImageView {
    var url: URL?
    var task: URLSessionDownloadTask?
    
    init(imageURL: URL) {
        url = imageURL
        
        super.init(frame: CGRect.zero)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func load() {
        if url != nil {
            load(imageURL: url!)
        }
    }
    
    
    func load(imageURL: URL) {
        url = imageURL
        task = URLSession.shared.downloadTask(with: imageURL, completionHandler: { (fileURL: URL?, response:URLResponse?, error: Error?) in
            if self.url == nil || fileURL == nil {
                return
            }
            
            if self.url != response?.url {
                return
            }
            
            guard let image = UIImage(contentsOf: fileURL!) else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        })
        
        task?.resume()
    }
    
    
    func canel() {
        task?.cancel()
        url = nil
    }
}


