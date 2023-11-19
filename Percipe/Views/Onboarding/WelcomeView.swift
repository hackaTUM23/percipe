//
//  WelcomeView.swift
//  Percipe
//
//  Created by Martin Fink on 18.11.23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var currentIndex = 0
    let displayDuration = 2.0 // Duration in seconds for each string
    
    let texts = [
        "Welcome to Percipe!",
        "Find new dishes",
        "Explore your palette",
        "Discover your taste",
        "Follow real recipes",
    ]
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false) { timer in
            // Increment the currentIndex to show the next string
            if currentIndex < texts.count - 1 {
                withAnimation(.easeInOut) {
                    currentIndex += 1
                }
            } else {
                currentIndex = 0
            }
            startTimer() // Start the timer again for the next string
        }
    }
    var body: some View {
        VStack {
            HStack {
                Text("Percipe")
                    .font(.largeTitle)
                Spacer()
            }
            .padding()
            .padding(.top, 48)
            Spacer(minLength: 220)
            Text(texts[currentIndex])
                .frame(maxWidth: .infinity)
                .font(.system(size: 30))
                .onAppear {
                    startTimer()
                }
                .foregroundColor(.white)
                .padding(.top, 64)
                .padding(.bottom, 32)
                .background(LinearGradient(colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.2),
                    Color.black.opacity(0.2),
                    Color.black.opacity(0.0),
                ], startPoint: .top, endPoint: .bottom))
            Spacer(minLength: 50)
            HStack {
                Spacer()
                NavigationLink("Get Started", destination: SelectAllergiesView())
                    .padding(.trailing, 32)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.helloFreshDarkGreen))
            }
            .padding(.bottom, 48)
            .padding(.top, 32)
        }.background {
            Image(.welcomeScreenBackground)
                .resizable()
                .scaledToFill()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
