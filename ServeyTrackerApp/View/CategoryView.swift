//
//  CategoryView.swift
//  ServeyTrackerApp
//
//  Created by Apple on 25/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
protocol CategoryViewDelegate {
    func didSelectedData(data:Any,type:String)
    func didCancel()
}

class CategoryView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var lbltilte:UILabel!
    var arrCategoryData:[Any] = []
    var delegate:CategoryViewDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblCategory.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblCategory.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func btnBackaction(sender:UIButton) {
        delegate.didCancel()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        let tagsObj = arrCategoryData[indexPath.row] as! GetMpTags
        cell.textLabel?.text = tagsObj.name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectedData(data: arrCategoryData[indexPath.row], type: lbltilte.text!)
    }

}
