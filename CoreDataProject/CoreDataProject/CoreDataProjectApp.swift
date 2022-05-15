//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Esam Sherif on 5/15/22.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
