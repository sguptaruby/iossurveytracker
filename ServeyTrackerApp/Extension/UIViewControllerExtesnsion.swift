//
//  UIViewControllerExtesnsion.swift
//  ProfessionalNetworking
//
//  Created by Pawan Sharma on 12/08/16.
//  Copyright © 2016 Hiteshi Infotech. All rights reserved.
//

import Foundation
import UIKit
import MagicalRecord

extension UIViewController {
    
    /// Creates instance of the controller from XIB file
    ///
    /// - Returns: UIViewController instance from XIB file
    internal class func instantiateFromXIB<T: UIViewController>() -> T {
        let xibName = T.stringRepresentation
        let vc = T(nibName: xibName, bundle: nil)
        return vc
    }
    
    /// Creates instance of the controller from XIB file. if No name is supplied for storyboard "Main" is assumed.
    ///
    /// - Parameter storyboardName: Name of the storyboard.
    /// - Returns: UIViewController instance from Storybaord
    internal class func instantiateFromStoryboard<T: UIViewController>(storyboardName: String = "Main") -> T {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifier: String = T.stringRepresentation
        
        guard let vc: T = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Please check the storybaord identifier for the class. It must be same as class name")
        }
        
        return vc
    }
    
    /// Hide navigation bar
    internal func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// Show navigation bar
    internal func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// Asks user to share the location
    internal func showAlertToAskUserToShareLocation() {
        showAlert(title: "Share Location", message: "Please allow access to your location to get the schools in your city")
    }
    
    internal func showOutOfStockAlert() {
        showAlert(title: "Not available", message: "Item is out of stock")
    }
    
    /// Shows an alert to user with a single button to dismiss the alert.
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - messageToShow: Message to show in the alert
    ///   - buttonTitle: Button title to use. If not given "Ok" is assumed.
    internal func showAlert(title: String?, message messageToShow: String?, buttonTitle: String = "Ok") {
        let alert = UIAlertController(title: title, message: messageToShow, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Creates custom back butotn on ViewController. Hides default back button and createa a UIBarButtonItem instance on controller and sets to leftBartButtonItem property.
    ///
    /// - Parameter imageName: Name of the image to show. if nil is supplied "picture_done" is assumed, specific to Imaginamos
    internal func backButton(image imageName: String?) {
        let menuImg = UIImage(named: imageName ?? "picture_done")
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigateToBackScreen))
    }
    
    //    Get height of the text
    func heightForView(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1000))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    /// Go back to previsous screen. If pushed if pops else dismisses.
    @objc internal func navigateToBackScreen() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    /// Checks if controller was pushed or presented
    /// Inspired by this answer
    /// http://stackoverflow.com/a/27301207/1568609
    var isModal: Bool {
        if presentingViewController != nil {
            return true
        }
        
        if presentingViewController?.presentedViewController == self {
            return true
        }
        
        if navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    func naviagtetToHomeScreen() {
        let arrController = self.navigationController?.viewControllers
        for vc in arrController! {
            if vc is MenuViewController {
                self.navigationController?.popToViewController(vc, animated: false)
            }
        }
        
    }
    
    ///  Open device dial view
    internal func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    func getAllServeyTrackerUser() -> JSONDictionary {
        let result = UserDefaults.standard.value(forKey: "userdict") as! JSONDictionary
        print(result.count)
        return result
    }
    func saveUser(dict:JSONDictionary)  {
        UserDefaults.standard.set(dict, forKey: "userdict")
        UserDefaults.standard.synchronize()
    }
    
    func getMpTagsApiCall() {
        self.view.showHUD()
        APIClient.init().getRequest(withURL: URLConstants.getMpTags) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            self.view.hideHUD()
            if let json = JSON as? [JSONDictionary] {
               // print(json)
                MagicalRecord.save({ (context : NSManagedObjectContext!) in
                    GetMpTags.entityFromArrayInContext(aArray: json as NSArray, localContext: context)
                    NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                }, completion: { (status, error) in
                    if status {
                        print("Data Save......")
//                        let arrgetMp = GetMpTags.mr_findAll() as! [GetMpTags]
//                        print(arrgetMp.first?.name)
                    }else{
                       print(error.debugDescription)
                    }
                })
            }
        }
    }
    
    func getAllActivity()  {
        let arrgetMp = MOBTXNSERVEYS.mr_findAll() as! [MOBTXNSERVEYS]
        print(arrgetMp.first?.id ?? "")
        for activity in arrgetMp {
            ServeyTrackerManager.share.dictactivity["IncidentId"] = activity.incidentId
            ServeyTrackerManager.share.dictactivity["Notes"] = activity.note
            ServeyTrackerManager.share.dictactivity["creationDate"] = activity.creationDate
            ServeyTrackerManager.share.dictactivity["Latitude"] = "\(activity.latitude)"
            ServeyTrackerManager.share.dictactivity["Longitude"] = "\(activity.longitude)"
            
            ServeyTrackerManager.share.dictactivity["DistrictId"] = activity.districtId
            ServeyTrackerManager.share.dictactivity["ProvinceId"] = activity.provinceId
            ServeyTrackerManager.share.dictactivity["UserId"] = activity.userid
            ServeyTrackerManager.share.dictactivity["SubIncidentNotes"] = activity.subIncidentNotes
            ServeyTrackerManager.share.dictactivity["DSDivisionId"] = activity.dsDivisionId
            ServeyTrackerManager.share.dictactivity["City"] = activity.address
            let arrImages = activity.images?.components(separatedBy: ",")
            let dict = ["fileNameList":arrImages]
            ServeyTrackerManager.share.dictactivity["activityImage"] = dict
            let incident = activity.subIncidentNotes?.components(separatedBy: ",")
            let dictIncident = ["incidentIdList":incident]
            ServeyTrackerManager.share.dictactivity["activityIncident"] = dictIncident
            ServeyTrackerManager.share.activityParams.append(ServeyTrackerManager.share.dictactivity)
        }
    }
    
    func updateActivityApiCall(params:JSONDictionary)  {
        self.view.showHUD()
        APIClient.init().postRequest(withParams: params, url: URLConstants.Update) { (JSON:Any?, RESPONSE:URLResponse?, error:Error?) in
            self.view.hideHUD()
            if JSON != nil {
                print(JSON ?? "nil")
                 self.showAlert(title: "", message: "Data sync successfully.")
            }else{
                self.showAlert(title: "Alert!", message: "Something went to wrong.Please try again.")
            }
        }
    }
    
    func getnpTagsProvisionData(id:String) -> [GetMpTags] {
        let resultPredicate = NSPredicate(format: "type contains[c] %@", id)
        let arrgetMp = GetMpTags.mr_findAll(with: resultPredicate) as! [GetMpTags]
        return arrgetMp
    }
    
    func getnpTagsDistrictData(id:String) -> [GetMpTags] {
        let resultPredicate = NSPredicate(format: "parentId contains[c] %@", id)
        let arrgetMp = GetMpTags.mr_findAll(with: resultPredicate) as! [GetMpTags]
        return arrgetMp
    }
    
    func getnpTagsDivisonData(id:String) -> [GetMpTags] {
        let resultPredicate = NSPredicate(format: "parentId contains[c] %@", id)
        let arrgetMp = GetMpTags.mr_findAll(with: resultPredicate) as! [GetMpTags]
        return arrgetMp
    }
    
    func getnpTagsIncidentData(id:String) -> [GetMpTags] {
        let resultPredicate = NSPredicate(format: "type contains[c] %@", id)
        let arrgetMp = GetMpTags.mr_findAll(with: resultPredicate) as! [GetMpTags]
        return arrgetMp
    }
    
    func getnpTagsIncidentSubData(id:String) -> [GetMpTags] {
        let resultPredicate = NSPredicate(format: "parentId contains[c] %@", id)
        let arrgetMp = GetMpTags.mr_findAll(with: resultPredicate) as! [GetMpTags]
        return arrgetMp
    }
    
    
    func saveImageDocumentDirectory(image:UIImage,imgName:String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgName)
        //let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
    
    func removeImageFromDocumentDir(itemName:String) {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName)"
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }}
    
    /// Stop listening to all notifications.
    internal func muteAllNotiications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Set status bar background color
    
    @objc func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
}

extension UIButton {
    func underline() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
    attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
