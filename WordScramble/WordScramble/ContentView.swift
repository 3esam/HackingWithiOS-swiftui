//
//  ContentView.swift
//  WordScramble
//
//  Created by Esam Sherif on 5/1/22.
//

import SwiftUI

struct ContentView: View {
    let people = ["lia", "pia", "mike"]
    var body: some View {
        List {
            Text("Static row 1")
            ForEach(people, id: \.self) {
                Text($0)
            }
        }
        .listStyle(.grouped)
    }
    
    func loadFile() {
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileURL) {
                // use file contents
                fileContents
            }
        }
    }
    
    func stringComponents() {
        let input = "a b c"
        let letters = input.components(separatedBy: " ")
        let letter = letters.randomElement()
        
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func wordChecker() {
        let word = "swift"
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        let allGood = misspelledRange.location == NSNotFound
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
