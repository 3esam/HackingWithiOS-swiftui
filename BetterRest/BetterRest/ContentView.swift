//
//  ContentView.swift
//  BetterRest
//
//  Created by Esam Sherif on 4/29/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var bedTime = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                }
                
                Section{
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section{
                    Picker(cupsTextFromNumber(coffeeAmount), selection: $coffeeAmount) {
                        ForEach(0..<21, id:\.self) {
                            Text(cupsTextFromNumber($0))
                        }
                    }
//                    Stepper(cupsTextFromNumber(coffeeAmount), value: $coffeeAmount, in: 1...20)
                } header: {
                    Text("Daily cofee intake")
                }
                
                Section {
                    Text(calculateBedTime())
                } header: {
                    Text("Your ideal bedtime is...")
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func cupsTextFromNumber(_ numberOfCups: Int) -> String {
        numberOfCups == 1 ? "1 cup" : "\(numberOfCups) cups"
    }
    
    func calculateBedTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Error"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
