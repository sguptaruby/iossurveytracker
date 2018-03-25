//
//  UIViewExtensions.swift
//  ProfessionalNetworking
//
//  Created by Pawan Sharma on 11/08/16.
//  Copyright © 2016 Hiteshi Infotech. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView {

    /// X Origin of UIView
    var xOrigin: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            frame.origin.x = newX
        }
    }

    /// Y Origin of UIView
    var yOrigin: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newY) {
            frame.origin.y = newY
        }
    }

    /// New height of the UIView
    var heightValue: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            frame.size.height = newHeight
        }
    }

    /// New Width of the UIView
    var widthValue: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            frame.size.width = newWidth
        }
    }

    ///  Make a UIView circular. Width and height of the UIView must be same otherwise resultant view will be oval not a circle.
    func makeCircular() {
        self.layer.cornerRadius = min(heightValue, widthValue) / 2.0
        self.clipsToBounds = true
    }

    /// Shows horizontal border by adding a sublayer at specified position on UIView.
    ///
    /// - Parameters:
    ///   - borderColor: Color to set for the border. If ignored White is used by default
    ///   - yPosition: Y Axis position where the border will be shown.
    ///   - borderHeight: Height of the border.
    func horizontalBorder(borderColor: UIColor = UIColor.white, yPosition: CGFloat = 0, borderHeight: CGFloat = 1.0) {
        let lowerBorder = CALayer()
        lowerBorder.backgroundColor = borderColor.cgColor
        lowerBorder.frame = CGRect(x: 0, y: yPosition, width: frame.width, height: borderHeight)
        layer.addSublayer(lowerBorder)
        clipsToBounds = true
    }

    /// Shows vertical border by adding a sublayer at specified position on UIView.
    ///
    /// - Parameters:
    ///   - borderColor: Color to set for the border. If ignored White is used by default
    ///   - xPosition: X Axis position where the border will be shown.
    ///   - borderWidth: Width of the border
    func verticalBorder(borderColor: UIColor = UIColor.white, xPosition: CGFloat = 0, borderWidth: CGFloat = 1.0) {
        let lowerBorder = CALayer()
        lowerBorder.backgroundColor = borderColor.cgColor
        lowerBorder.frame = CGRect(x: xPosition, y: 0, width: frame.width, height: borderWidth)
        layer.addSublayer(lowerBorder)
    }

    /// Shows Imaginamos progress view
    internal func showHUD() {
        MBProgressHUD.showAdded(to: self, animated: true)
    }
    
    /// Hides Imaginamos progress view
    internal func hideHUD() {
        MBProgressHUD.hide(for: self, animated: false)
    }

    /// Instantiate a view from xib.
    ///
    /// - Returns: Instantiatd view from XIB
    class func instanceFromNib() -> UIView {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }


    /// Capture screenshot of a view and return as an instance of UIImage.
    ///
    /// - Returns: screenshot of the view
    internal func captureSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

/// View with Dashed border
class UIViewWithDashedLineBorder: UIView {
    override func draw(_ rect: CGRect) {

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)

        UIColor.white.setFill()
        path.fill()

        UIColor.black.setStroke()
        path.lineWidth = 2

        let dashPattern: [CGFloat] = [10, 4]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}
