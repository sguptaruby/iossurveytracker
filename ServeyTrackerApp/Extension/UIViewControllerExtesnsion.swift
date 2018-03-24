//
//  UIViewControllerExtesnsion.swift
//  ProfessionalNetworking
//
//  Created by Pawan Sharma on 12/08/16.
//  Copyright © 2016 Hiteshi Infotech. All rights reserved.
//

import Foundation
import UIKit

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
