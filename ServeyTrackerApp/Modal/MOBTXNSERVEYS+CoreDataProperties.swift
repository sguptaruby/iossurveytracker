//
//  MOBTXNSERVEYS+CoreDataProperties.swift
//  ServeyTrackerApp
//
//  Created by Apple on 26/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension MOBTXNSERVEYS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOBTXNSERVEYS> {
        return NSFetchRequest<MOBTXNSERVEYS>(entityName: "MOBTXNSERVEYS")
    }

    @NSManaged public var id: String?
    @NSManaged public var provinceId: String?
    @NSManaged public var districtId: String?
    @NSManaged public var dsDivisionId: String?
    @NSManaged public var incidentId: String?
    @NSManaged public var subIncidentNotes: String?
    @NSManaged public var area: String?
    @NSManaged public var date: String?
    @NSManaged public var images: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: String?
    @NSManaged public var creationDate: String?
    @NSManaged public var note: String?
    @NSManaged public var userid: String?

}
