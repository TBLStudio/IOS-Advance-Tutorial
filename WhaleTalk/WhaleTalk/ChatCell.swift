//
//  ChatCell.swift
//  WhaleTalk
//
//  Created by Thái Bô Lão on 4/22/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    let messageLabel: UILabel = UILabel()
    
    private let bubbleImageView = UIImageView()
    
    private var outgoingContraint: NSLayoutConstraint!
    private var incomingContraint: NSLayoutConstraint!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraintEqualToAnchor(bubbleImageView.centerXAnchor).active = true
        messageLabel.centerYAnchor.constraintEqualToAnchor(bubbleImageView.centerYAnchor).active = true
        
        bubbleImageView.widthAnchor.constraintEqualToAnchor(messageLabel.widthAnchor, constant: 50).active = true
        bubbleImageView.heightAnchor.constraintEqualToAnchor(messageLabel.heightAnchor).active = true
        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        
        
        outgoingContraint = bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor)
        incomingContraint = bubbleImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor)
        
        
        
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func incoming (incoming: Bool) {
        if (incoming)
        {
            incomingContraint.active = true
            outgoingContraint.active = false
            bubbleImageView.image = bubble.imcoming
            
        } else {
            incomingContraint.active = false
            outgoingContraint.active = true
            bubbleImageView.image = bubble.outgoing
        }
    }
}

let bubble = makeBubble()


func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage!
{
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, CGBlendMode.SourceAtop)
    CGContextFillRect(context, rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return result
}

func makeBubble() -> (imcoming: UIImage, outgoing: UIImage)
{
    let image = UIImage(named: "MessageBubble")!
    let outgoing = coloredImage(image, red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    let flippedImage = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.UpMirrored)
    
    let incoming = coloredImage(flippedImage, red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
    
    return (incoming, outgoing)
}









