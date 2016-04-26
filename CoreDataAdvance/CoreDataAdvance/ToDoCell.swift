//
//  ToDoCell.swift
//  CoreDataAdvance
//
//  Created by Ngo Thai on 4/26/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var doneButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
