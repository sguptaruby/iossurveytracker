//
//  TUHotSpots.swift
//  ServeyTrackerApp
//
//  Created by Apple on 31/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class TUHotSpots: UIView {
    
    @IBOutlet weak var searchLoctionTXT:UITextField!
    @IBOutlet weak var tblHistory:UITableView!
    var activity:MOBTXNSERVEYS!
    var arrgetMp = Array<GetMpTags>()
    var searcharrgetMp = Array<GetMpTags>()

    override func awakeFromNib() {
        super.awakeFromNib()
        searchLoctionTXT.setTextFieldBoader()
        searchLoctionTXT.setLeftPaddingPoints(10)
        searchLoctionTXT.setRightViewImage(imageName: "search")
        tblHistory.register(UINib(nibName: HistoryTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.stringRepresentation)
        tblHistory.tableFooterView = UIView(frame: CGRect.zero)
        searchLoctionTXT.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        
        
    }
    
    func setActivityData(activity:MOBTXNSERVEYS)  {
        let arrIncedent = activity.subIncidentNotes?.components(separatedBy: ",")
        for id in arrIncedent! {
            let idint = Int(id)
            let resultPredicate = NSPredicate(format: "id == %d", idint!)
            let arrObj = GetMpTags.mr_findAll(with: resultPredicate) as! [GetMpTags]
            arrgetMp.append(arrObj.first!)
        }
        searcharrgetMp = arrgetMp
        tblHistory.reloadData()
    }
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
        searcharrgetMp.removeAll()
        if textfield.text?.count != 0 {
            for acitivty in arrgetMp {
                let range = acitivty.name?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil {
                    searcharrgetMp.append(acitivty)
                }
            }
        } else {
            searcharrgetMp = arrgetMp
        }
        
        tblHistory.reloadData()
    }
}

extension TUHotSpots:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searcharrgetMp.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.stringRepresentation) as! HistoryTableViewCell
        let activity = searcharrgetMp[indexPath.row]
        cell.lblDate.text = activity.name
        cell.selectionStyle = .none
        cell.accessoryType = .checkmark
        cell.layer.cornerRadius = 10
        cell.contentVW.layer.borderWidth = 0
        cell.contentVW.layer.cornerRadius = 0
        cell.contentVW.layer.borderColor = UIColor.clear.cgColor
        cell.contentVW.backgroundColor = UIColor.white
        cell.btnDelete.isHidden = true
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 10
//        cell.layer.borderColor = UIColor.darkGray.cgColor
        return cell
    }

}
