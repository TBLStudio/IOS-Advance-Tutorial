//
//  ViewController.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 4/21/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var messages = [Message]()
    
    private let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fake data
        
        var localIncoming = true;
        for i in 0...10
        {
            let m = Message()
            m.text = "Cell " + String(i)
            m.incoming = localIncoming
            localIncoming = !localIncoming
            messages.append(m)
        
        }
        
        //Setup data
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        
        //Setup Layout TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        //Contraint for Tableview
        let tableViewContrains: [NSLayoutConstraint] = [
                tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
                tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
                tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
                tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(tableViewContrains)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




extension ChatViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        
        cell.messageLabel.text = message.text
        
        cell.incoming(message.incoming)
        
        return cell
        
        
    }


}
























