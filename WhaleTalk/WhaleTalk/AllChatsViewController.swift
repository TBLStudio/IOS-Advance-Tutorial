//
//  AllChatsViewController.swift
//  WhaleTalk
//
//  Created by Thái Bô Lão on 4/25/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController?
    private let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
    private let cellIdentifier = "MessageCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_chat"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AllChatsViewController.newChat))
        
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func newChat ()
    {
        
    }
    
    

}
