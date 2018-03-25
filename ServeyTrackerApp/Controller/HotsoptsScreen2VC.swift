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
    var categoryVW:CategoryView!
    @IBOutlet weak var tblSubCategory:UITableView!
    var arrSubCategoryData:[GetMpTags] = []
    
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
        categoryVW = CategoryView.instanceFromNib() as! CategoryView
        categoryVW.frame = self.view.bounds
        categoryVW.lbltilte.text = "Provision"
        categoryVW.isHidden = true
        categoryVW.delegate = self
        self.view.addSubview(categoryVW)
        self.view.bringSubview(toFront: categoryVW)
        tblSubCategory.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblSubCategory.tableFooterView = UIView(frame: CGRect.zero)
    }
    

}

extension HotsoptsScreen2VC:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubCategoryData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        let tagsObj = arrSubCategoryData[indexPath.row] as! GetMpTags
        cell.textLabel?.text = tagsObj.name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HotsoptsScreen2VC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == reportTXT {
            self.hideNavigationBar()
            let mptagsData = self.getnpTagsIncidentData(id: "1")
            categoryVW.arrCategoryData = mptagsData
            categoryVW.tblCategory.reloadData()
            categoryVW.lbltilte.text = "Reported Incident"
            categoryVW.isHidden = false
            textField.resignFirstResponder()
        }
    }
}

extension HotsoptsScreen2VC:CategoryViewDelegate {
    func didCancel() {
        self.showNavigationBar()
        categoryVW.isHidden = true
    }
    
    func didSelectedData(data: Any, type: String) {
        let getmptag = data as! GetMpTags
        self.showNavigationBar()
        reportTXT.text = getmptag.name
        categoryVW.isHidden = true
        let subData = self.getnpTagsIncidentSubData(id: getmptag.parentId)
        self.arrSubCategoryData = subData
        self.tblSubCategory.reloadData()
    }
}
