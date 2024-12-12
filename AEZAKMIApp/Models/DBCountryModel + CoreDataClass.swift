//
//  DBCountryModel + CoreDataClass.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 11.12.2024.
//
//

import Foundation
import CoreData

@objc(DBCountryModel)
public class DBCountryModel: NSManagedObject {

}

extension DBCountryModel: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBCountryModel> {
        return NSFetchRequest<DBCountryModel>(entityName: "DBCountryModel")
    }

    @NSManaged public var flag: String
    @NSManaged public var continents: String
    @NSManaged public var languages: String
    @NSManaged public var officialName: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var area: Double
    @NSManaged public var population: Int64
    @NSManaged public var timezones: String
    @NSManaged public var flagsUrlString: String
    @NSManaged public var capital: String
    @NSManaged public var currencies: String

}
