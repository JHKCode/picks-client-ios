//
//  AddPickViewController.swift
//  Picks
//
//  Created by Jinhong Kim on 10/7/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import UIKit


class AddPickViewController: UIViewController {
    var item: PickItem?


    @IBOutlet weak var pickTitle: UILabel!
    @IBOutlet weak var pickImageView: PickImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let pickItem = item {
            pickTitle.text = pickItem.title
            
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
