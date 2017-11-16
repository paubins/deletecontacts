//
//  ViewController.swift
//  DeleteContacts
//
//  Created by Patrick Aubin on 11/15/17.
//  Copyright © 2017 Patrick Aubin. All rights reserved.
//

import UIKit
import Cartography
import Contacts
import PhoneNumberKit

class ViewController: UIViewController {

    lazy var label:UILabel = {
        var label:UILabel = UILabel(frame: .zero)
        label.text = "1. Submit the number you wish to have deleted."
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textField:UITextField = {
        var textField:UITextField = UITextField(frame: .zero)
        return textField
    }()
    
    lazy var verifyButton:UIButton = {
        var verifyButton:UIButton = UIButton(frame: .zero)
        verifyButton.addTarget(self, action: #selector(self.verify), for: .touchUpInside)
        verifyButton.setTitle("Verify", for: .normal)
        verifyButton.setTitleColor(.black, for: .normal)
        return verifyButton
    }()
    
    lazy var label2:UILabel = {
        var label:UILabel = UILabel(frame: .zero)
        label.text = "2. To verify your number we must have access to your contacts"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var label3:UILabel = {
        var label:UILabel = UILabel(frame: .zero)
        label.text = "3. WARNING: During the verification steps, if we come across a number that is requested for deletion, we will do so."
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var label4:UILabel = {
        var label:UILabel = UILabel(frame: .zero)
        label.text = "4. Once your number is verified to be in your contacts, we will text you a four digit code"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var label5:UILabel = {
        var label:UILabel = UILabel(frame: .zero)
        label.text = "5. Enter that verification code here:"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textInput:UITextView = {
        var textInput:UITextView = UITextView(frame: .zero)
        textInput.layer.borderColor = UIColor.black.cgColor
        textInput.layer.borderWidth = 3
        return textInput
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.label)
        self.view.addSubview(self.textField)
        self.view.addSubview(self.verifyButton)
        
        self.view.addSubview(self.label2)
        self.view.addSubview(self.label3)
        self.view.addSubview(self.label4)
        self.view.addSubview(self.label5)
        
        constrain(self.label, self.textField, self.verifyButton) { (view, view1, view2) in
            view.centerX == view.superview!.centerX
            view1.centerX == view.superview!.centerX
            
            view.top == view.superview!.top + 20
            view.bottom == view1.top
            view1.height == 30
            view1.width == 100
            
            view2.top == view1.bottom
            view2.centerX == view2.superview!.centerX
            view2.width == 100
            view2.height == 40
        }
        
        constrain(self.verifyButton, self.label2, self.label3, self.label4, self.label5) { (view, view1, view2, view3, view4) in
            
            view.centerX == view.superview!.centerX
            view1.centerX == view.superview!.centerX
            view2.centerX == view.superview!.centerX
            view3.centerX == view.superview!.centerX
            view4.centerX == view.superview!.centerX
            
            view1.width == view1.superview!.width - 100
            view2.width == view2.superview!.width - 100
            view3.width == view3.superview!.width - 100
            view4.width == view4.superview!.width - 100
            
            view.bottom == view1.top - 30
            view1.bottom == view2.top - 30
            view2.bottom == view3.top - 30
            view3.bottom == view4.top - 30
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func verify(sender: UIButton) {
        self.contacts(delete: "7082785155")
    }
    
    func contacts(delete phone:String) {
        let contactStore:CNContactStore = CNContactStore()
        let phoneNumberKit:PhoneNumberKit = PhoneNumberKit()
        
        contactStore.requestAccess(for: .contacts) { (granted, error) in
            if (granted) {
                let containerId:String = contactStore.defaultContainerIdentifier()
                let predicate:NSPredicate = CNContact.predicateForContacts(withIdentifiers: [containerId])
                
                let keys:[CNKeyDescriptor] = [CNContactPhoneNumbersKey as CNKeyDescriptor,
                                              CNContactPhoneticGivenNameKey as CNKeyDescriptor]
                
                let cnContacts:[CNContact]!
                do {
                    cnContacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keys)
                    
                    let saveRequest:CNSaveRequest = CNSaveRequest()
                    
                    for var contact:CNContact in cnContacts {
                        let mutableContact:CNMutableContact = contact.mutableCopy() as! CNMutableContact
                        var phoneNumbers:[CNLabeledValue<CNPhoneNumber>] = mutableContact.phoneNumbers
                        
                        for (i, phoneNumber) in phoneNumbers.enumerated() {
                            if (phoneNumber.value.stringValue == phone) {
                                phoneNumbers.remove(at: i)
                                print("removed phone number")
                            }
                        }

                        saveRequest.update(mutableContact)
                    }
                    
                    do {
                        try contactStore.execute(saveRequest)
                    } catch {
                        print(error)
                    }
                } catch {
                    print(error)
                }
                
                
            }
        }
    }
}

