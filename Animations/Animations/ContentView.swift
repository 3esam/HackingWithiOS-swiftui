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
    
    @State private var enabled = false
    
    @State private var dragAmount = CGSize.zero
    
    let letters = Array("Hello, SwiftUI")
    @State private var enabled2 = false
    @State private var dragAmount2 = CGSize.zero
    
    @State private var isShowingRed = false
    
    @State private var isShowingRed2 = false
    
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
            
            HStack {
                Button("Tap Me") {
                    animationAmount2 += 1
                }
                .padding(20)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .scaleEffect(animationAmount2)
                
                Stepper("Scale amount", value: $animationAmount2.animation(
                    .easeInOut(duration: 1/3)
                        .repeatCount(3, autoreverses: true)
                ), in: 1...10)
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
            
            Button("Tap me") {
                enabled.toggle()
            }
            .frame(width: 100, height: 100)
            .background(enabled ? .red : .blue)
            .animation(.default, value: enabled)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 30, damping: 2), value: enabled)
            
            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 100, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged { dragAmount = $0.translation }
                        .onEnded { _ in dragAmount = .zero }
                )
                .animation(.spring(), value: dragAmount)
            
            HStack(spacing: 0) {
                ForEach(0..<letters.count) { num in
                    Text(String(letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(enabled2 ? .blue : .red)
                        .offset(dragAmount2)
                        .animation(
                            .default.delay(Double(num) / 20),
                            value: dragAmount2
                        )
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { dragAmount2 = $0.translation }
                    .onEnded { _ in dragAmount2 = .zero; enabled2.toggle() }
            )
            
            HStack {
                Button("Tap Me"){
                    withAnimation {
                        isShowingRed.toggle()
                    }
                }
                .font(.headline)
                .padding()
                if(isShowingRed) {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 100, height: 30)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
            }
            
            ZStack {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 100, height: 100)
                if isShowingRed2 {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .transition(.pivot)
                }
            }
            .onTapGesture {
                withAnimation {
                    isShowingRed2.toggle()
                }
            }
        }
        .onAppear {
            animationAmount = 2
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
