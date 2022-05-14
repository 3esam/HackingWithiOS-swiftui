//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Esam Sherif on 5/14/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: OrderClass
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmationMessage = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmationMessage) {
            Button("Ok") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order.orderStruct) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(OrderStruct.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(OrderClass.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmationMessage = true
        } catch {
            print("Checkout failed")
            confirmationMessage = "Failed to contact server, please try again later"
            showingConfirmationMessage = true
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: OrderClass())
    }
}
