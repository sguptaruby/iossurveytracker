//
//  HotsoptsScreen4VC.swift
//  ServeyTrackerApp
//
//  Created by Apple on 23/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HotsoptsScreen4VC: UIViewController {
    
    @IBOutlet weak var messageTXT:UITextView!
    @IBOutlet weak var btnCheck: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defaultConfigure()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButton(image: "back")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultConfigure() {
        messageTXT.layer.borderWidth = 1
        messageTXT.layer.borderColor = UIColor.darkGray.cgColor
        btnCheck.tag = 1
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(keyboardresign))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        messageTXT.inputAccessoryView = keyboardToolbar
    }
    
    @IBAction func btnCheckBoxAction(sender:UIButton) {
        if btnCheck.tag == 1 {
            btnCheck.tag = 2
            btnCheck.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }else{
            btnCheck.tag = 1
            btnCheck.setImage(nil, for: .normal)
        }
    }
    
    @objc func keyboardresign()  {
        messageTXT.resignFirstResponder()
    }
}

extension HotsoptsScreen4VC:UITextViewDelegate {
    
}
