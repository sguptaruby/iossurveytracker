//
//  ProfileViewController.swift
//  ServeyTrackerApp
//
//  Created by Apple on 24/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField:UITextField!
    @IBOutlet weak var mobileTxtField:UITextField!
    @IBOutlet weak var firstnameTxtField:UITextField!
    @IBOutlet weak var lastnameTxtField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.backButton(image: "back")
        self.navigationItem.title = "My account"
    }
    
    func defaultConfigure() {
        
        emailTxtField.setLeftPaddingPoints(10)
        mobileTxtField.setLeftPaddingPoints(10)
        firstnameTxtField.setLeftPaddingPoints(10)
        lastnameTxtField.setLeftPaddingPoints(10)
        lastnameTxtField.setTextFieldBoader()
        firstnameTxtField.setTextFieldBoader()
        mobileTxtField.setTextFieldBoader()
        emailTxtField.setTextFieldBoader()
        
        emailTxtField.delegate = self
        mobileTxtField.delegate = self
        firstnameTxtField.delegate = self
        lastnameTxtField.delegate = self
        
        if let dictuser = self.getAllServeyTrackerUser() {
            emailTxtField.text = dictuser[DictionaryKey.email] as? String ?? ""
            mobileTxtField.text = dictuser[DictionaryKey.telephone] as? String ?? ""
            firstnameTxtField.text = dictuser[DictionaryKey.fname] as? String ?? ""
            lastnameTxtField.text = dictuser[DictionaryKey.lname] as? String ?? ""
        }else{
            emailTxtField.text = DictionaryKey.DefaultUser.email
            mobileTxtField.text = DictionaryKey.DefaultUser.number
            firstnameTxtField.text = DictionaryKey.DefaultUser.firstname
            lastnameTxtField.text = DictionaryKey.DefaultUser.Lastname
        }
        emailTxtField.isUserInteractionEnabled = false
        mobileTxtField.isUserInteractionEnabled = false
        firstnameTxtField.isUserInteractionEnabled = false
        lastnameTxtField.isUserInteractionEnabled = false
    }

}

extension ProfileViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
