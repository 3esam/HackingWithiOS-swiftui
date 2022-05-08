//
//  ContentView.swift
//  iExpense
//
//  Created by Esam Sherif on 5/6/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.personalItems) { item in
                    listItem(item: item)
                }
                .onDelete(perform: removePersonalItems(at:))
                ForEach(expenses.businessItems) { item in
                    listItem(item: item)
                }
                .onDelete(perform: removeBusinessItems(at:))
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removePersonalItems(at offsets: IndexSet){
        for offset in offsets {
            if let index = expenses.items.firstIndex(where: { $0.id == expenses.personalItems[offset].id}) {
                expenses.items.remove(at: index)
            }
        }
    }
    
    func removeBusinessItems(at offsets: IndexSet){
        for offset in offsets {
            if let index = expenses.items.firstIndex(where: { $0.id == expenses.businessItems[offset].id}) {
                expenses.items.remove(at: index)
            }
        }
    }
}

struct listItem: View {
    let item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack {
                Text(item.name)
                Text(item.type)
            }
            Spacer()
            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                .foregroundColor(colorFromAmount(item.amount))
        }
    }
    
    func colorFromAmount(_ amount: Double) -> Color {
        switch amount {
        case ...10:
            return Color.green
        case 10...100:
            return Color.yellow
        case 100...:
            return Color.red
        default:
            return Color.blue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
