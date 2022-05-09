//
//  CrewView.swift
//  Moonshot
//
//  Created by Esam Sherif on 5/9/22.
//

import SwiftUI

struct CrewView: View {
    let crew: [CrewMember]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Crew")
                .font(.title.bold())
                .padding(.bottom, 5)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(crew, id: \.role) { crewMember in
                        NavigationLink {
                            AstronautView(astronaut: crewMember.astronaut)
                        } label: {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 104, height: 72)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(.white, lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct CrewView_Previews: PreviewProvider {
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        CrewView(crew:
                    [
                        CrewMember(role: "Role 1", astronaut: astronauts["grissom"]!),
                        CrewMember(role: "Role 2", astronaut: astronauts["white"]!),
                        CrewMember(role: "Role 3", astronaut: astronauts["schirra"]!)
                    ]
        )
        .background(.lightBackground)
    }
}
