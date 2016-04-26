//
//  AppDelegate.swift
//  CoreDataTut
//
//  Created by Ngo Thai on 4/25/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//http://code.tutsplus.com/tutorials/core-data-and-swift-managed-objects-and-fetch-requests--cms-25068

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //addPersonWith("Thai", last: "Ngo", age: 25)
        
        printPerson(fetchPerson())
        
        updatePerson("Thai2", first: "Ngo2", age: 26)
        
        printPerson(fetchPerson())
        
        return true
    }
    
    func printPerson(person: NSManagedObject)
    {
        let first: String = person.valueForKey("first") as! String
        let last: String = person.valueForKey("last") as! String
        let age: Int = person.valueForKey("age") as! Int
        
        print("---" + first + "---" + last + "---" )
    
    }
    
    func addPersonWith(first: String, last: String, age: Int) -> Bool
    {
        let addPersonEntity = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.managedObjectContext)
        let newPerson = NSManagedObject(entity: addPersonEntity!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        //Config new person
        newPerson.setValue(first, forKey: "first")
        newPerson.setValue(last, forKey: "last")
        newPerson.setValue(age, forKey: "age")
        
        //Saving the record
        do {
            try newPerson.managedObjectContext?.save()
            return true
        } catch {
            print("error")
            return false
        }
        
    }
    
    func fetchPerson() -> NSManagedObject!
    {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            if result.count > 0
            {
                return result[0] as! NSManagedObject
            }
            return nil
        
        } catch {
            return nil
        }
    }
    
    func updatePerson (last: String, first: String, age: Int)
    {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            if result.count > 0
            {
                let person = result[0] as! NSManagedObject
                
                //Update
                person.setValue(last, forKey: "last")
                person.setValue(first, forKey: "first")
                person.setValue(age, forKey: "age")
                
                do {
                    try person.managedObjectContext?.save()
                
                } catch {
                
                }
            }
        }
        catch {
        
        }
    
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "TBLStudio.CoreDataTut" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CoreDataTut", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}



