//
//  ImageCollectionViewCell.swift
//  ServeyTrackerApp
//
//  Created by Apple on 26/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var btnDelete:UIButton!
    @IBOutlet weak var vwBlack:UIView!
    @IBOutlet weak var lblName:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
