//
//  HistoryViewController.swift
//  ServeyTrackerApp
//
//  Created by Apple on 24/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var searchLoctionTXT:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.backButton(image: "back")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func defaultConfigure() {
        searchLoctionTXT.setTextFieldBoader()
        searchLoctionTXT.setLeftPaddingPoints(10)
        searchLoctionTXT.setRightViewImage(imageName: "search")
        searchLoctionTXT.delegate = self
    }

}

extension HistoryViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
