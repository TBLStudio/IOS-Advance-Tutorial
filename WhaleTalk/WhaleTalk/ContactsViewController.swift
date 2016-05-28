//
//  ContactsViewController.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/1/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData
import ContactsUI
import Contacts

class ContactsViewController: UIViewController, ContextViewController, TableViewFetchedResultsDisplayer, ContactSelector {
    
    var context: NSManagedObjectContext?
    
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    private let cellIdentifier = "ContactCell"
    
    private var fetchedResultsController: NSFetchedResultsController?
    
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    
    private var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "All Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .Plain, target: self, action: #selector(ContactsViewController.newContact))
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.dataSource = self
        tableView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        fillViewWith(tableView)
        
        if let context = context {
            let request = NSFetchRequest(entityName: "Contact")
            request.sortDescriptors = [
                NSSortDescriptor(key: "lastName", ascending: true),
                NSSortDescriptor(key: "firstName", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: nil)
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            
            do {
                try fetchedResultsController?.performFetch()
            }
            catch {
                print("Error")
            }
            
        }
        
        let resultsVC = ContactsSearchResultsController()
        resultsVC.contacts = fetchedResultsController?.fetchedObjects as! [Contact]
        resultsVC.contactSelector = self
        searchController = UISearchController(searchResultsController: resultsVC)
        searchController?.searchResultsUpdater = resultsVC
        definesPresentationContext = true
        tableView.tableHeaderView = searchController?.searchBar
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func newContact () {
        let vc = CNContactViewController(forNewContact: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectedContact(contact: Contact) {
        guard let id = contact.contactId else {return}
        let store = CNContactStore()
        let cnContact: CNContact
        do {
            cnContact = try store.unifiedContactWithIdentifier(id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        
        }
        catch {
            return
        }
        let vc = CNContactViewController(forContact: cnContact)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        searchController?.active = false
    }
    
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        cell.textLabel?.text = contact.fullName
        
    }
    
    
}

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {return 0}
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else {return nil}
        let currentSection = sections[section]
        return currentSection.name
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        selectedContact(contact)
        tableView.deselectRowAtIndexPath(indexPath, animated: true
        )
    }
}


extension ContactsViewController: CNContactViewControllerDelegate {

    func contactViewController(viewController: CNContactViewController, didCompleteWithContact contact: CNContact?) {
        if contact == nil {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
}









