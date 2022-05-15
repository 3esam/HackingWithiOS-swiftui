//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Esam Sherif on 5/15/22.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

    var firstNameWrapper: String{
        firstName ?? "Uknown"
    }
    
    var lastNameWrapper: String{
        lastName ?? "Uknown"
    }
}

extension Singer : Identifiable {

}
