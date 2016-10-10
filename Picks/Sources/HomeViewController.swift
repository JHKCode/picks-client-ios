//
//  HomeViewController.swift
//  Picks
//
//  Created by Jinhong Kim on 9/30/16.
//  Copyright © 2016 JHK. All rights reserved.
//

import UIKit

extension UIViewController {
    convenience init?<T: UIViewController>(_: T.Type) where T: NibLoadable {
        self.init(nibName: T.NibName, bundle: nil)
    }

    
    static func make<T: UIViewController>(storyboardName: String = "Main") -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}


class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    let searchManager = SearchManager()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTableView()
        setupNotification()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupTableView() {
        tableView.register(SearchBookViewCell)
    }
    
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BookSearchDidFinish"), object: nil, queue: nil) { (noti: Notification) in
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: UISearchBarDelegate
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Keyword: \(searchBar.text)")
        
        if let keyword = searchBar.text {
            searchManager.search(keyword: keyword)
        }
    }
    
    
    // MARK: UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.books.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchBookViewCell
        
        let book = searchManager.books.items[indexPath.row]
        cell.title.text = book.title
        cell.thumbnailView.load(imageURL: URL(string: book.imageURI)!)
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addPickVC = UIViewController.make() as AddPickViewController
        let pickItem = searchManager.books.items[indexPath.row]
        
        addPickVC.item = pickItem
        
        self.navigationController?.pushViewController(addPickVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
