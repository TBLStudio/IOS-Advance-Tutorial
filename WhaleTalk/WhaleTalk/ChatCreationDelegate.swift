//
//  ChatCreationDelegate.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 4/30/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import CoreData

protocol ChatCreationDelegate {
    func created(chat chat: Chat, inContext context: NSManagedObjectContext)
}

