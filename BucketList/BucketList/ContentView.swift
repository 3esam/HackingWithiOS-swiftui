//
//  ContentView.swift
//  BucketList
//
//  Created by Esam Sherif on 8/16/22.
//

import LocalAuthentication
import MapKit
import SwiftUI

struct User: Identifiable, Comparable {
    let id = UUID()
    let firstName: String
    let lastName: String
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}

enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    var body: some View {
        Text("Trying to login!")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Logged in successfully!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Log in FAILED!")
    }
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    let values = [1, 5, 3, 6, 2, 9].sorted()
    
    let users = [
            User(firstName: "Arnold", lastName: "Rimmer"),
            User(firstName: "Kristine", lastName: "Kochanski"),
            User(firstName: "David", lastName: "Lister"),
    ].sorted()
    
    @State private var loadingState = LoadingState.loading
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    let locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    
    @State private var isUnlocked = false
    
    var body: some View {
        VStack{
            
            Group {
                if isUnlocked {
                    Text("Unlocked")
                } else {
                    Text("Locked")
                }
            }.onTapGesture {
                isUnlocked = false
                authenticate()
            }
            
            Group {
                switch loadingState {
                case .loading:
                    LoadingView()
                case .success:
                    SuccessView()
                case .failed:
                    FailedView()
                }
            }
            .onTapGesture {
                if loadingState == .loading {
                    loadingState = Bool.random() ? .failed : .success;
                } else {
                    loadingState = .loading
                }
            }
            
            List{
                ForEach(users) { user in
                    Text("\(user.firstName) \(user.lastName)")
                }
                HStack {
                    ForEach(values, id: \.self){
                        Text(String($0))
                    }
                }
                Text("Hello, World!")
                    .onTapGesture {
                        let str = "test message"
                        let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                        
                        do {
                            try str.write(to: url, atomically: true, encoding: .utf8)
                            
                            let input = try String(contentsOf: url)
                            print(input)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
            }
            
            
            
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    ZStack {
                        Circle()
                            .stroke(.red, lineWidth: 3)
                            .frame(width: 30, height: 30)
                        Text(location.name)
                    }
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    
                }
            }
        } else {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
