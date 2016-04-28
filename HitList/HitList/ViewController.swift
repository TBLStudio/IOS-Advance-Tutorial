//
//  ViewController.swift
//  HitList
//
//  Created by Thái Bô Lão on 4/28/16.
//  Copyright © 2016 Thái Bô Lão. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var persons = [NSManagedObject]()
    
    let cellReuseIdentify = "Cell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            persons = results as! [NSManagedObject]
            
        } catch {
        
        }
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentify)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addName(sender: AnyObject) {
        showAlertWithTextField("New Name", message: "Add a new name")
    }
    
    func showAlertWithTextField (title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        let textField = alert.textFields!.first
                                        guard let name = textField?.text where name.characters.count > 0 else {return}
                                        self.saveName(name)
                                        self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
        }
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    
    }
    
    func saveName (name: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        person.setValue(name, forKey: "name")
        
        do {
            
            try managedObjectContext.save()
            
            persons.append(person)
        
        }
        catch {
            
            print("Could not save: \(error)")
        
        }
        
    }
    
    
    
    

}

extension ViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentify, forIndexPath: indexPath)
        
        cell.textLabel?.text = persons[indexPath.row].valueForKey("name") as? String

        return cell
    }

}

extension ViewController: UITableViewDelegate
{
    
}
