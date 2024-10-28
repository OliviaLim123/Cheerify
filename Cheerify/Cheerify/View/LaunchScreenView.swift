//
//  LaunchScreenView.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 25/10/2024.
//

import SwiftUI

// MARK: - Launch Screen View
// Handles the launch screen view of the application
struct LaunchScreenView: View {
    
    // State Private Properties of LaunchScreenView
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @StateObject private var profileVM = ProfileViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
    
            // MARK: - Dark Mode set up
            // BGM, changing based on dark or light mode
            if profileVM.isDarkMode {
                AppColors.darkGradientBGM_bottomShadow
                    .ignoresSafeArea(.all)
            } else {
                AppColors.gradientBGM_bottomShadow
                    .ignoresSafeArea(.all)
            }
            
            // Navigates to the TabView after LaunchScreenView if isActive
            if isActive {
                if self.status {
                    TabBar()
                        .navigationBarBackButtonHidden(true)
                } else {
                    // Otherwise navigates to WelcomeView
                    WelcomeView()
                        .navigationBarBackButtonHidden(true)
                }
            } else {
                VStack {
                    appLogo
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            // Providing app logo ease in animation
                            withAnimation(.easeIn(duration: 1.2)) {
                                self.size = 0.9
                                self.opacity = 1.0
                            }
                        }
                }
                .onAppear {
                    // Implement animation to the next view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Display App Logo
    // Handle the appearance of the application logo
    var appLogo: some View {
        // Display the logo and application name
        VStack(spacing: 40) {
            Image("logo")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
            
            Text("CHERRIFY")
                .font(.custom("MontserratAlternates-SemiBold", size: 30))
                .tracking(3.5)
                .foregroundStyle(profileVM.isDarkMode ? .white : .black.opacity(0.8))
                .font(.largeTitle)
        }
    }
}

// MARK: - Previews
#Preview {
    LaunchScreenView()
}

