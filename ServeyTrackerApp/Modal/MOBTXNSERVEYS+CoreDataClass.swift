//
//  MOBTXNSERVEYS+CoreDataClass.swift
//  ServeyTrackerApp
//
//  Created by Apple on 26/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MOBTXNSERVEYS)
public class MOBTXNSERVEYS: NSManagedObject {
    
    class func findOrCreateByIDInContext(anID : String , localContext : NSManagedObjectContext) -> MOBTXNSERVEYS {
        
        if let objUser : MOBTXNSERVEYS = MOBTXNSERVEYS.mr_findFirst(byAttribute: "id", withValue: anID, in: localContext) {
            return objUser
        }else{
            let objUser : MOBTXNSERVEYS = MOBTXNSERVEYS.mr_createEntity(in: localContext)!
            return objUser
        }
    }
    
    
    class func entityFromArrayInContext(aArray : NSArray , localContext : NSManagedObjectContext){
        for aDictionary in aArray {
            MOBTXNSERVEYS.entityFromDictionaryInContext(aDictionary: aDictionary as! NSDictionary, localContext: localContext)
        }
    }
    
    class func entityFromDictionaryInContext(aDictionary : NSDictionary, localContext : NSManagedObjectContext){
        
        if let id : String = aDictionary[DictionaryKey.id] as? String {
            let mobServey : MOBTXNSERVEYS = MOBTXNSERVEYS.findOrCreateByIDInContext( anID: id , localContext: localContext)
            mobServey.id = id
            
            if let user_id : String = aDictionary[DictionaryKey.user_id] as? String {
                mobServey.userid = user_id
            }
            
            if let createdate : String = aDictionary[DictionaryKey.creationDate] as? String {
                mobServey.creationDate = createdate
            }
            
            if let address : String = aDictionary[DictionaryKey.address] as? String {
                mobServey.address = address
            }
            
            if let area : String = aDictionary[DictionaryKey.area] as? String {
                mobServey.area = area
            }
            
            if let date : String = aDictionary[DictionaryKey.date] as? String {
                mobServey.date = date
            }
            
            if let districtId : String = aDictionary[DictionaryKey.districtId] as? String {
                mobServey.districtId = districtId
            }
            
            if let dsDivisionId : String = aDictionary[DictionaryKey.dsDivisionId] as? String {
                mobServey.dsDivisionId = dsDivisionId
            }
            
            if let images : String = aDictionary[DictionaryKey.activityImage] as? String {
                mobServey.images = images
            }
            
            if let incidentId : String = aDictionary[DictionaryKey.incidentId] as? String {
                mobServey.incidentId = incidentId
            }
            
            if let latitude : Double = aDictionary[DictionaryKey.latitude] as? Double {
                mobServey.latitude = latitude
            }
            
            if let longitude : Double = aDictionary[DictionaryKey.longitude] as? Double {
                mobServey.longitude = longitude
            }
            
            if let note : String = aDictionary[DictionaryKey.note] as? String {
                mobServey.note = note
            }
            
            if let provinceId : String = aDictionary[DictionaryKey.provinceId] as? String {
                mobServey.provinceId = provinceId
            }
            
            if let subIncidentNotes : String = aDictionary[DictionaryKey.subIncidentNotes] as? String {
                mobServey.subIncidentNotes = subIncidentNotes
            }
        }
        
    }

}
