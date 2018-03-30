//
//  GetMpTags+CoreDataClass.swift
//  ServeyTrackerApp
//
//  Created by Apple on 25/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GetMpTags)
public class GetMpTags: NSManagedObject {
    
    
    class func findOrCreateByIDInContext(anID : String , localContext : NSManagedObjectContext) -> GetMpTags {
        
        if let objUser : GetMpTags = GetMpTags.mr_findFirst(byAttribute: "id", withValue: anID, in: localContext) {
            return objUser
        }else{
            let objUser : GetMpTags = GetMpTags.mr_createEntity(in: localContext)!
            return objUser
        }
    }
    
    
    class func entityFromArrayInContext(aArray : NSArray , localContext : NSManagedObjectContext){
        for aDictionary in aArray {
            GetMpTags.entityFromDictionaryInContext(aDictionary: aDictionary as! NSDictionary, localContext: localContext)
        }
    }
    
    class func entityFromDictionaryInContext(aDictionary : NSDictionary, localContext : NSManagedObjectContext){
        
        if let user_id : Int = aDictionary["Id"] as? Int {
            let id = "\(user_id)"
            let objUser : GetMpTags = GetMpTags.findOrCreateByIDInContext( anID: id , localContext: localContext)
            objUser.id = user_id
            
            if let type : Int = aDictionary["Type"] as? Int {
                let typ = "\(type)"
                objUser.type = typ
            }
            
            if let parentId : Int = aDictionary["ParentId"] as? Int {
                let pentId = "\(parentId)"
                objUser.parentId = parentId
            }
            
            if let name : String = aDictionary["Name"] as? String {
                objUser.name = name
            }
            
        }
        
    }

}
