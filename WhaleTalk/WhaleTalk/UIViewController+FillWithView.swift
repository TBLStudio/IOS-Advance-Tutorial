//
//  UIViewController+FillWithView.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 4/30/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func fillViewWith (subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        let viewConstraints: [NSLayoutConstraint] = [
            subView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            subView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            subView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            subView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}