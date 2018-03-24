//
//  RegisterViewController.swift
//  ServeyTrackerApp
//
//  Created by Apple on 22/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField:UITextField!
    @IBOutlet weak var mobileTxtField:UITextField!
    @IBOutlet weak var firstnameTxtField:UITextField!
    @IBOutlet weak var lastnameTxtField:UITextField!
    @IBOutlet weak var scrollVW:UIScrollView!

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if DeviceType.IS_IPHONE_5 {
            scrollVW.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 100)
        }
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
    func validation() -> Bool {
        if (emailTxtField.text?.isEmpty)! {
            return false
        }
        if (mobileTxtField.text?.isEmpty)! {
            return false
        }
        if (firstnameTxtField.text?.isEmpty)! {
            return false
        }
        if (lastnameTxtField.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    func registrationApiCall()  {
        let params = ["Email":emailTxtField.text ?? "","Telephone":mobileTxtField.text ?? "","Name":firstnameTxtField.text ?? "","lname":lastnameTxtField.text ?? ""]
        APIClient.init().postRequest(withParams: params, url: URLConstants.signup) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            
        }
    }
}

extension RegisterViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
