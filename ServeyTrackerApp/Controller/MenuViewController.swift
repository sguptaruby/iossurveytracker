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
    var imageData = Array<Data>()
    
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
        self.getMpTagsApiCall()
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
    
    @IBAction func btnSyncAction(sender:UIButton) {
        getAllActivity()
        if ServeyTrackerManager.share.activityParams.count != 0 {
            let params = ["activity":ServeyTrackerManager.share.activityParams]
            print(params)
            self.updateActivityApiCall(params: params)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                for strImageName in ServeyTrackerManager.share.arrImages {
                    let imageStr = self.getImage(imgName: strImageName)
                    let imag = UIImage(contentsOfFile: imageStr!)
                    let imgdata = UIImageJPEGRepresentation(imag!, 0.5)
                    self.imageData.append(imgdata!)
                    self.updateActivityImagesApiCall(imageData: self.imageData, imageName: ServeyTrackerManager.share.arrImages)
                }
            })

        }
    }

}
