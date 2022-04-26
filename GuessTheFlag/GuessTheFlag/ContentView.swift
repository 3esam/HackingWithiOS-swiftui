//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Esam Sherif on 4/20/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var numberOfAskedQuestions = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    var body: some View {
        ZStack{
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .ignoresSafeArea()
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.2), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
            
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        }label: {
                            FlagImage(countryImageName: countries[number], clipShape: Capsule(), shadowRadius: 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore ){
            Button("Continue", action: askQuestion)
        }message: {
            Text(scoreMessage)
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "your score is \(score)"
        }else{
            scoreTitle = "Wrong"
            scoreMessage = "Tapped flag is \(countries[number])"
        }
        numberOfAskedQuestions += 1
        if (numberOfAskedQuestions >= 8){
            scoreMessage += ", you got \(score) out of 8 questions."
            score = 0
            numberOfAskedQuestions = 0
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage<S>: View where S:Shape{
    let countryImageName: String
    let clipShape: S
    let shadowRadius: CGFloat
    
    var body: some View {
        Image(countryImageName)
            .renderingMode(.original)
            .clipShape(clipShape)
            .shadow(radius: shadowRadius)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
