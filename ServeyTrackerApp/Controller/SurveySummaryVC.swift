//
//  SurveySummaryVC.swift
//  ServeyTrackerApp
//
//  Created by Apple on 07/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import MagicalRecord

class SurveySummaryVC: UIViewController {
    
    @IBOutlet weak var vwSummary:UIView!
    @IBOutlet weak var vwReport:UIView!
    @IBOutlet weak var vwImage:UIView!
    @IBOutlet weak var vwLocation:UIView!
    @IBOutlet weak var btnSubmit:UIButton!
    @IBOutlet weak var tblReport:UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblProvince:UILabel!
    @IBOutlet weak var lblDistrict:UILabel!
    @IBOutlet weak var lbldivision:UILabel!
    @IBOutlet weak var lblarea:UILabel!
    @IBOutlet weak var lblWitnessDate:UILabel!
    @IBOutlet weak var txtMessage:UITextView!
    var latitude: Double!
    var longitude: Double!
    var message: String!
    
    @IBOutlet weak var imgVWCollectionVW:UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        defaultCofiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.backButton(image: "back")
        self.navigationItem.title = "HotSpot Summary"
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.loadMapView), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func defaultCofiguration()  {
        vwSummary.setBoaderSummary()
        vwImage.setBoaderSummary()
        vwLocation.setBoaderSummary()
        vwReport.setBoaderSummary()
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.borderColor = UIColor.darkGray.cgColor
        btnSubmit.layer.masksToBounds = true
        
        lblProvince.text = ": \(ServeyTrackerManager.share.province ?? "")"
        lblDistrict.text = ": \(ServeyTrackerManager.share.district ?? "")"
        lbldivision.text = ": \(ServeyTrackerManager.share.dsdivision ?? "")"
        lblarea.text = ": \(ServeyTrackerManager.share.area ?? "")"
        lblWitnessDate.text = ": \(ServeyTrackerManager.share.witnessDate ?? "")"
        txtMessage.text = message
        tblReport.register(UINib(nibName: HistoryTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.stringRepresentation)
        tblReport.tableFooterView = UIView(frame: CGRect.zero)
        
        imgVWCollectionVW.register(UINib(nibName: ImageCollectionViewCell.stringRepresentation, bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.stringRepresentation)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 10, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        imgVWCollectionVW!.collectionViewLayout = layout
    }
    
    @objc func loadMapView()  {
        let camera = GMSCameraPosition.camera(withLatitude: latitude , longitude: longitude, zoom: 15)
        mapView.camera = camera
        GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    }
    
    @IBAction func btnSubmitAction(sender:UIButton) {
            dataSave()
    }
    
    func dataSave()  {
        self.view.showHUD()
        MagicalRecord.save({ (context : NSManagedObjectContext!) in
            MOBTXNSERVEYS.entityFromDictionaryInContext(aDictionary: ServeyTrackerManager.share.paramsTnxService as NSDictionary, localContext: context)
        }, completion: { (status, error) in
            if status {
                self.view.hideHUD()
                print("Data Save......")
                let arrgetMp = MOBTXNSERVEYS.mr_findAll() as! [MOBTXNSERVEYS]
                print(arrgetMp.first?.id ?? "")
                self.naviagtetToHomeScreen()
            }else{
                self.view.hideHUD()
                print(error.debugDescription)
            }
        })
    }
    
}

extension UIView {
    
    func setBoaderSummary() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.masksToBounds = true
    }
}

extension SurveySummaryVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServeyTrackerManager.share.report.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.stringRepresentation) as! HistoryTableViewCell
                cell.lblDate.text = ServeyTrackerManager.share.report[indexPath.row]
        cell.selectionStyle = .none
        //cell.accessoryType = .checkmark
        return cell
    }
    
}

extension SurveySummaryVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  ServeyTrackerManager.share.arrImages != nil {
            return ServeyTrackerManager.share.arrImages.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.stringRepresentation, for: indexPath) as! ImageCollectionViewCell
        cell.imgView.backgroundColor = UIColor.black
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        let Imgname = self.getImage(imgName: ServeyTrackerManager.share.arrImages[indexPath.row])
        cell.imgView.image = UIImage(contentsOfFile: Imgname!)
        cell.vwBlack.isHidden = false
        cell.btnDelete.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: 100)
    }
    
    @objc func deleteImage(sender:UIButton) {
        let Imgname = self.getImage(imgName: ServeyTrackerManager.share.arrImages[sender.tag])
        self.removeImageFromDocumentDir(itemName: Imgname!)
        ServeyTrackerManager.share.arrImages.remove(at: sender.tag)
        imgVWCollectionVW.reloadData()
    }
}

