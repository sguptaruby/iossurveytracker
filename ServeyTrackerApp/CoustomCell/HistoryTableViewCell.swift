//
//  HistoryTableViewCell.swift
//  ServeyTrackerApp
//
//  Created by Apple on 30/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var contentVW:UIView!
    @IBOutlet weak var lblArea:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentVW.layer.cornerRadius = 10
        contentVW.layer.borderWidth = 1
        contentVW.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
