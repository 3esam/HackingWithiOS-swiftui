//
//  Candy+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Esam Sherif on 5/15/22.
//
//

import Foundation
import CoreData


extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?

    var nameWrapper: String{
        name ?? "Uknown"
    }
}

extension Candy : Identifiable {

}
