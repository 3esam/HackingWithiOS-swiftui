//
//  ContentView.swift
//  Drawing
//
//  Created by Esam Sherif on 5/10/22.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}

struct Arc: InsettableShape {
    let startAngle: Angle
    var endAngle: Angle
    let clockwise: Bool
    var insetAmount = 0.0
    
    var animatableData: Double {
        get { endAngle.degrees }
        set { endAngle = .degrees(newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct Flower: Shape {
    var petalOffset = -20.0
    var petalWidth = 100.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
        }
        
        return path
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(gradient: Gradient(colors: [
                            color(for: value, brightness: 1),
                            color(for: value, brightness: 0.5)
                        ]), startPoint: .top, endPoint: .bottom)
                        , lineWidth: 2)
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView: View {
    @State private var arcEndAngleDegrees: Double = 360
    
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    @State private var colorCycle = 0.0
    
    @State private var amount = 0.0
    
    @State private var insetAmount = 0.0
    
    @State private var rows = 4
    @State private var columns = 4
    
    @State private var arrowWidth = 0.2
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Path { path in
                        path.move(to: CGPoint(x:50, y:10))
                        path.addLine(to: CGPoint(x: 10, y:90))
                        path.addLine(to: CGPoint(x: 90, y:90))
                        path.addLine(to: CGPoint(x: 50, y:10))
            //            path.closeSubpath()
                    }
                    .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .frame(width: 100, height: 100)
                    
                    Triangle()
                        .stroke(.red, lineWidth: 10)
                        .frame(width: 100, height: 100)
                    
                    Arc(startAngle: .degrees(0), endAngle: .degrees(arcEndAngleDegrees), clockwise: true)
                        .strokeBorder(.blue, lineWidth: 10)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            withAnimation {
                                arcEndAngleDegrees = Double.random(in: 0...360)
                            }
                        }
                }
                
                Stepper("Arc end angle: \(arcEndAngleDegrees.formatted())", value: $arcEndAngleDegrees.animation(.easeIn), in: 0...360, step: 40)
                
                HStack {
                    Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                        .stroke(.red, lineWidth: 1)
                        .frame(width: 100, height: 100)
                    
                    VStack {
                        Text("Offse")
                        Slider(value: $petalOffset, in: -40...40)
                            .padding([.horizontal, .bottom])
                        
                        Text("Width")
                        Slider(value: $petalWidth, in: 0...100)
                            .padding(.horizontal)
                    }
                }
                
                HStack {
                    Text("Border")
                        .frame(width: 100, height: 100)
                        .border(ImagePaint(image: Image("singapore"), scale: 0.2), width: 10)
                 
                    ColorCyclingCircle(amount: colorCycle)
                        .frame(width: 100, height: 100)
                    
                    
                    ZStack {
                        Image("singapore")
                            .resizable()
                            .colorMultiply(.blue)
                            
                    }
                    .frame(width: 100, height: 100)
                }
                
                Slider(value: $colorCycle)
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(red: 1, green: 0, blue: 0))
                            .frame(width: 200 * amount)
                            .offset(x: -30, y: -20)
                            .blendMode(.screen)
                        
                        Circle()
                            .fill(Color(red: 0, green: 1, blue: 0))
                            .frame(width: 200 * amount)
                            .offset(x: 30, y: -20)
                            .blendMode(.screen)
                    
                        Circle()
                            .fill(Color(red: 0, green: 0, blue: 1))
                            .frame(width: 200 * amount)
                            .offset(y: 20)
                            .blendMode(.screen)
                    }
                    .frame(width: 100, height: 100)
                    .background(.black)
                    
                    Image("singapore")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .saturation(amount)
                        .blur(radius: (1 - amount) * 20)

                    Trapezoid(insetAmount: insetAmount)
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    withAnimation {
                                        insetAmount = Double.random(in: 10...90)
                                    }
                                }
                }
                
                Slider(value: $amount)
                    .padding()
                
                HStack {
                    Checkerboard(rows: rows, columns: columns)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            withAnimation(.linear(duration: 3)) {
                                rows = 8
                                columns = 16
                            }
                        }
                    
                    NavigationLink {
                        SpirographView()
                    } label: {
                        Text("Spirograph")
                            .font(.headline)
                    }
                    
                    Arrow(arrowWidth: arrowWidth)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            withAnimation {
                                arrowWidth = Double.random(in: 0.1...1)
                            }
                        }
                }
            }
            .navigationBarTitle("Drawing", displayMode: .inline)
        }
    }
}

struct Trapezoid: Shape {
    var insetAmount: Double
    
    var animatableData: Double {
        get { insetAmount }
        set { insetAmount = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
   }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // figure out how big each row/column needs to be
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)

        // loop over all rows and columns, making alternating squares colored
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b

        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }

        return a
    }
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = Double(self.outerRadius)
        let innerRadius = Double(self.innerRadius)
        let distance = Double(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount

        var path = Path()

        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

struct SpirographView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        VStack(spacing: 0) {
                    Spacer()

                    Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                        .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                        .frame(width: 300, height: 300)

                    Spacer()

                    Group {
                        Text("Inner radius: \(Int(innerRadius))")
                        Slider(value: $innerRadius, in: 10...150, step: 1)
                            .padding([.horizontal, .bottom])

                        Text("Outer radius: \(Int(outerRadius))")
                        Slider(value: $outerRadius, in: 10...150, step: 1)
                            .padding([.horizontal, .bottom])

                        Text("Distance: \(Int(distance))")
                        Slider(value: $distance, in: 1...150, step: 1)
                            .padding([.horizontal, .bottom])

                        Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                        Slider(value: $amount)
                            .padding([.horizontal, .bottom])

                        Text("Color")
                        Slider(value: $hue)
                            .padding(.horizontal)
                    }
                }
    }
}

struct Arrow: Shape {
    var arrowWidth: Double
    
    var animatableData: Double {
        get { arrowWidth }
        set { arrowWidth = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let headWidth = (rect.width * arrowWidth)
        let lineWidth = headWidth / 2
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX - headWidth, y: rect.minY + headWidth))
        path.addLine(to: CGPoint(x: rect.midX - lineWidth, y: rect.minY + headWidth))
        path.addLine(to: CGPoint(x: rect.midX - lineWidth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + lineWidth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + lineWidth, y: rect.minY + headWidth))
        path.addLine(to: CGPoint(x: rect.midX + headWidth, y: rect.minY + headWidth))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
