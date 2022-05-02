//
//  ContentView.swift
//  Animations
//
//  Created by Esam Sherif on 5/2/22.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 1.0
    
    @State private var animationAmount2 = 1.0
    
    @State private var animationAmount3 = 0.0
    
    var body: some View {
        VStack {
            Button("Tap Me") {
//                animationAmount += 1
            }
            .padding(20)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.blue)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
            )
            
            VStack {
                Stepper("Scale amount", value: $animationAmount2.animation(
                    .easeInOut(duration: 1/3)
                        .repeatCount(3, autoreverses: true)
                ), in: 1...10)
                Button("Tap Me") {
                    animationAmount2 += 1
                }
                .padding(20)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(animationAmount2)
            }
            
            
            Button("Tap Me") {
                withAnimation(.interpolatingSpring(stiffness: 60, damping: 5)){
                    animationAmount3 += 360
                }
            }
            .padding(20)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .rotation3DEffect(.degrees(animationAmount3), axis: (x: 0, y: 0, z: 1))
        }
        .onAppear {
            animationAmount = 2
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
