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
    
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result).count < 4
        return result
    }

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
        self.navigationItem.title = "Registration"
        let users = self.getAllServeyTrackerUser()
        if users.count == 0 {
            self.navigationItem.hidesBackButton = true
        }else{
            self.backButton(image: "back")
        }
        
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
        emailTxtField.addDoneButton()
        mobileTxtField.addDoneButton()
        
//       emailTxtField.text = "sagargupta709@gmail.com"
//       mobileTxtField.text = "8602699798"
//       firstnameTxtField.text = "sagar"
//       lastnameTxtField.text = "gupta"
    }
    func validation() -> Bool {
        if (emailTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter email.")
            return false
        }
        if (mobileTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter mobile number.")
            return false
        }
        if (firstnameTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter first name.")
            return false
        }
        if (lastnameTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter last name.")
            return false
        }
        return true
    }
    
    func registrationApiCall()  {
        self.view.showHUD()
        let name = "\(firstnameTxtField.text!) \(lastnameTxtField.text!)"
        print(fourDigitNumber)
        let params = ["Email":emailTxtField.text ?? "","Telephone":mobileTxtField.text ?? "","Name":name,"VerificationCode":fourDigitNumber]
        APIClient.init().postRequest(withParams: params, url: URLConstants.signup) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            self.view.hideHUD()
            if JSON != nil {
                let user_id = JSON as? String
                ServeyTrackerManager.share.verificationCode = params["VerificationCode"]
                print(DictionaryKey.user_id)
                let dict = [DictionaryKey.user_id:user_id!,DictionaryKey.email:self.emailTxtField.text!,DictionaryKey.telephone:self.mobileTxtField.text!,DictionaryKey.fname:self.firstnameTxtField.text!,DictionaryKey.lname:self.lastnameTxtField.text!]
                self.saveUser(dict: dict)
                print(JSON ?? "nil")
                self.showSuccessAlert()
            }else{
                self.showAlert(title: "Alert!", message: "Something went to wrong.Please try again.")
            }
        }
    }
    
    func showSuccessAlert()  {
        let alertvc = UIAlertController(title: "Register Success", message: "Verification Code will received to registered Phone number Via SMS And Via E-mail shortly.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: false)
        }
        alertvc.addAction(action)
        self.present(alertvc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnRegisterAction(sender:UIButton) {
        if validation() {
            registrationApiCall()
        }
    }
}

extension RegisterViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
