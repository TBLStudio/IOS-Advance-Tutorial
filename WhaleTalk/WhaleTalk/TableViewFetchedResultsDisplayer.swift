//
//  TableViewFetchedResultsDisplayer.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/1/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewFetchedResultsDisplayer {
    func configureCell (cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
}