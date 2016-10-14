//
//  SavePickViewController.swift
//  Picks
//
//  Created by Jinhong Kim on 10/12/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import UIKit


class SavePickViewController: UIViewController {
    
    @IBOutlet weak var pickImageView: PickImageView!
    @IBOutlet weak var pickTitleLabel: UILabel!
    @IBOutlet weak var pickCreatorLabel: UILabel!
    @IBOutlet weak var pickDateLabel: UILabel!
    
    var item: PickItem?
    
    
    deinit {
        print("deinit at SavePickViewController")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let pickItem = item {
            pickTitleLabel.text = pickItem.title
            pickCreatorLabel.text = pickItem.creator

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "ko_KR")

            pickDateLabel.text = dateFormatter.string(from: pickItem.date)
            
            if let url = URL(string: pickItem.imageURI) {
                pickImageView.load(imageURL: url)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
