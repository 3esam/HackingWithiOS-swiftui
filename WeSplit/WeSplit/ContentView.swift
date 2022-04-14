//
//  ContentView.swift
//  WeSplit
//
//  Created by Esam Sherif on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    @State private var name = ""
    
    let students = ["Student1", "Student2", "Student3"]
    @State private var selectedStudent = "Student1"
    
    var body: some View {
        NavigationView{
            Form {
                Section{
                    TextField("enter your name", text: $name)
                    Text("Your name is \(name)")
                }
                
                Section{
                    Button("Tap count: \(count)", action: { count += 1})
                    Picker("Select student", selection: $selectedStudent){
                        ForEach(students, id: \.self){
                            Text($0)
                        }
                    }
                }
                
                ForEach(0..<10) {
                    Text("row \($0)")
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
