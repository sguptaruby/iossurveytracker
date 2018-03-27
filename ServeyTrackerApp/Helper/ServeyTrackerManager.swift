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
    var arrImages:[String] = []
    
    var paramsTnxService = ["id":"","address":"","area":"","creationDate":"","date":"","districtId":"","dsDivisionId":"","images":"","incidentId":"","latitude":0.0,"longitude":0.0,"note":"","provinceId":"","subIncidentNotes":"","user_id":""] as JSONDictionary
    var activityParams = Array<JSONDictionary>()
    var activityImage = ["fileNameList":[""]]
    var activityIncident = ["incidentIdList":[""]]
    
    var dictactivity = ["IncidentId":"","Notes":"","creationDate":"","activityImage":JSONDictionary(),"activityIncident":JSONDictionary(),"Latitude":"","Longitude":"","DistrictId":"","ProvinceId":"","UserId":"","SubIncidentNotes":"","DSDivisionId":"","City":""] as [String : Any]
    

}

final class DictionaryKey {
    
    static let user_id = "user_id"
    static let email = "email"
    static let telephone = "telephone"
    static let fname = "fname"
    static let lname = "lname"
    
    static let id = "id"
    static let address = "address"
    static let area = "area"
    static let creationDate = "creationDate"
    static let date = "date"
    static let districtId = "districtId"
    static let dsDivisionId = "dsDivisionId"
    static let images = "images"
    static let incidentId = "incidentId"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let note = "note"
    static let provinceId = "provinceId"
    static let subIncidentNotes = "subIncidentNotes"
}
