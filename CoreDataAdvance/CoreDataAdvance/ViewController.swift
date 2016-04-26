//
//  ViewController.swift
//  CoreDataAdvance
//
//  Created by Ngo Thai on 4/26/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    var fetchedResultsController: NSFetchedResultsController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init FetchedResultsController
        if let managedObjectContext = managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: "Item")
            let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
            
            do {
                try self.fetchedResultsController?.performFetch()
            }
            catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.userInfo)")
            
            }
            
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueAddToDoViewController"
        {
            if let addTodoViewController = segue.destinationViewController as? AddToDoViewController
            {
                print("Went Here")
                addTodoViewController.managedObjectContext = self.managedObjectContext
            }
        }
    }

}


//MARK: - TableView Datasource
extension ViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else {return 0}
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {return 0}
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ToDoCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell (cell: ToDoCell, atIndexPath indexPath: NSIndexPath)
    {
        //Fetch record
        let record = fetchedResultsController?.objectAtIndexPath(indexPath)
        
        //Update Cell
        if let name = record?.valueForKey("name") as? String
        {
            cell.nameLabel.text = name
        }
        
        if let done = record?.valueForKey("done") as? Bool
        {
            cell.doneButton.selected = done
        }
        
    }

}

//MARK:- TableView Delegate
extension ViewController: UITableViewDelegate
{
    

}


//MARK:- NSFetchedResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let indexPath = newIndexPath
            {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
            
        case .Delete:
            if let indexPath = indexPath
            {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Update:
            if let indexPath = indexPath
            {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! ToDoCell
                //Configure Cell
                configureCell(cell, atIndexPath: indexPath)
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break
        }
        
    }

}





















