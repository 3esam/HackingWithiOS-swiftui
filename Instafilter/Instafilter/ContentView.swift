//
//  ContentView.swift
//  Instafilter
//
//  Created by Esam Sherif on 6/10/22.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var blurAmount = 0.0
    
    @State private var showingconfirmation = false
    @State private var backgroundColor = Color.white
    
    @State private var image: Image?
    
    @State private var imageFromPicker: Image?
    @State private var showingImageFromPicker = false
    
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount){ newValue in
                    print("New Value is \(newValue)")
                }
            
            Button("Random Blue"){
                blurAmount = Double.random(in: 0...20)
            }
            
            Text("Hello, World!")
                .frame(width: 200, height: 60)
                .background(backgroundColor)
                .onTapGesture {
                    showingconfirmation = true
                }
                .confirmationDialog("Change background", isPresented: $showingconfirmation){
                    Button("Red") { backgroundColor = .red }
                    Button("Green") { backgroundColor = .green }
                    Button("Blue") { backgroundColor = .blue }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Select new color")
                }
            
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
            }
            .onAppear(perform: loadImage)
            
            VStack {
                imageFromPicker?
                    .resizable()
                    .scaledToFit()
                
                Button("select image") {
                    showingImageFromPicker = true
                }
            }
            .sheet(isPresented: $showingImageFromPicker){
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in
                loadImageFromPicker()
            }
        }
    }
    
    func loadImageFromPicker() {
        guard let inputImage = inputImage else { return }
        imageFromPicker = Image(uiImage: inputImage)
        
        // write image to library right away
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)
    }
    
    func loadImage() {
//        image = Image("Example")
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
//        let currentFilter = CIFilter.sepiaTone()
//        currentFilter.intensity = 1
//        let currentFilter = CIFilter.pixellate()
//        currentFilter.scale = 50
//        let currentFilter = CIFilter.crystallize()
//        currentFilter.radius = 50
        let currentFilter = CIFilter.twirlDistortion()
        
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
        
        currentFilter.radius = 1000
        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        
        currentFilter.inputImage = beginImage
        guard let outputImage = currentFilter.outputImage else { return }
        
        let context = CIContext()
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
