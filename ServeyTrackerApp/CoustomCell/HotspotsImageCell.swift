//
//  HotspotsImageCell.swift
//  ServeyTrackerApp
//
//  Created by Apple on 31/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HotspotsImageCell: UITableViewCell {
    
    @IBOutlet weak var imgVW:UIImageView!
    @IBOutlet weak var lblBottomtitle:UILabel!
    @IBOutlet weak var bottomVW:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomVW.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
