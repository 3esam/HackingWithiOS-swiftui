//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Esam Sherif on 5/8/22.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
