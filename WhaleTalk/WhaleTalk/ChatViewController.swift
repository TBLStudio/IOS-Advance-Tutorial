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
    
    private let newMessageField = UITextField()
    
    private var messages = [Message]()
    
    private let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fake data
        
        var localIncoming = true;
        for i in 0...10
        {
            let m = Message()
            //m.text = String(i)
            m.text = "This is longer message " + String(i)
            m.incoming = localIncoming
            localIncoming = !localIncoming
            messages.append(m)
        
        }
        
        let newMessageArea = UIView()
        newMessageArea.backgroundColor = UIColor.lightGrayColor()
        newMessageArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newMessageArea)
        
        newMessageField.translatesAutoresizingMaskIntoConstraints = false
        newMessageField.backgroundColor = UIColor.whiteColor()
        newMessageArea.addSubview(newMessageField)
        
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(sendButton)
        sendButton.setTitle("Send", forState: UIControlState.Normal)
        sendButton.setContentHuggingPriority(251, forAxis: .Horizontal)
        
        
        
        
        let messageAreaContraints: [NSLayoutConstraint] =
            [newMessageArea.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
             newMessageArea.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
             newMessageArea.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
             newMessageField.leadingAnchor.constraintEqualToAnchor(newMessageArea.leadingAnchor, constant: 10),
             newMessageField.centerYAnchor.constraintEqualToAnchor(newMessageArea.centerYAnchor),
             sendButton.trailingAnchor.constraintEqualToAnchor(newMessageArea.trailingAnchor, constant: -10),
             newMessageField.trailingAnchor.constraintEqualToAnchor(sendButton.leadingAnchor, constant: -10),
             sendButton.centerYAnchor.constraintEqualToAnchor(newMessageField.centerYAnchor),
             newMessageArea.heightAnchor.constraintEqualToAnchor(newMessageField.heightAnchor, constant: 20)
             ]
        
        NSLayoutConstraint.activateConstraints(messageAreaContraints)
        
        
        
        //Setup tableview
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        
        //Setup Layout TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        //Contraint for Tableview
        let tableViewContrains: [NSLayoutConstraint] = [
                tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
                tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
                tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
                tableView.bottomAnchor.constraintEqualToAnchor(newMessageArea.topAnchor)
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
        
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width , 0, 0)
        
        return cell

    }


}

extension ChatViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}























