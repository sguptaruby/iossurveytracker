//
//  HotsoptsScreen1VC.swift
//  ServeyTrackerApp
//
//  Created by Apple on 22/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HotsoptsScreen1VC: UIViewController {
    
    @IBOutlet weak var provinceTXT:UITextField!
    @IBOutlet weak var districtTXT:UITextField!
    @IBOutlet weak var divisionTXT:UITextField!
    @IBOutlet weak var areaTXT:UITextField!
    @IBOutlet weak var scrollVW:UIScrollView!
    @IBOutlet weak var contentVW:UIView!
    
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

    }
    
    func defaultConfigure() {
        provinceTXT.setTextFieldBoader()
        districtTXT.setTextFieldBoader()
        divisionTXT.setTextFieldBoader()
        areaTXT.setTextFieldBoader()
        provinceTXT.setLeftPaddingPoints(10)
        districtTXT.setLeftPaddingPoints(10)
        divisionTXT.setLeftPaddingPoints(10)
        areaTXT.setLeftPaddingPoints(10)
        divisionTXT.setRightViewImage(imageName: "arrow")
        provinceTXT.setRightViewImage(imageName: "arrow")
        districtTXT.setRightViewImage(imageName: "arrow")
        provinceTXT.delegate = self
        districtTXT.delegate = self
        areaTXT.delegate = self
        divisionTXT.delegate = self
    }
}

extension HotsoptsScreen1VC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
