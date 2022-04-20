//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Esam Sherif on 4/20/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 20){
            VStack{
                ForEach(0..<3){ row in
                    HStack{
                        ForEach(0..<3){ column in
                            Text("\(row+1) * \(column+1)")
                        }
                    }
                }
            }
            
            ZStack{
                Color.red
                    .frame(width: 40, height: 40)
                Text("your content")
            }
            
            HStack{
                LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .blue, location: 0.45),
                    .init(color: .black, location: 0.60)
                ]), startPoint: .top, endPoint: .bottom)
            }
            
            HStack{
                RadialGradient(gradient: Gradient(colors: [.yellow, .green]), center: .center, startRadius: 10, endRadius: 100)
                AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
            }
            
            ZStack{
                VStack(spacing: 0){
                    Color.orange
                    Color.indigo
                }
                Text("Translucent")
//                    .foregroundColor(.secondary)
                    .foregroundStyle(.secondary)
                    .padding()
                    .background(.ultraThinMaterial)
            }
            
            HStack{
                Button("B1", role: .destructive) {}
                    .buttonStyle(.bordered)
                Button("Alert", action: executeDelete)
                    .buttonStyle(.bordered)
                    .tint(.mint)
                Button("B3", role: .destructive) {}
                    .buttonStyle(.borderedProminent)
                Button("B4", action: executeDelete)
                    .buttonStyle(.borderedProminent)
                
                
                Button{
                    print("B6")
                } label: {
                    Image(systemName: "person")
                        .renderingMode(.original) // this works on images only.
                }
                
                Button{
                    print("B5")
                } label: {
                    Text("B5")
                        .padding(5)
                        .foregroundColor(.primary)
                        .background(.secondary)
                }
                
                Button{
                    print("B6")
                } label: {
                    Label("edit", systemImage: "pencil")
                }
            }
            
            HStack{
            }
            
            ZStack{
                Color.blue
                Text("Ignore safe area")
            }
            .ignoresSafeArea()
        }
        .alert("An alert", isPresented: $showingAlert){
            Button("Delete", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        }message: {
            Text("Please read this")
        }
    }
    
    func executeDelete() {
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
