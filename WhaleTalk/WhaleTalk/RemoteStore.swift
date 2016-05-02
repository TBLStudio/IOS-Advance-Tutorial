//
//  RemoteStore.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/2/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import CoreData

protocol RemoteStore {
    func signUp (phoneNumber phoneNumber: String, email: String, password: String, success: ()->(), error: (errorMessage: String) ->())
    func startSyncing()
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject])
    
}