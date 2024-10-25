//
//  LaunchScreenView.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 25/10/2024.
//

import SwiftUI

// MARK: LAUNCH SCREEN VIEW
struct LaunchScreenView: View {
    
    // STATE PRIVATE PROPERTIES of LaunchScreenView
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @StateObject private var profileVM = ProfileViewModel()
    
    // BODY VIEW
    var body: some View {
        ZStack {
    
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
    
    // APP LOGO VIEW
    var appLogo: some View {
        // Display the logo and application name
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
            Text("Cheerify")
                .fontWeight(.bold)
                .foregroundStyle(.customBlack)
                .font(.largeTitle)
            
        }
    }
}

// MARK: LAUNCH SCREEN PREVIEW
#Preview {
    LaunchScreenView()
}

