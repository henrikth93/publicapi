//
//  ContentView.swift
//  publicapi
//
//  Created by Henrik Thomasson on 2024-10-26.
//

import SwiftUI

struct ContentView: View {
    
    @State var dogfacttext : String = "NO DOG FACTS AS OF YET"
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(dogfacttext)
            
            Button("New dog fact") {
                Task {
                    await loadDogFact()
                }
            }
        }
        .padding()
        .onAppear() {
            //loadDogFact()
        }
        .task() {
            await loadDogFact()
        }
    }
    func loadDogFact() async {
        let dogfactapi = "https://dog-api.kinduff.com/api/facts"
        let dogfacturl = URL(string: dogfactapi)
        
        do {
            let (dogfactdata, _) = try await URLSession.shared.data(from: dogfacturl!)
            
            if let decodedDogFact = try? JSONDecoder().decode(DogFact.self, from: dogfactdata) {
                if let firstFact = decodedDogFact.facts.first {
                    dogfacttext = firstFact
                }
                
            }
        } catch {
                print("LOAD FAILED...")
            }
        
        
    }
}

struct DogFact: Codable {
    var facts: [String]
}

#Preview {
    ContentView()
}
