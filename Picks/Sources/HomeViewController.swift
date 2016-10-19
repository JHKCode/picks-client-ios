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
    @IBOutlet weak var pickSearchBar: UISearchBar!
    
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
        tableView.register(SearchBookViewCell.self)
    }
    
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(forName: SearchManager.SearchDidFinishNotificationName, object: nil, queue: nil) { (noti: Notification) in
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: UISearchBarDelegate
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Keyword: \(searchBar.text)")
        
        searchBar.resignFirstResponder()
        
        guard let keyword = searchBar.text, keyword.isEmpty == false else {
            return
        }

        if let category = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] {
            searchManager.search(keyword: keyword, category: category)
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.searchBarSearchButtonClicked(searchBar)
    }
    

    // MARK: UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchBookViewCell
        
        let item = searchManager.items[indexPath.row]
        cell.title.text = item.title
        
        if let url = URL(string: item.imageURI) {
            cell.thumbnailView.load(imageURL: url)
        }
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savePickVC = UIViewController.make() as SavePickViewController
        let pickItem = searchManager.items[indexPath.row]
        
        savePickVC.item = pickItem
        
        self.navigationController?.pushViewController(savePickVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        pickSearchBar.resignFirstResponder()
    }
}
