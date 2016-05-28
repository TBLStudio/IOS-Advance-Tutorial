//
//  FirebaseStore.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/2/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseStore {
    
    private let context: NSManagedObjectContext
    private let rootRef = Firebase(url: "https://tblwhaletalk.firebaseio.com")
    
    private(set) static var currentPhoneNumber : String? {
        set(phoneNumber) {
            NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: "phoneNumber")
        }
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") as? String
        }
    }
    
    init (context: NSManagedObjectContext) {
        self.context = context
    }
    func hasAuth() -> Bool {
        return rootRef.authData != nil
    }
    
    private func upload(model: NSManagedObject) {
        guard let model = model as? FirebaseModel else {return}
        
        model.upload(rootRef, context: context)
    }
    
    private func listenForNewMessages(chat: Chat) {
        chat.observeMessages(rootRef, context: context)
    }
    
    private func fetchAppContacts()-> [Contact]{
        do {
            let request = NSFetchRequest(entityName: "Contact")
            request.predicate = NSPredicate(format: "storageId != nil")
            if let results = try context.executeFetchRequest(request) as? [Contact] {
                return results
            }
        }
        catch {
            print("Error fetch contact")
        }
        return []
    }
    
    private func observeUserStatus (contact: Contact) {
        contact.observeStatus(rootRef, context: context)
    }
    
    private func observeStatuses () {
        let contacts = fetchAppContacts()
        contacts.forEach(observeUserStatus)
    }
    
    private func observeChats() {
        self.rootRef.childByAppendingPath("users/"+self.rootRef.authData.uid+"/chats").observeEventType(.ChildAdded , andPreviousSiblingKeyWithBlock: { (snapshot, string) in
            let uid = snapshot.key
            let chat = Chat.existing(storageId: uid, inContext: self.context) ?? Chat.new(forStorageId: uid, rootRef: self.rootRef, inContext: self.context)
            if chat.inserted {
                do {
                    try self.context.save()
                }
                catch {
                    print("Save error")
                }
            }
            
            self.listenForNewMessages(chat)
            
            }) { (error) in
                print("error: \(error)")
        }
    }
}

extension FirebaseStore: RemoteStore {
    func startSyncing() {
        context.performBlock { 
            self.observeStatuses()
            self.observeChats()
        }
        
    }
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        inserted.forEach(upload)
        do {
            try context.save()
        }
        catch {
            print("Error Saving")
        }
    }
    func signUp(phoneNumber phoneNumber: String, email: String, password: String, success: () -> (), error errorCallback: (errorMessage: String) -> ()) {
        rootRef.createUser(email, password: password) { (error, result) in
            if error != nil {
                errorCallback(errorMessage: error.description)
            } else {
                let newUser = ["phoneNumber": phoneNumber]
                FirebaseStore.currentPhoneNumber = phoneNumber
                let uid = result["uid"] as! String
                self.rootRef.childByAppendingPath("users").childByAppendingPath(uid).setValue(newUser)
                self.rootRef.authUser(email, password: password, withCompletionBlock: { (error, authData) in
                    if error != nil {
                        errorCallback(errorMessage: error.description)
                    } else {
                        success()
                    }
                })
            }
        }
        
    }
    
}










