//
//  HotsoptsScreen2VC.swift
//  ServeyTrackerApp
//
//  Created by Apple on 23/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HotsoptsScreen2VC: UIViewController {
    
    @IBOutlet weak var reportTXT:UITextField!
    @IBOutlet weak var applyTXT:UITextField!

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
        reportTXT.setTextFieldBoader()
        applyTXT.setTextFieldBoader()
        reportTXT.setLeftPaddingPoints(10)
        applyTXT.setLeftPaddingPoints(10)
        reportTXT.setRightViewImage(imageName: "arrow")
        applyTXT.setRightViewImage(imageName: "search")
        reportTXT.delegate = self
        applyTXT.delegate = self
    }
    

}

extension HotsoptsScreen2VC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
