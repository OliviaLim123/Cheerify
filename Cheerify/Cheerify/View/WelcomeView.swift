//
//  WelcomeView.swift
//  Cheerify
//
//  Created by Hang Vu on 19/10/2024.
//
import SwiftUI

// MARK: - Welcome View Struct
// Handle three steps before log in or sign up
struct WelcomeView: View {
    
    // State Properties of WelcomeView
    @State private var currentIndex = 0
    @State private var navigateToLogin = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    // Property for totalSteps
    let totalSteps = 3
    @StateObject private var profileVM = ProfileViewModel()

    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Dark mode set up
            // BGM, changing based on dark or light mode
            if profileVM.isDarkMode {
                AppColors.darkGradientBGM_bottomShadow
                    .ignoresSafeArea(.all)
            } else {
                AppColors.gradientBGM_bottomShadow
                    .ignoresSafeArea(.all)
            }
            
            VStack {
                
                // MARK: - Display the page indicator
                HStack(spacing: 10) {
                    ForEach(0..<Int(totalSteps), id: \.self) { index in
                        Capsule()
                            .frame(height: 6)
                            .foregroundColor(currentIndex == index ? Color.black : Color.gray.opacity(0.5))
                            .animation(.easeInOut, value: currentIndex)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // MARK: - Display image for each step
                if currentIndex == 0 {
                    // Step 1
                    LottieView(name: Constants.moodScanAnimation, loopMode: .loop, animationSpeed: 1.0)
                        .frame(width: 400, height: 400)
                } else if currentIndex == 1 {
                    // Step 2
                    LottieView(name: Constants.youtubeAnimation, loopMode: .loop, animationSpeed: 2.0)
                        .frame(width: 400, height: 400)
                } else if currentIndex == 2 {
                    // Step 3
                    LottieView(name: Constants.embraceMoodAnimation, loopMode: .loop, animationSpeed: 1.0)
                        .frame(width: 400, height: 400)
                }
                
                Spacer()

                // MARK: - Display text for each step
                VStack(alignment: .leading) {
                    // MARK: - Steps
                    // Step 1 : Step 2 : Step 3
                    Text(currentIndex == 0 ? "Unlock Your Mood in Snap!" : currentIndex == 1 ? "YouTube Video One Click Away!" : "Embrace Your Mood by Widget!")
                        .font(.custom("MontserratAlternates-Medium", size: 35))
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    // MARK: - Step's Description
                    // Step 1 : Step 2 : Step 3
                    Text(currentIndex == 0 ? "Your face, your mood, your videos. Cheerify knows what you need, right when you need it!" :
                        currentIndex == 1 ? "Cheerify match your expression with the best YouTube solutions!" :
                        "We keep the vibe alive with the mood widget!")
//                    .font(.title2)
                    .font(.custom("MontserratAlternates-Medium", size: 20))
                    .tracking(1.5)
                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                }
                .padding(.horizontal)
                
                Spacer()

                // MARK: - Button to next step
                Button {
                    if currentIndex < totalSteps - 1 {
                        currentIndex += 1
                    } else {
                        navigateToLogin = true
                    }
                } label: {
                    Text(currentIndex == totalSteps - 1 ? "Get Started!" : "Continue")
//                        .font(.title2)
                        .font(.custom("MontserratAlternates-Medium", size: 20))
                        .tracking(3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                        .padding()
                        .background(.black)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                }
                // This button will navigate to the LoginView after reaching the last step
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                }
                .onAppear {
                    // When the view appears, it will observe the user status
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                        self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

// MARK: - Previews
#Preview {
    WelcomeView()
}
