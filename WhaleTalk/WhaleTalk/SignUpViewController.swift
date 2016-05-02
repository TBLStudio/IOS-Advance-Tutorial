//
//  SignUpViewController.swift
//  WhaleTalk
//
//  Created by Ngo Thai on 5/2/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let phoneNumberField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    
    var remoteStore: RemoteStore?
    
    var contactImporter: ContactImporter?
    var rootViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel()
        label.text = "Sign up with WhaleTalk"
        label.font = UIFont.systemFontOfSize(24)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let continueButton = UIButton()
        continueButton.setTitle("Continue", forState: UIControlState.Normal)
        continueButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        continueButton.addTarget(self, action: #selector(SignUpViewController.pressedContinue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(continueButton)
        
        phoneNumberField.keyboardType = .PhonePad

        let fields = [
            (phoneNumberField, "Phone Number"),
            (emailField, "Email"),
            (passwordField, "Password")
        ]
        fields.forEach {
            $0.0.placeholder = $0.1
        }
        
        passwordField.secureTextEntry = true
        
        let stackView = UIStackView(arrangedSubviews: fields.map{$0.0})
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] =
        [
            label.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 20),
            label.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            stackView.topAnchor.constraintEqualToAnchor(label.bottomAnchor,constant: 20),
            stackView.leadingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.trailingAnchor),
            continueButton.topAnchor.constraintEqualToAnchor(stackView.bottomAnchor, constant: 20),
            continueButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        phoneNumberField.becomeFirstResponder()
        

        // Do any additional setup after loading the view.
    }
    
    func pressedContinue (sender: UIButton) {
        sender.enabled = false
        
        guard let phoneNumber = phoneNumberField.text where phoneNumber.characters.count > 0 else {
            alertForError("Please enter your phone number.")
            sender.enabled = true
            return
        }
        guard let email = emailField.text where email.characters.count > 0 else {
            alertForError("Please enter your email address.")
            sender.enabled = true
            return
        }
        
        guard let password = passwordField.text where password.characters.count >= 6 else {
            alertForError("Password must be at least 6 characters.")
            sender.enabled = true
            return
        }
        
        remoteStore?.signUp(phoneNumber: phoneNumber, email: email, password: password,
        success: {
            guard let rootVC = self.rootViewController, remoteStore = self.remoteStore, contactImporter = self.contactImporter else {return}
            remoteStore.startSyncing()
            contactImporter.fetch()
            contactImporter.listenForChanges()
            self.presentViewController(rootVC, animated: true, completion: nil)
            },
       error: { (errorMessage) in
                self.alertForError(errorMessage)
                sender.enabled = true
        })
    
    }
    
    private func alertForError(error: String)
    {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
