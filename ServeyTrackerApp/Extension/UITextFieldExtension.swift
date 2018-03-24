//
//  UITextFieldExtension.swift
//  ProfessionalNetworking
//
//  Created by Pawan Sharma on 12/08/16.
//  Copyright © 2016 Hiteshi Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    /// Sets placehoder text color
    ///
    /// - Parameter placeHoderTextColor: placeHoderTextColor color to set for the placehoder text.
    func setPlaceHolderTextColor(placeHoderTextColor: UIColor) {
        let mutable = NSMutableAttributedString(string: self.placeholder!)
        let range = NSRange.init(location: 0, length: (self.placeholder?.count)!)
        mutable.addAttribute(NSAttributedStringKey.foregroundColor, value: placeHoderTextColor, range: range)
        self.attributedPlaceholder = mutable
    }

    /// Adds a done button on textfield to hide the keyboard. Useful when showing number pad.
    internal func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        inputAccessoryView = keyboardToolbar
    }

    internal func addTextFieldtintcolor() {
        self.tintColor = UIColor.white
    }

    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setTextFieldBoader()  {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setRightViewImage(imageName:String)  {
        let arrow = UIImageView(image: UIImage(named: imageName))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 10.0, height: size.height)
        }
        arrow.contentMode = UIViewContentMode.center
        self.rightView = arrow
        self.rightViewMode = UITextFieldViewMode.always
    }
}
