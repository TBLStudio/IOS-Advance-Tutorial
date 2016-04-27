//
//  ViewController.swift
//  AutoLayoutAdvance
//
//  Created by Thái Bô Lão on 4/27/16.
//  Copyright © 2016 Thái Bô Lão. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let blueView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .blueColor()
        return view
    }()
    let redView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .redColor()
        return view
    }()
    let yellowView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .yellowColor()
        return view
    }()
    let greenView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = .greenColor()
        return view
    }()
    
    let blueLabel: UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.backgroundColor = .blueColor()
        label.numberOfLines = 1
        label.lineBreakMode = .ByClipping
        label.textColor = .whiteColor()
        label.text = NSLocalizedString("Lorem ipsum hasbha hasbxha hbaxhas haxba hxbahsx haxba hxbah haxbah ahxbax", comment: "")
        return label
    }()
    let redLabel: UILabel = {
        let label = UILabel.newAutoLayoutView()
        label.backgroundColor = .redColor()
        label.numberOfLines = 0
        label.textColor = .whiteColor()
        label.text = NSLocalizedString("Lorem ipsum haxbax havxah ahxvashx axhax hax xha xahx ahx xh xvxax a xhx xhaxa xahx hxa xha xh xa xaaxj xjahxbax ax jx", comment: "")
        return label
    }()
    
    var didSetupConstraints = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
         
        view.addSubview(blueView)
        view.addSubview(redView)
        view.addSubview(yellowView)
        view.addSubview(greenView)
        
        //For view Demo 4
       // view.addSubview(blueLabel)
       // view.addSubview(redLabel)
        
        view.setNeedsUpdateConstraints() // bootstrap Auto Layout
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints
        {
            //loadViewDemo1()
            //loadViewDemo2()
            loadViewDemo3()
            //loadViewDemo4()
            
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func loadViewDemo1 () {
        
        blueView.autoCenterInSuperview()
        blueView.autoSetDimensionsToSize(CGSizeMake(50, 50))
        
        redView.autoPinEdge(.Top, toEdge: .Bottom, ofView: blueView)
        redView.autoPinEdge(.Left, toEdge: .Right, ofView: blueView)
        redView.autoMatchDimension(.Width, toDimension: .Width, ofView: blueView)
        redView.autoSetDimension(.Height, toSize: 40)
        
        yellowView.autoPinEdge(.Top, toEdge: .Bottom, ofView: redView, withOffset: 10)
        yellowView.autoSetDimension(.Height, toSize: 25)
        yellowView.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        yellowView.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        
        greenView.autoPinEdge(.Top, toEdge: .Bottom, ofView: yellowView, withOffset: 10)
        greenView.autoAlignAxisToSuperviewAxis(.Vertical)
        greenView.autoMatchDimension(.Height, toDimension: .Height, ofView: yellowView, withMultiplier: 2)
        greenView.autoSetDimension(.Width, toSize: 150)
        
    }
    
    func loadViewDemo2 () {
        // Working with array View
        [redView, yellowView].autoSetViewsDimension(.Height, toSize: 50.0)
        [blueView, greenView].autoSetViewsDimension(.Height, toSize: 70.0)
        
        let views = [redView, blueView,yellowView, greenView]
        
        (views as NSArray).autoMatchViewsDimension(.Width)
        
        redView.autoPinToTopLayoutGuideOfViewController(self, withInset: 20)
        
        views.first?.autoPinEdgeToSuperviewEdge(.Left)
        
        var previousView: UIView?
        for view in views {
            if let previousView = previousView {
                view.autoPinEdge(.Left, toEdge: .Right, ofView: previousView)
                view.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView)
            }
            previousView = view
        }
        views.last?.autoPinEdgeToSuperviewEdge(.Right)
        
    }
    
    func loadViewDemo3 () {
        let views: NSArray = [redView, blueView, yellowView, greenView]
        
        views.autoSetViewsDimension(.Height, toSize: 40)
        
        views.autoDistributeViewsAlongAxis(.Horizontal, alignedTo: .Horizontal, withFixedSpacing: 10, insetSpacing: true, matchedSizes: true)
        
        redView.autoAlignAxisToSuperviewAxis(.Horizontal)
        
    }
    
    func loadViewDemo4 () {
        let smallPadding: CGFloat = 20.0
        let largePadding: CGFloat = 50.0
        
        blueLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
        
        blueLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: smallPadding)
        blueLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: smallPadding)
        blueLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: smallPadding)
        
    }
    
    
    
    
}

