//
//  NewChatViewController.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 4/30/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData

class NewChatViewController: UIViewController, TableViewFetchedResultsDisplayer {
    
    var context: NSManagedObjectContext?
    
    private var fetchedResultsViewController: NSFetchedResultsController?
    
    private var fetchedResultsDelegate: TableViewFetchedResultsDelegate?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "ContactCell"
    
    var chatCreationDelegate: ChatCreationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Chat"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(NewChatViewController.cancel))
        automaticallyAdjustsScrollViewInsets = false
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        fillViewWith(tableView)
        
        if let context = context {
            
            let request = NSFetchRequest(entityName: "Contact")
            request.predicate = NSPredicate(format: "storageId != nil")
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
            
            fetchedResultsViewController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: "NewChatViewController")
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            fetchedResultsViewController?.delegate = fetchedResultsDelegate
            do {
                try fetchedResultsViewController?.performFetch()
            }
            catch {
                print("Loading contact error")
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cancel () {
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func configureCell (cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
    {
        guard let contact = fetchedResultsViewController?.objectAtIndexPath(indexPath) as? Contact else {return}
        cell.textLabel?.text = contact.fullName
    }

}


extension NewChatViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsViewController?.sections?.count ?? 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsViewController?.sections else {return 0}
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsViewController?.sections else {return nil}
        let currentSection = sections[section]
        return currentSection.name
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

extension NewChatViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsViewController?.objectAtIndexPath(indexPath) as? Contact else {return}
        guard let context = context else {return}
        let chat = Chat.existing(directWith: contact, inContext: context) ?? Chat.new(directWith: contact, inContext: context)
        
        chatCreationDelegate?.created(chat: chat, inContext: context)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}








