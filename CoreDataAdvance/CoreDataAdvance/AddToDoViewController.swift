//
//  AddToDoViewController.swift
//  CoreDataAdvance
//
//  Created by Ngo Thai on 4/26/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController {
    
    
    @IBOutlet var textField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        print("cancel")
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func save(sender: AnyObject) {
        print("save")
        guard let name = textField.text where name.characters.count > 0
            else {
                showAlertWithTitle("Warning", message: "Your to-do needs a name.", cancelButtonTitle: "OK")
                return
        }
        guard let managedObjectContext = managedObjectContext else {return}
        guard let entity = NSEntityDescription.entityForName("Item", inManagedObjectContext: managedObjectContext) else {return}
        let record = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        
        record.setValue(name, forKey: "name")
        record.setValue(NSDate(), forKey: "createdAt")
        
        do {
            try self.managedObjectContext.save()
            navigationController?.popViewControllerAnimated(true)
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            // Show Alert View
            showAlertWithTitle("Warning", message: "Your to-do could not be saved.", cancelButtonTitle: "OK")
        }
        
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func showAlertWithTitle(title: String, message: String, cancelButtonTitle: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .Default, handler: nil))
        
        // Present Alert Controller
        presentViewController(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddToDoViewController: UITextFieldDelegate
{

}

















