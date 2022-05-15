//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Esam Sherif on 5/15/22.
//

import SwiftUI

struct Student: Hashable {
    let name: String
}

struct ContentView: View {
    let students = [Student(name: "st 1"), Student(name: "st 2")]
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == %@", "Universe 4")) var ships: FetchedResults<Ship>
    
    @State private var lastNameFilter = "l"
    
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    
    var body: some View {
        List {
            ForEach(countries, id: \.self) { country in
                Section(country.fullNameWrapper) {
                    ForEach(country.candyArray, id: \.self) { candy in
                        Text(candy.nameWrapper)
                    }
                }
            }
            
            Button("Add candies") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"

                let candy2 = Candy(context: moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"

                let candy3 = Candy(context: moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"

                let candy4 = Candy(context: moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"

                try? moc.save()
            }
            
            FilteredList(
                filterKey: "firstName",
                filterPredicate: .containss,
                filterValue: lastNameFilter
//                sortDescriptors: [
//                    SortDescriptor(\.firstName)
//                ]
            )
            {
                (singer: Singer) in
                    Text("\(singer.firstNameWrapper) \(singer.lastNameWrapper)")
            }
            
            Button("Add singers") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"

                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

                try? moc.save()
            }
            
            Button("Show singer lastname starts with l") {
                lastNameFilter = "l"
            }

            Button("Show singer lastname starts with e") {
                lastNameFilter = "E"
            }
            
            ForEach(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
            
            Button("Add Ships") {
                let newShip1 = Ship(context: moc)
                newShip1.name = "Ship 1"
                newShip1.universe = "Universe 1"
            
                let newShip2 = Ship(context: moc)
                newShip2.name = "Ship 2"
                newShip2.universe = "Universe 2"
            
                let newShip3 = Ship(context: moc)
                newShip3.name = "Ship 3"
                newShip3.universe = "Universe 3"
            
                let newShip4 = Ship(context: moc)
                newShip4.name = "Ship 4"
                newShip4.universe = "Universe 4"
                
                try? moc.save()
            }
            
            Section {
                ForEach(wizards, id: \.self) { wizard in
                    Text(wizard.name ?? "Unknown")
                }
                
                Button("Add Wizard") {
                    let newWizard = Wizard(context: moc)
                    newWizard.name = "Awesome Wizard"
                }
                
                Button("Save database"){
                    do {
                        if moc.hasChanges {
                            try moc.save()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }

                ForEach(students, id: \.self) {
                    Text("\($0.name)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
