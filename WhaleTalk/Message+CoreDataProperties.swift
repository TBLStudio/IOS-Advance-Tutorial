//
//  Message+CoreDataProperties.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 4/30/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var text: String?
    @NSManaged var timestamp: NSDate?
    @NSManaged var chat: Chat?
    @NSManaged var sender: Contact?

}
