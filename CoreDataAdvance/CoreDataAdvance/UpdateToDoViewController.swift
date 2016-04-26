//
//  UpdateToDoViewController.swift
//  CoreDataAdvance
//
//  Created by Ngo Thai on 4/27/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData

class UpdateToDoViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    
    var record: NSManagedObject!
    
    var managedObjectContext: NSManagedObjectContext!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let name = record.valueForKey("name") as? String else {return}
        textField.text = name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet var save: UIBarButtonItem!
    
    @IBAction func savePressed(sender: AnyObject) {
        guard let name = textField.text  where name.characters.count > 0
        else
        {
            showAlertWithTitle("Warning", message: "Your to-do needs a name.", cancelButtonTitle: "OK")
            return
        }
        
        record.setValue(name, forKey: "name")
        do {
            try self.managedObjectContext.save()
        
        }
        catch {
        
        }
        
        navigationController?.popViewControllerAnimated(true)
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

    

}
