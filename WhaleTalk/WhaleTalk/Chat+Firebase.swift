//
//  Chat+Firebase.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/2/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import Firebase
import CoreData

extension Chat: FirebaseModel {
    
    func observeMessages(rooRef: Firebase, context: NSManagedObjectContext) {
        guard let storageId = storageId else {return}
        let lastFetch = lastMessage?.timestamp?.timeIntervalSince1970 ?? 0
        
        rooRef.childByAppendingPath("chats/"+storageId+"/messages").queryOrderedByKey().queryStartingAtValue(String(lastFetch * 100000)).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            context.performBlock({ 
                guard let phoneNumber = snapshot.value["sender"] as? String where phoneNumber != FirebaseStore.currentPhoneNumber else {return}
                guard let text = snapshot.value["message"] as? String else {return}
                guard let timeInterval = Double(snapshot.key) else {return}
                let date = NSDate(timeIntervalSince1970: timeInterval/100000)
                guard let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as? Message else {return}
                message.text = text
                message.timestamp = date
                message.sender = Contact.existing(withPhoneNumber: phoneNumber, rootRef: rooRef, inContext: context) ?? Contact.new(forPhoneNumber: phoneNumber, rootRef: rooRef, inContext: context)
                message.chat = self
                do {
                    try context.save()
                }
                catch {
                    print("Error saving message")
                }
                
            })
        })
    }
    
    static func existing(storageId storageId: String, inContext context: NSManagedObjectContext) -> Chat? {
        let request = NSFetchRequest(entityName: "Chat")
        request.predicate = NSPredicate(format: "storageId = %@", storageId)
        do {
            if let results = try context.executeFetchRequest(request) as? [Chat]
                where results.count > 0 {
                if let chat = results.first {
                    return chat
                }
            }
        }
        catch {
            print("Error featching Chat")
        }
        return nil
    }
    
    
    static func new(forStorageId storageId: String, rootRef: Firebase, inContext context: NSManagedObjectContext) -> Chat {
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: context) as! Chat
        chat.storageId = storageId
        
        rootRef.childByAppendingPath("chats/"+storageId+"/meta").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            guard let data = snapshot.value as? NSDictionary else {return}
            guard let participantsDict = data["participants"] as? NSMutableDictionary else {return}
            participantsDict.removeObjectForKey(FirebaseStore.currentPhoneNumber!)
            let participants = participantsDict.allKeys.map{
                (phoneNumber: AnyObject) -> Contact in
                let phoneNumber = phoneNumber as! String
                return Contact.existing(withPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context) ?? Contact.new(forPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context)
            }
            let name = data ["name"] as? String
            context.performBlock({
                chat.participants = NSSet(array: participants)
                chat.name = name
                do {
                    try context.save()
                }
                catch {
                    print("Save error")
                }
                chat.observeMessages(rootRef, context: context)
            })
        }) { (error) in
            print("error: \(error)")
        }
        return chat
    }
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard storageId == nil else {return}
        let ref = rootRef.childByAppendingPath("chats").childByAutoId()
        storageId = ref.key
        var data: [String: AnyObject] = ["id": ref.key]
        guard let participants = participants?.allObjects as? [Contact] else {return}
        var numbers = [FirebaseStore.currentPhoneNumber!: true]
        var userIds = [rootRef.authData.uid]
        for participant in participants {
            guard let phoneNumbers = participant.phoneNumbers?.allObjects as? [PhoneNumber] else {continue}
            guard let number = phoneNumbers.filter({$0.registered}).first else {continue}
            numbers[number.value!] = true
            userIds.append(participant.storageId!)
        }
        data["participants"] = numbers
        if let name = name {
            data[name] = name
        }
        ref.setValue(["meta" : data])
        for id in userIds {
            rootRef.childByAppendingPath("users/"+id+"/chats/"+ref.key).setValue(true)
        }
        
    }
}


