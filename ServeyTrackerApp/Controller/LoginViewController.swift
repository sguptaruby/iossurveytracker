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
        self.hideNavigationBar()
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
    }
    
    func validation() -> Bool {
        if (emailTxtField.text?.isEmpty)! {
            return false
        }
        if (mobileTxtField.text?.isEmpty)! {
            return false
        }
        if (verificationTxtField.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    func loginApiCall()  {
        let params = ["Email":emailTxtField.text ?? "","Telephone":mobileTxtField.text ?? ""]
        APIClient.init().postRequest(withParams: params, url: URLConstants.login) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            
        }
    }
    
    func sendVerificationCodeApi()  {
        let params = ["VerificationCode":emailTxtField.text ?? ""]
        APIClient.init().postRequest(withParams: params, url: URLConstants.sendVerificationCode) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            
        }
    }
    
    @IBAction func btnLoginAction(sender:UIButton) {
        let menustoryboard = UIStoryboard.init(name: "Menu", bundle: nil)
        let vc = menustoryboard.instantiateViewController(withIdentifier: MenuViewController.stringRepresentation) as! MenuViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnSendVerificationCodeAction(sender:UIButton) {
    
    }
}

extension LoginViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
