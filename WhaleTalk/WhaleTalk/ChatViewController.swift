//
//  ViewController.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 4/21/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    
    private let newMessageField = UITextField()
    
    private var bottomConstraint: NSLayoutConstraint!
    
    private var sections = [NSDate: [Message]]()
    
    private var dates = [NSDate]()
    
    private let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fake data
        
        var localIncoming = true;
        var date = NSDate(timeIntervalSince1970: 1100000000)
        for i in 0...10
        {
            let m = Message()
            //m.text = String(i)
            m.text = "This is longer message " + String(i)
            m.timeStamp = date
            m.incoming = localIncoming
            localIncoming = !localIncoming
            addMessage(m)
            
            if i%2 == 0
            {
                date = NSDate(timeInterval: 60 * 60 * 24, sinceDate: date)
            }
        
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
        sendButton.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        sendButton.addTarget(self, action: #selector(ChatViewController.pressdSend(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        bottomConstraint = newMessageArea.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        bottomConstraint.active = true
        
        
        let messageAreaContraints: [NSLayoutConstraint] =
            [newMessageArea.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
             newMessageArea.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let tabRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleSingleTab(_:)))
        tabRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tabRecognizer)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.scrollToBottom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSingleTab (recognizer: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    func keyboardWillShow (notification: NSNotification)
    {
        updateBottomConstraint(notification)
    }
    func keyboardWillHide (notification: NSNotification)
    {
        updateBottomConstraint(notification)
    }
    
    func updateBottomConstraint (notification: NSNotification)
    {
        if  let userInfo = notification.userInfo,
            frame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue,
            animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        {
            let newFrame = view.convertRect(frame, fromView: (UIApplication.sharedApplication().delegate?.window)!)
            bottomConstraint.constant = newFrame.origin.y - CGRectGetHeight(view.frame)
            UIView.animateWithDuration(animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
        tableView.scrollToBottom()
    
    }
    
    func pressdSend (button: UIButton)
    {
        guard let text = newMessageField.text where text.characters.count > 0 else {return}
        let message = Message()
        message.text = text
        message.incoming = false
        message.timeStamp = NSDate()
        addMessage(message)
        newMessageField.text = ""
        tableView.reloadData()
        tableView.scrollToBottom()
        view.endEditing(true)
        
    }
    
    func addMessage (message: Message)
    {
        guard let date = message.timeStamp else {return}
        let calendar = NSCalendar.currentCalendar()
        let startDay = calendar.startOfDayForDate(date)
        
        var messages = sections[startDay]
        
        if (messages == nil)
        {
            dates.append(startDay)
            messages = [Message]()
        }
        
        messages?.append(message)
        sections[startDay] = messages
        
    }
    
    
}

extension ChatViewController: UITableViewDataSource
{
    func getMessages(section: Int) -> [Message] {
        let date = dates[section]
        return sections[date]!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dates.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMessages(section).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell
        
        let message = getMessages(indexPath.section)[indexPath.row]
        
        cell.messageLabel.text = message.text
        
        cell.incoming(message.incoming)
        
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width , 0, 0)
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        let paddingView = UIView()
        view.addSubview(paddingView)
        
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        
        paddingView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints :[NSLayoutConstraint] = [
                    paddingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
                    paddingView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor),
                    dateLabel.centerXAnchor.constraintEqualToAnchor(paddingView.centerXAnchor),
                    dateLabel.centerYAnchor.constraintEqualToAnchor(paddingView.centerYAnchor),
                    paddingView.heightAnchor.constraintEqualToAnchor(dateLabel.heightAnchor, constant: 5),
                    paddingView.widthAnchor.constraintEqualToAnchor(dateLabel.widthAnchor, constant: 10),
                    view.heightAnchor.constraintEqualToAnchor(paddingView.heightAnchor)
                    ]
        NSLayoutConstraint.activateConstraints(constraints)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        dateLabel.text = formatter.stringFromDate(dates[section])
        
        paddingView.layer.cornerRadius = 10
        paddingView.layer.masksToBounds = true
        paddingView.backgroundColor = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        return view
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }


}

extension ChatViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}
























