//
//  LoginViewController.swift
//  ServeyTrackerApp
//
//  Created by Apple on 21/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnSendCode:UIButton!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var emailTxtField:UITextField!
    @IBOutlet weak var mobileTxtField:UITextField!
    @IBOutlet weak var verificationTxtField:UITextField!
    
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
        let result = UserDefaults.standard.value(forKey: "LoginStatus") as! Bool
        if result {
            let menustoryboard = UIStoryboard.init(name: "Menu", bundle: nil)
            let vc = menustoryboard.instantiateViewController(withIdentifier: MenuViewController.stringRepresentation) as! MenuViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let users = self.getAllServeyTrackerUser()
        if users.count == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:RegisterViewController.stringRepresentation)
            self.navigationController?.pushViewController(vc!, animated: false)
        }else{
//            let menustoryboard = UIStoryboard.init(name: "Menu", bundle: nil)
//            let vc = menustoryboard.instantiateViewController(withIdentifier: MenuViewController.stringRepresentation) as! MenuViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        defaultConfigure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        //self.getMpTagsApiCall()
        
        let users = self.getAllServeyTrackerUser()
        if users.count != 0 {
            emailTxtField.text = users[DictionaryKey.email] as? String ?? ""
            mobileTxtField.text = users[DictionaryKey.telephone] as? String ?? ""
        }
    }
    
    func defaultConfigure()  {
        let vwUnderline = UIView()
        vwUnderline.frame = CGRect(x: 0, y: btnSendCode.frame.height, width: btnSendCode.frame.size.width, height: 1)
        vwUnderline.backgroundColor = UIColor(red: 25/255.0, green: 80/255.0, blue: 160/255.0, alpha: 1.0)
        btnSendCode.addSubview(vwUnderline)
        
        let vwUnderlineRegiter = UIView()
        vwUnderlineRegiter.frame = CGRect(x: 0, y: btnRegister.frame.height-10, width: (btnRegister.frame.size.width/2)+20, height: 1)
        vwUnderlineRegiter.backgroundColor = UIColor(red: 25/255.0, green: 80/255.0, blue: 160/255.0, alpha: 1.0)
        btnRegister.addSubview(vwUnderlineRegiter)
        emailTxtField.setLeftPaddingPoints(10)
        mobileTxtField.setLeftPaddingPoints(10)
        verificationTxtField.setLeftPaddingPoints(10)
        emailTxtField.setTextFieldBoader()
        mobileTxtField.setTextFieldBoader()
        verificationTxtField.setTextFieldBoader()
        emailTxtField.delegate = self
        mobileTxtField.delegate = self
        verificationTxtField.delegate = self
        emailTxtField.addDoneButton()
        mobileTxtField.addDoneButton()
        verificationTxtField.addDoneButton()
    }
    
    func validation() -> Bool {
        let dict = self.getAllServeyTrackerUser()
        print(dict)
        if (emailTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter email.")
            return false
        }
        if (mobileTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter mobile number.")
            return false
        }
        if (verificationTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter verification.")
            return false
        }
        if dict[DictionaryKey.email] as! String != emailTxtField.text! {
            self.showAlert(title: "", message: "enter vaild user.")
            return false
        }
        if dict[DictionaryKey.telephone] as! String != mobileTxtField.text! {
            self.showAlert(title: "", message: "enter vaild mobile number.")
            return false
        }
        if verificationTxtField.text != ServeyTrackerManager.share.verificationCode {
            self.showAlert(title: "", message: "Verification code is invalid.Please enter valid code.")
            return false
        }
        return true
    }
    
    
    
    func verificationCodevalidation() -> Bool {
        if (emailTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter email.")
            return false
        }
        if (mobileTxtField.text?.isEmpty)! {
            self.showAlert(title: "", message: "Please enter mobile number.")
            return false
        }
        return true
    }
    
    func checkUserEneterValidData() -> Bool {
        let dict = self.getAllServeyTrackerUser()
        print(dict)
        return true
    }
    
    func loginApiCall()  {
        let params = ["Email":emailTxtField.text ?? "","Telephone":mobileTxtField.text ?? ""]
        APIClient.init().postRequest(withParams: params, url: URLConstants.login) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            
        }
    }
    
    func sendVerificationCodeApi()  {
        let params = ["Email":emailTxtField.text ?? "","VerificationCode":fourDigitNumber]
        APIClient.init().postRequest(withParams: params, url: URLConstants.sendVerificationCode) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            if JSON != nil {
                ServeyTrackerManager.share.verificationCode = params["VerificationCode"]
                print(JSON ?? "nil")
                self.showAlert(title: "", message: "Verification Code will received to registered Phone number Via SMS And Via E-mail shortly.")
            }else{
                self.showAlert(title: "Alert!", message: "Something went to wrong.Please try again.")
            }
        }
    }
    
    @IBAction func btnLoginAction(sender:UIButton) {
        if validation() {
            UserDefaults.standard.set(true, forKey: "LoginStatus")
            let menustoryboard = UIStoryboard.init(name: "Menu", bundle: nil)
            let vc = menustoryboard.instantiateViewController(withIdentifier: MenuViewController.stringRepresentation) as! MenuViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSendVerificationCodeAction(sender:UIButton) {
        if verificationCodevalidation() {
            sendVerificationCodeApi()
        }
    }
}

extension LoginViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
