//
//  ContactsSearchResultsController.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/2/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData

class ContactsSearchResultsController: UITableViewController {
    
    private var filteredContacts = [Contact]()
    
    var contactSelector: ContactSelector?
    
    var contacts = [Contact]() {
        didSet {
            filteredContacts = contacts
        }
    }
    
    private let cellIdentifier = "ContactSearchCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
 */

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let contact = filteredContacts[indexPath.row]
        cell.textLabel?.text = contact.fullName
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contact = filteredContacts[indexPath.row]
        contactSelector?.selectedContact(contact)
    }

    
}


extension ContactsSearchResultsController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        if searchText.characters.count > 0 {
            filteredContacts = contacts.filter {
                $0.fullName.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }
        }
        else {
            filteredContacts = contacts
        }
        tableView.reloadData()
    }
}


























