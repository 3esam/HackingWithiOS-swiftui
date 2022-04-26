//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Esam Sherif on 4/23/22.
//

import SwiftUI

struct ContentView: View {
    @State private var useRedText = true
    
    // Views as properties
    let myTextView1 = Text("My Text View1")
    let myTextView2 = Text("My Text View2")
    
    // Views as computed properties
    // @ViewBuilder to make it agnostic layout
    // or you can use "Group {}" for agnostic layout
    @ViewBuilder var listOfText: some View {
        Text("list item 1")
        Text("list item 2")
    }
    
    // custom container
    struct GridStack<Content: View>: View {
        let rows: Int
        let columns: Int
        @ViewBuilder let content: (Int, Int) -> Content
        
        var body: some View {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20){
            // conditional modifier
            Button("Hello, world"){
                useRedText.toggle()
            }.foregroundColor(useRedText ? .red : .blue)
            
            VStack {
                myTextView1
                    .foregroundColor(.green)
                myTextView2
            }
            
            HStack{
                listOfText
            }
            
            VStack{
                listOfText
            }
            
            // custom modifier
            Text("custom modifier 1")
                .modifier(Title())
            Text("custom modifier 2")
                .titleStyle()
            
            // custom modifier waterMark
            Color.mint
                .frame(width: 250, height: 100)
                .waterMarked(with: "iOS 15")
            
            // using custom container
            GridStack(rows: 3, columns: 4) { row, column in
                Image(systemName: "\(row * 4 + column).circle")
                Text("R\(row)*C\(column)")
            }
            
            Text("Prominent")
                .prominent()
        }
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    func waterMarked(with text:String) -> some View {
        modifier(WaterMark(text: text))
    }
    func prominent() -> some View {
        modifier(ProminentTitle())
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct WaterMark: ViewModifier{
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(.black )
        }
    }
}

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
            .padding(5)
            .background(.yellow)
            .padding()
            .background(.blue)
            .clipShape(Ellipse())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
