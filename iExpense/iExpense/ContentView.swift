//
//  ContentView.swift
//  iExpense
//
//  Created by Esam Sherif on 5/6/22.
//

import SwiftUI

class User: ObservableObject {
    @Published var firstName = "Esam"
    @Published var lastName = "Sherif"
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    
    let name: String
    
    var body: some View {
        VStack {
            Text("Hello \(name)")
            
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}

struct Person: Codable {
    let first: String
    let last: String
}

struct ContentView: View {
    @StateObject var user = User()
    
    @State private var showingSheet = false
    
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    @AppStorage("tapcount") private var tapCount2 = 0
    
    @State private var person = Person(first: "Taylor", last: "Swift")
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Your name is \(user.firstName) \(user.lastName)")
                
                TextField("FirstName", text: $user.firstName)
                TextField("LastName", text: $user.lastName)
                
                Button("Show Sheet") {
                    showingSheet.toggle()
                }
                
                HStack {
                    Button("Tap count : \(tapCount)") {
                        tapCount += 1
                        UserDefaults.standard.set(tapCount, forKey: "Tap")
                    }
                    Button("Tap count2 : \(tapCount2)") {
                        tapCount2 += 1
                    }
                }
                
                Button("Save Person") {
                    let encoder = JSONEncoder()
                    
                    if let data = try? encoder.encode(person) {
                        UserDefaults.standard.set(data, forKey: "UserData")
                    }
                }
                
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: removeRows)
                }
                
                Button("Add Number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
            .sheet(isPresented: $showingSheet) {
                SecondView(name: user.firstName)
            }
            .navigationTitle("onDelete()")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
