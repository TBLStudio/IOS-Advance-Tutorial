//
//  Message.swift
//  WhaleTalk
//
//  Created by Thái Bô Lão on 4/25/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import CoreData


class Message: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var isIncoming: Bool {
        return sender != nil
    }

}
