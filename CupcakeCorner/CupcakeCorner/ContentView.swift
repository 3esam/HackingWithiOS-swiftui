//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Esam Sherif on 5/13/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var order = OrderClass()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.orderStruct.type) {
                        ForEach(OrderClass.types.indices) {
                            Text(OrderClass.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.orderStruct.quantity)", value: $order.orderStruct.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.orderStruct.specialRequestEnabled.animation())
                    
                    if order.orderStruct.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.orderStruct.extraFrosting)
                        Toggle("Add extra Sprinkles", isOn: $order.orderStruct.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery address")
                    }
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
