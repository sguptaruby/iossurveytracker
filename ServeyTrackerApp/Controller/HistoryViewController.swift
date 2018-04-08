//
//  HistoryViewController.swift
//  ServeyTrackerApp
//
//  Created by Apple on 24/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MagicalRecord

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var searchLoctionTXT:UITextField!
    @IBOutlet weak var tblHistory:UITableView!
    var arrgetMp = Array<MOBTXNSERVEYS>()
    var searcharrgetMp = Array<MOBTXNSERVEYS>()
    var id:String!
    var index:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.backButton(image: "back")
        self.navigationItem.title = "My previous reports"
        arrgetMp = MOBTXNSERVEYS.mr_findAll() as! [MOBTXNSERVEYS]
        searcharrgetMp =  arrgetMp
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
        
        tblHistory.register(UINib(nibName: HistoryTableViewCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.stringRepresentation)
        tblHistory.tableFooterView = UIView(frame: CGRect.zero)
        searchLoctionTXT.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        
        
    }
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
        searcharrgetMp.removeAll()
        if textfield.text?.count != 0 {
            for acitivty in arrgetMp {
                let range = acitivty.area?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil {
                    searcharrgetMp.append(acitivty)
                }
            }
        } else {
            searcharrgetMp = arrgetMp
        }
        
        tblHistory.reloadData()
    }
    
    @objc func btnDeleteAction(sender:UIButton)  {
         let activity = searcharrgetMp[sender.tag]
        id = activity.id!
        index =  sender.tag
        deletesummaryApi(id: activity.id!)
    }
    
    func deletesummaryApi(id:String)  {
        let dictuser = self.getAllServeyTrackerUser()
        let user_id = dictuser[DictionaryKey.user_id]
        let url = "\(URLConstants.deleteactivities)?userId=\(user_id ?? "")&timestamp=\(id)"
        APIClient.init().getRequest(withURL: url) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            self.view.hideHUD()
            if JSON != nil {
                print(JSON ?? "nil")
                self.deleteDataFromDB()
                self.showAlert(title: "", message: "Delete successfully.")
            }else{
                self.showAlert(title: "Alert!", message: "Something went to wrong.Please try again.")
            }
        }
    }
    
    func deleteDataFromDB()  {
        let predicate = NSPredicate(format: "id == %@", id)
        MOBTXNSERVEYS.mr_deleteAll(matching: predicate)
        do {
            try NSManagedObjectContext.mr_default().save()
            searcharrgetMp.remove(at: index)
            tblHistory.reloadData()
        } catch  {
            print("error..")
        }
    }

}

extension HistoryViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searcharrgetMp.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.stringRepresentation) as! HistoryTableViewCell
        let activity = searcharrgetMp[indexPath.row]
        cell.lblDate.text = "\(activity.date ?? "") - \(activity.area ?? "")"
        cell.selectionStyle = .none
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteAction(sender:)), for: .touchUpInside)
        //cell.btnDelete.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Activity_SummaryVC") as! Activity_SummaryVC
        vc.activity = searcharrgetMp[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HistoryViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
