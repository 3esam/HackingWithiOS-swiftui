//
//  ContentView.swift
//  Moonshot
//
//  Created by Esam Sherif on 5/9/22.
//

import SwiftUI

struct CustomText: View {
    let text: String
    
    var body: some View {
        Text(text)
    }
    
    init(_ text: String) {
        print("Creating a new CustomText: \(text)")
        self.text = text
    }
}

struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}

struct ContentView: View {
    
    let layout = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geo in
                    Image("test")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.8)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                
                List(0..<2){ row in
                    NavigationLink {
                        Text("Detail view \(row)")
                    } label: {
                        Text("Item View \(row)")
                    }
                }
                
                Button("Decode JSON") {
                    let input = """
                    {
                        "name": "Taylor Swift",
                        "address": {
                            "street": "555, Taylor Swift Avenue",
                            "city": "Nashville"
                        }
                    }
                    """

                    let data = Data(input.utf8)
                    if let user = try? JSONDecoder().decode(User.self, from: data) {
                        print(user.address.street)
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: layout) {
                        ForEach(0..<100) {
                            Text("item \($0)")
                        }
                    }
                }
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(0..<100) {
                            CustomText("item \($0)")
                                .font(.title)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("swiftui")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
