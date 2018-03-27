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
    var categoryVW:CategoryView!
    
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
        categoryVW = CategoryView.instanceFromNib() as! CategoryView
        categoryVW.frame = self.view.bounds
        categoryVW.lbltilte.text = "Provision"
        categoryVW.isHidden = true
        categoryVW.delegate = self
        self.view.addSubview(categoryVW)
        self.view.bringSubview(toFront: categoryVW)
    }
    
    func validation() -> Bool {
        if (provinceTXT.text?.isEmpty)! {
            self.showAlert(title: "", message: "Select provision")
            return false
        }
        if (districtTXT.text?.isEmpty)! {
            self.showAlert(title: "", message: "Select District")
            return false
        }
        if (divisionTXT.text?.isEmpty)! {
            self.showAlert(title: "", message: "Select District")
            return false
        }
        if (areaTXT.text?.isEmpty)! {
            self.showAlert(title: "", message: "Enter area")
            return false
        }
        return true
    }
    
    @IBAction func btnNextAction(sender:UIButton) {
        if validation() {
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.area] = areaTXT.text
            print( ServeyTrackerManager.share.paramsTnxService)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: HotsoptsScreen2VC.stringRepresentation)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension HotsoptsScreen1VC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if provinceTXT == textField {
            self.hideNavigationBar()
            let mptagsData = self.getnpTagsProvisionData(id: "3")
            categoryVW.arrCategoryData = mptagsData
            categoryVW.tblCategory.reloadData()
            categoryVW.lbltilte.text = "Provision"
            categoryVW.isHidden = false
            textField.resignFirstResponder()
        }else if districtTXT == textField {
            self.hideNavigationBar()
            let mptagsData = self.getnpTagsDistrictData(id: ServeyTrackerManager.share.selectedDistrictID)
            categoryVW.arrCategoryData = mptagsData
            categoryVW.tblCategory.reloadData()
            categoryVW.lbltilte.text = "District"
            categoryVW.isHidden = false
            textField.resignFirstResponder()
        }else if divisionTXT == textField {
            self.hideNavigationBar()
            let mptagsData = self.getnpTagsDivisonData(id: ServeyTrackerManager.share.selectedDivisonID)
            categoryVW.arrCategoryData = mptagsData
            categoryVW.tblCategory.reloadData()
            categoryVW.lbltilte.text = "DS Divison"
            categoryVW.isHidden = false
            textField.resignFirstResponder()
        }else{
            
        }
    }
}
extension HotsoptsScreen1VC:CategoryViewDelegate {
    func didCancel() {
        self.showNavigationBar()
        categoryVW.isHidden = true
    }
    
    func didSelectedData(data: Any, type: String) {
        let getmptag = data as! GetMpTags
         self.showNavigationBar()
        if type == "Provision" {
            provinceTXT.text = getmptag.name
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.provinceId] = getmptag.id
            ServeyTrackerManager.share.selectedDistrictID = getmptag.id
        }
        if type == "District" {
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.districtId] = getmptag.id
            ServeyTrackerManager.share.selectedDivisonID  = getmptag.id
            districtTXT.text = getmptag.name
        }
        if type == "DS Divison" {
            ServeyTrackerManager.share.paramsTnxService[DictionaryKey.dsDivisionId] = getmptag.id
            divisionTXT.text = getmptag.name
        }
        categoryVW.isHidden = true
    }
}
