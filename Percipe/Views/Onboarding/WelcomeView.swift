//
//  WelcomeView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var currentIndex = 0
    let displayDuration = 3.0 // Duration in seconds for each string
    let texts = [
        "Welcome to Percipe!",
        "Find new dishes",
        "Explore your palette",
        "Discover your taste",
        "Match with mashed potatoes"
    ]
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false) { timer in
            // Increment the currentIndex to show the next string
            if currentIndex < texts.count - 1 {
                withAnimation(.linear) {
                    currentIndex += 1
                }
                startTimer() // Start the timer again for the next string
            }
        }
    }
    var body: some View {
        VStack {
            VStack {
                Spacer(minLength: 20)
                Text(texts[currentIndex])
                    .font(.system(size: 30))
                    .onAppear {
                        startTimer()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Spacer(minLength: 50)
            }.background {
                Image(.welcomeScreenBackground)
                    .resizable()
                    .scaledToFill()
            }
            HStack {
                Spacer()
                NavigationLink("Get Started", destination: SelectAllergiesView())
                    .padding(.trailing, 32)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.helloFreshDarkGreen))
            }
            .padding(.bottom, 32)
            .padding(.top, 32)
        }
        .navigationTitle("Welcome")
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
