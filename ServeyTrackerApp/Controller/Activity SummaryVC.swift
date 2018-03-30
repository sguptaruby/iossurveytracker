//
//  Activity SummaryVC.swift
//  ServeyTrackerApp
//
//  Created by Apple on 30/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import GoogleMaps

class Activity_SummaryVC: UIViewController {
    
    @IBOutlet weak var dateTXT:UITextField!
    @IBOutlet weak var cityTXT:UITextField!
    @IBOutlet weak var noteTXT:UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    var activity:MOBTXNSERVEYS!
    var latitude: Double = 0
    var longitude: Double = 0
    var tuhotspots:TUHotSpots!
    var HotspotsVW:HotspotsImageVW!
    
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
        self.title = "Activity Summary"
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.loadMapView), userInfo: nil, repeats: false)
    }
    
    func defaultConfigure() {
        dateTXT.setTextFieldBoader()
        dateTXT.setLeftPaddingPoints(10)
        dateTXT.setRightViewImage(imageName: "calander")
        cityTXT.setTextFieldBoader()
        cityTXT.setLeftPaddingPoints(10)
        noteTXT.setTextFieldBoader()
        noteTXT.setLeftPaddingPoints(10)
        latitude = activity.latitude
        longitude = activity.longitude
        noteTXT.text = activity.note
        cityTXT.text = activity.area
        dateTXT.text = activity.date
        dateTXT.isUserInteractionEnabled = false
        cityTXT.isUserInteractionEnabled = false
        noteTXT.isUserInteractionEnabled = false
        tuhotspots = TUHotSpots.instanceFromNib() as! TUHotSpots
        tuhotspots.frame = CGRect(x: 0, y: 64, width:view.frame.size.width, height: view.frame.size.height-120)
        tuhotspots.setActivityData(activity: activity)
        tuhotspots.isHidden = true
        self.view.addSubview(tuhotspots)
        
        HotspotsVW = HotspotsImageVW.instanceFromNib() as! HotspotsImageVW
        HotspotsVW.frame = CGRect(x: 0, y: 64, width:view.frame.size.width, height: view.frame.size.height-120)
        HotspotsVW.setActivityData(activity: activity)
        HotspotsVW.isHidden = true
        self.view.addSubview(HotspotsVW)
    }
    
    @objc func loadMapView()  {
        let camera = GMSCameraPosition.camera(withLatitude: activity.latitude , longitude: activity.longitude, zoom: 15)
        mapView.camera = camera
        GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    }
    
    @IBAction func btnSummary(sendeR:UIButton) {
        tuhotspots.isHidden = true
        HotspotsVW.isHidden = true
    }
    
    @IBAction func btnTUHotspots(sendeR:UIButton) {
        tuhotspots.isHidden = false
        HotspotsVW.isHidden = true
    }
    
    @IBAction func btnImage(sendeR:UIButton) {
        tuhotspots.isHidden = true
        HotspotsVW.isHidden = false
    }
    
}
