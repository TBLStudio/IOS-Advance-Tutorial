//
//  ContextViewController.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/1/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import CoreData

protocol ContextViewController {
    var context: NSManagedObjectContext? {get set}
    
}