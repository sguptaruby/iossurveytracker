//
//  GetMpTags+CoreDataProperties.swift
//  ServeyTrackerApp
//
//  Created by Apple on 25/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension GetMpTags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GetMpTags> {
        return NSFetchRequest<GetMpTags>(entityName: "GetMpTags")
    }

    @NSManaged public var id: Int
    @NSManaged public var type: String
    @NSManaged public var parentId: Int
    @NSManaged public var name: String?

}
