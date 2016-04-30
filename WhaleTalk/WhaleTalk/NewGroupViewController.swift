//
//  NewGroupViewController.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/1/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData


class NewGroupViewController: UIViewController {
    
    var context: NSManagedObjectContext?
    var chatCreationDelegate: ChatCreationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Group"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
