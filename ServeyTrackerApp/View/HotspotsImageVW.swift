//
//  HotspotsImageVW.swift
//  ServeyTrackerApp
//
//  Created by Apple on 31/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HotspotsImageVW: UIView,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tblImage:UITableView!
    var activity:MOBTXNSERVEYS!
    var arrgetMp = Array<String>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblImage.register(UINib(nibName: HotspotsImageCell.stringRepresentation, bundle: nil), forCellReuseIdentifier: HotspotsImageCell.stringRepresentation)
        tblImage.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func setActivityData(activity:MOBTXNSERVEYS)  {
        let arrIncedent = activity.images?.components(separatedBy: ",")
        for nameImg in arrIncedent! {
            arrgetMp.append(nameImg)
        }
        tblImage.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrgetMp.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotspotsImageCell.stringRepresentation) as! HotspotsImageCell
        let imgpath = self.getImage(imgName: arrgetMp[indexPath.row])
        cell.imgVW.image = UIImage(contentsOfFile: imgpath!)
        cell.lblBottomtitle.text = "Capture \(indexPath.row)"
        return cell
    }
    
    func getImage(imgName:String)-> String? {
        let fileManager = FileManager.default
        //let name = "\(imgName).jpg"
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(imgName)
        if fileManager.fileExists(atPath: imagePAth){
            return imagePAth
            //self.imagePicker.image = UIImage(contentsOfFile: imagePAth)
        }else{
            return ""
            //print("No Image")
        }
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}
