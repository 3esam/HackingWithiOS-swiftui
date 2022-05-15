//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Esam Sherif on 5/15/22.
//

import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    
    let content: (T) -> Content
    
    var body: some View {
        ForEach(fetchRequest, id: \.self, content: content)
    }
    
    init(filterKey: String, filterPredicate: FilterPredicate, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "%K \(filterPredicate.rawValue) %@", filterKey, filterValue)
        )
        
        self.content = content
    }
    
    enum FilterPredicate: String {
        case beginsWith = "BEGINSWITH"
        case containss = "CONTAINS[c]"
    }
}
