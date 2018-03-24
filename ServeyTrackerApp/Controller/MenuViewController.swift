//
//  MenuViewController.swift
//  ServeyTrackerApp
//
//  Created by Apple on 22/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var contentVW:UIView!
    @IBOutlet weak var hotspotsVW:UIView!
    @IBOutlet weak var historyVW:UIView!
    @IBOutlet weak var syncVW:UIView!
    @IBOutlet weak var profileVW:UIView!
    @IBOutlet weak var profileLbL:UILabel!
    @IBOutlet weak var syncLBL:UILabel!
    @IBOutlet weak var historyLBL:UILabel!
    @IBOutlet weak var hotspotsLBL:UILabel!

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
        contentVW.layer.cornerRadius = 10
        contentVW.layer.masksToBounds = true
        contentVW.layer.borderWidth = 1
        contentVW.layer.borderColor = UIColor.lightGray.cgColor
        
        setBoaderonView(view: hotspotsVW)
        setBoaderonView(view: historyVW)
        setBoaderonView(view: syncVW)
        setBoaderonView(view: profileVW)
        
        if DeviceType.IS_IPHONE_5 {
             profileLbL.font = UIFont.boldSystemFont(ofSize: 12)
             syncLBL.font = UIFont.boldSystemFont(ofSize: 12)
             historyLBL.font = UIFont.boldSystemFont(ofSize: 12)
             hotspotsLBL.font = UIFont.boldSystemFont(ofSize: 12)
        }
    }
    
    func setBoaderonView(view:UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
    }

}
