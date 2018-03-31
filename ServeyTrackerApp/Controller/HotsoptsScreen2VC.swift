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
    var searchsubCategory = Array<GetMpTags>()
    var selectedIndexPathArray = Array<IndexPath>()
    var subIncidentIdArray = Array<String>()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButton(image: "back")
        self.navigationItem.title = "Report HotSpot"
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
        reportTXT.tintColor = UIColor.clear
        applyTXT.tintColor = UIColor.clear
        self.view.addSubview(categoryVW)
        self.view.bringSubview(toFront: categoryVW)
        tblSubCategory.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblSubCategory.tableFooterView = UIView(frame: CGRect.zero)
        applyTXT.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
    }
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
        searchsubCategory.removeAll()
        if textfield.text?.count != 0 {
            for maptag in arrSubCategoryData {
                let range = maptag.name?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil {
                    searchsubCategory.append(maptag)
                }
            }
        } else {
            searchsubCategory = arrSubCategoryData
        }
        
        tblSubCategory.reloadData()
    }
    
    func validation() -> Bool {
        if (reportTXT.text?.isEmpty)! {
            self.showAlert(title: "", message: "Select repot incident")
            return false
        }
        if selectedIndexPathArray.count == 0 {
            self.showAlert(title: "", message: "Please select sub incident at lest one.")
            return false
        }
        return true
    }
    
    @IBAction func btnNextAction(sender:UIButton) {
        if validation() {
            
            for sip in selectedIndexPathArray {
                let data = searchsubCategory[sip.row]
                subIncidentIdArray.append("\(data.id)")
            }
            let stringRepresentation = subIncidentIdArray.joined(separator: ",")
            print(subIncidentIdArray)
        ServeyTrackerManager.share.paramsTnxService[DictionaryKey.subIncidentNotes] = stringRepresentation
            let vc = self.storyboard?.instantiateViewController(withIdentifier: HotsoptsScreen3VC.stringRepresentation)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }

}

extension HotsoptsScreen2VC:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchsubCategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let tagsObj = self.searchsubCategory[indexPath.row]
        cell?.textLabel?.text = tagsObj.name
        cell?.selectionStyle = .none
        cell?.accessoryType = .none
        for sip in selectedIndexPathArray {
            if indexPath == sip {
                cell?.accessoryType = .checkmark
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPathArray.count == 0 {
            selectedIndexPathArray.append(indexPath)
        }else{
            let cell = tableView.cellForRow(at: indexPath)
            if selectedIndexPathArray.contains(indexPath) {
                cell?.accessoryType = .none
                selectedIndexPathArray.remove(at: selectedIndexPathArray.index(of: indexPath)!)
            }else{
                selectedIndexPathArray.append(indexPath)
            }
            
        }
        tableView.reloadData()
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
        }else{
            textField.becomeFirstResponder()
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
        ServeyTrackerManager.share.paramsTnxService[DictionaryKey.incidentId] = getmptag.id
        reportTXT.text = getmptag.name
        categoryVW.isHidden = true
        let subData = self.getnpTagsIncidentSubData(id: getmptag.id)
        selectedIndexPathArray.removeAll()
        self.arrSubCategoryData = subData
        self.searchsubCategory = self.arrSubCategoryData
        self.tblSubCategory.reloadData()
    }
}
