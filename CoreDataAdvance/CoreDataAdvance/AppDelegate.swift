//
//  AppDelegate.swift
//  CoreDataAdvance
//
//  Created by Ngo Thai on 4/26/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("StoryboardIDRootNavigationController") as! UINavigationController
        
        let viewController = rootNavigationController.topViewController as? ViewController
        
        if let viewController = viewController {
            viewController.managedObjectContext = self.managedObjectContext
        }
        
        window?.rootViewController = rootNavigationController
        // Override point for customization after application launch.
        return true
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
    }
    
    //MARK:-
    //MARK: - Core data stack
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = NSBundle.mainBundle().URLForResource("CoreDataAdvance", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // URL Persistent Store
        let URLPersistentStore = self.applicationStoresDirectory().URLByAppendingPathComponent("CoreDataAdvance.sqlite")
        
        do {
            // Declare Options
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            
            // Add Persistent Store to Persistent Store Coordinator
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: URLPersistentStore, options: options)
            
        } catch {
            let fm = NSFileManager.defaultManager()
            
            if fm.fileExistsAtPath(URLPersistentStore.path!) {
                let nameIncompatibleStore = self.nameForIncompatibleStore()
                let URLCorruptPersistentStore = self.applicationIncompatibleStoresDirectory().URLByAppendingPathComponent(nameIncompatibleStore)
                
                do {
                    // Move Incompatible Store
                    try fm.moveItemAtURL(URLPersistentStore, toURL: URLCorruptPersistentStore)
                    
                } catch {
                    let moveError = error as NSError
                    print("\(moveError), \(moveError.userInfo)")
                }
            }
        }
        
        return persistentStoreCoordinator
    }()
    
    private func applicationStoresDirectory() -> NSURL {
        let fm = NSFileManager.defaultManager()
        
        // Fetch Application Support Directory
        let URLs = fm.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        let applicationSupportDirectory = URLs[(URLs.count - 1)]
        
        // Create Application Stores Directory
        let URL = applicationSupportDirectory.URLByAppendingPathComponent("Stores")
        
        if !fm.fileExistsAtPath(URL.path!) {
            do {
                // Create Directory for Stores
                try fm.createDirectoryAtURL(URL, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                let createError = error as NSError
                print("\(createError), \(createError.userInfo)")
            }
        }
        
        return URL
    }
    
    private func applicationIncompatibleStoresDirectory() -> NSURL {
        let fm = NSFileManager.defaultManager()
        
        // Create Application Incompatible Stores Directory
        let URL = applicationStoresDirectory().URLByAppendingPathComponent("Incompatible")
        
        if !fm.fileExistsAtPath(URL.path!) {
            do {
                // Create Directory for Stores
                try fm.createDirectoryAtURL(URL, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                let createError = error as NSError
                print("\(createError), \(createError.userInfo)")
            }
        }
        
        return URL
    }
    
    private func nameForIncompatibleStore() -> String {
        // Initialize Date Formatter
        let dateFormatter = NSDateFormatter()
        
        // Configure Date Formatter
        dateFormatter.formatterBehavior = .Behavior10_4
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        return "\(dateFormatter.stringFromDate(NSDate())).sqlite"
    }


}




















