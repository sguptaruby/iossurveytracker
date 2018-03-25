//
//  ServeyTrackerManager.swift
//  ServeyTrackerApp
//
//  Created by Apple on 25/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ServeyTrackerManager: NSObject {
    
    static let share = ServeyTrackerManager()
    var verificationCode:String!
    var selectedDistrictID:String!
    var selectedDivisonID:String!
    

}

final class DictionaryKey {
    
    static let user_id = "user_id"
    static let email = "email"
    static let telephone = "telephone"
    static let fname = "fname"
    static let lname = "lname"
    
}
