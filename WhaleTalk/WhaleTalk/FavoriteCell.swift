//
//  FavoriteCell.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/2/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    let phoneTypeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.textColor = UIColor.lightGrayColor()
        phoneTypeLabel.textColor = UIColor.lightGrayColor()
        phoneTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(phoneTypeLabel)
        
        phoneTypeLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
        phoneTypeLabel.trailingAnchor.constraintEqualToAnchor(contentView.layoutMarginsGuide.trailingAnchor).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

