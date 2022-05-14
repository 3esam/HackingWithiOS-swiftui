//
//  ContentView.swift
//  Bookworm
//
//  Created by Esam Sherif on 5/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var rememberMe = false
    
    @AppStorage("notes") private var notes = ""
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
    
    var body: some View {
        VStack {
            PushButton(title: "Remember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
            
            TextEditor(text: $notes)
                .padding()
                .border(.secondary, width: 5)
            
            List(students) { student in
                Text(student.name ?? "Unknown")
            }
            
            Button("Add") {
                let firstNames = ["name1", "name2", "name3", "name4", "name5"]
                let lastNames = ["last1", "last2", "last3", "last4", "last5"]
                
                let chosenFirstName = firstNames.randomElement()!
                let chosesLastName = lastNames.randomElement()!
                
                let student = Student(context: moc)
                student.id = UUID()
                student.name = "\(chosenFirstName) \(chosesLastName)"
                
                try? moc.save()
            }
        }
    }
}

struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
    
    var onColors = [Color.yellow, Color.red]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(
            LinearGradient(colors: isOn ? onColors : offColors, startPoint: .top, endPoint: .bottom)
        )
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
