//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Esam Sherif on 5/15/22.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16

    public var titleWrapper: String{
        title ?? "Uknown"
    }
}

extension Movie : Identifiable {

}
