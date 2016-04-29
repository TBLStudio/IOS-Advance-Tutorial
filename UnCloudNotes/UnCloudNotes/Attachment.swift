//
//  Attachment.swift
//  UnCloudNotes
//
//  Created by Thái Bô Lão on 4/29/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Attachment: NSManagedObject {
    @NSManaged var dateCreated: NSDate
    @NSManaged var image: UIImage?
    @NSManaged var note: Note

}
