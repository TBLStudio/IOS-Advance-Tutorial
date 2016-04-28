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


class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertSampleData()
        
        let firstTitle = segmentedControl.titleForSegmentAtIndex(0)
        
        print("First Title: \(firstTitle)")
        
        getBowtieWithSearchKey(firstTitle!)
       
        
    }
    
    @IBAction func segmentedControl(control: UISegmentedControl) {
        
    }
    
    @IBAction func wear(sender: AnyObject) {
        
    }
    
    @IBAction func rate(sender: AnyObject) {
        
    }
    
    func getBowtieWithSearchKey (searchKey: String)
    {
        let request = NSFetchRequest(entityName: "Bowtie")
        request.predicate = NSPredicate(format: "searchKey == %@", searchKey)
        
        do {
            let results = try managedContext.executeFetchRequest(request) as! [Bowtie]
            guard results.count > 0 else {return}
            populate(results[0])
        
        }
        catch {
            print("Error: \(error)")
        }
    
    }
    
    func populate(bowtie: Bowtie) {
        imageView.image = UIImage(data:bowtie.photoData!)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating!.doubleValue)/5"
        timesWornLabel.text =
            "# times worn: \(bowtie.timesWorn!.integerValue)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        lastWornLabel.text = "Last worn: " + dateFormatter.stringFromDate(bowtie.lastWorn!)
        favoriteLabel.hidden = !bowtie.isFavorite!.boolValue
        view.tintColor = bowtie.tintColor as! UIColor
    }
    
    func insertSampleData() {
        
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        fetchRequest.predicate = NSPredicate(format: "searchKey != nil")
        let count = managedContext.countForFetchRequest(fetchRequest, error: nil)
        
        guard count <= 0 else {return}
        let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
        guard let dataArray = NSArray(contentsOfFile: path!) where dataArray.count > 0 else {return}
        
        for dict: AnyObject in dataArray
        {
            guard let entity = NSEntityDescription.entityForName("Bowtie", inManagedObjectContext: managedContext) else {return}
            let bowtie = Bowtie(entity: entity, insertIntoManagedObjectContext: managedContext)
            let btDict = dict as! NSDictionary
            
            bowtie.name = btDict["name"] as? String
            
            bowtie.searchKey = btDict["searchKey"] as? String
            bowtie.rating = btDict["rating"] as? NSNumber
            let tintColorDict = btDict["tintColor"] as? NSDictionary
            bowtie.tintColor = colorFromDict(tintColorDict!)
            
            let imageName = btDict["imageName"] as? String
            let image = UIImage(named:imageName!)
            let photoData = UIImagePNGRepresentation(image!)
            bowtie.photoData = photoData
            
            bowtie.lastWorn = btDict["lastWorn"] as? NSDate
            bowtie.timesWorn = btDict["timesWorn"] as? NSNumber
            bowtie.isFavorite = btDict["isFavorite"] as? NSNumber
        }
    }
    
    func colorFromDict(dict: NSDictionary) -> UIColor {
        let red = dict["red"] as! NSNumber
        let green = dict["green"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0,
                            blue: CGFloat(blue)/255.0,
                            alpha: 1)
        return color
    
    }
    
}













