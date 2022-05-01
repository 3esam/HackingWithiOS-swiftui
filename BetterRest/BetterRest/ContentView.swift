//
//  ContentView.swift
//  BetterRest
//
//  Created by Esam Sherif on 4/29/22.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    
    @State private var wakeUp = Date.now
    
    var body: some View {
        VStack(spacing: 10){
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            
            DatePicker("please enter a date", selection: $wakeUp, in: exampleOnlyFutreDateRange(), displayedComponents: .date)
                .labelsHidden()
            
            Text(Date.now, format: .dateTime.year().day().month())
            
            Text(Date.now.formatted(date: .long, time: .shortened))
        }
    }
    
    func exampleOnlyFutreDateRange() -> PartialRangeFrom<Date> {
        Date.now...
    }
    
    func exampleDateRange() -> ClosedRange<Date> {
        // for for real production app
        let tomorrow = Date.now.addingTimeInterval(86400)
        let range = Date.now...tomorrow
        return range
    }
    
    func exampleDate() -> Date {
        // more reliable date approach
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? Date.now
        
        return date
    }
    
    func exampleDate2() -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        
        let date = Calendar.current.date(from: components) ?? Date.now
        return date
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
