//
//  SearchBookViewCell.swift
//  Picks
//
//  Created by Jinhong Kim on 10/6/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import UIKit


protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


protocol NibLoadable: class { }

extension NibLoadable where Self: UIView  {
    static var NibName: String {
        return String(describing: self)
    }
}


extension NibLoadable where Self: UIViewController {
    static var NibName: String {
        return String(describing: self)
    }
}


extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadable {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}


class SearchBookViewCell: UITableViewCell, ReusableView, NibLoadable {
    @IBOutlet weak var thumbnailView: PickImageView!
    @IBOutlet weak var title: UILabel!
    
}
