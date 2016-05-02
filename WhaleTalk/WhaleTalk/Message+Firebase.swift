//
//  Message+Firebase.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/2/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import CoreData
import Firebase

extension Message: FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        if chat?.storageId == nil {
            chat?.upload(rootRef, context: context)
        }
        let data = ["message" : text!, "sender" : FirebaseStore.currentPhoneNumber!]
        guard let chat = chat, timestamp = timestamp, storageId = chat.storageId else {return}
        let timeInterval = String(Int(timestamp.timeIntervalSince1970 * 100000))
        rootRef.childByAppendingPath("chats/"+storageId+"/message/"+timeInterval).setValue(data)
    }
}
