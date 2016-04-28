/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData


let filterViewControllerSegueIdentifier = "toFilterViewController"
let venueCellIdentifier = "VenueCell"

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var coreDataStack: CoreDataStack!
    
    var fetchRequest: NSFetchRequest!
    
    var asyncFetchRequest: NSAsynchronousFetchRequest!
    
    var venues: [Venue]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let model = coreDataStack.context.persistentStoreCoordinator?.managedObjectModel
//        fetchRequest = model!.fetchRequestTemplateForName("FetchRequest")
        fetchRequest = NSFetchRequest(entityName: "Venue")
        
        asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest)
        { [unowned self] (result: NSAsynchronousFetchResult! ) -> Void in
            self.venues = result.finalResult as! [Venue]
            self.tableView.reloadData()
        }
        do {
            try coreDataStack.context.executeRequest(asyncFetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        //fetchAndReload()
        
        let batchUpdate = NSBatchUpdateRequest(entityName: "Venue")
        batchUpdate.propertiesToUpdate = ["favorite" : NSNumber(bool: true)]
        batchUpdate.affectedStores = coreDataStack.context .persistentStoreCoordinator!.persistentStores
        batchUpdate.resultType = .UpdatedObjectsCountResultType
        do {
            let batchResult = try coreDataStack.context .executeRequest(batchUpdate) as! NSBatchUpdateResult
            print("Records updated \(batchResult.result!)")
        }
        catch let error as NSError {
                print("Could not update \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchAndReload() {
        do {
            venues = try coreDataStack.context .executeFetchRequest(fetchRequest) as! [Venue]
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == filterViewControllerSegueIdentifier {
            let navController =
                segue.destinationViewController as! UINavigationController
            let filterVC =
                navController.topViewController as! FilterViewController
            filterVC.coreDataStack = coreDataStack
            filterVC.delegate = self
        }
    }
    
    @IBAction func unwindToVenuListViewController(segue: UIStoryboardSegue) {
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(venueCellIdentifier)!
        cell.textLabel!.text = venues[indexPath.row].name
        cell.detailTextLabel!.text = venues[indexPath.row].priceInfo?.priceCategory
        
        return cell
    }
}

extension ViewController: FilterViewControllerDelegate
{
    func filterViewController(filter: FilterViewController, didSelectPredicate predicate: NSPredicate?, sortDescription: NSSortDescriptor?) {
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        if predicate != nil {
            fetchRequest.predicate = predicate!
        }
        if sortDescription != nil
        {
            fetchRequest.sortDescriptors = [sortDescription!]
        }
        
        fetchAndReload()
        
        
    }

}
