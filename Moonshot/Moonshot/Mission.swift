//
//  Mission.swift
//  Moonshot
//
//  Created by Esam Sherif on 5/9/22.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedShortLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    var formattedLongLaunchDate: String {
        launchDate?.formatted(date: .complete, time: .omitted) ?? "N/A"
    }
}
