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
    }

}

extension ProfileViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
