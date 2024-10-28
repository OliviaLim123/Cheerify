//
//  Test.swift
//  Cheerify
//
//  Created by Hang Vu on 22/10/2024.
//
import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            
            // Use the predefined gradient background
            AppColors.darkGradientBGM_topShadow
                .edgesIgnoringSafeArea(.all) // To cover the entire screen
            
            // content (logo, text, etc.)
            VStack {
                
                //  logo
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)
                
                //  App name
                Text("Cheerify")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .tracking(5.0)
                
                //  Button 1
                VStack {
                    Button("Classify Mood") {
                    }
                }
                .font(.headline)
                .fontDesign(.rounded)
                .padding()
                .background(AppColors.fierySunsetGradient)
                .foregroundColor(.black.opacity(0.7))
                .cornerRadius(10)
                
                //  Wrapped line around button
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1.5)
                )
                //  Shadowing
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                                
                // Button 2
                VStack {
                    //  Button 2
                    Button("Classify Mood") {
                    }
                }
                .font(.headline)
                .fontDesign(.rounded)
                .padding()
//                .background(AppColors.fierySunsetGradient)
                .foregroundStyle(AppColors.fierySunsetGradient)
                .cornerRadius(10)
                
                //  Wrapped line around button
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.fierySunsetGradient, lineWidth: 3)
                )
                //  Shadowing
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                // Button 3
                VStack {
                    //  Button 2
                    Button("Classify Mood") {
                    }
                }
                .font(.headline)
                .fontDesign(.rounded)
                .padding()
                .background(Color.black.opacity(0.5))
                .foregroundStyle(AppColors.fierySunsetGradient)
                .cornerRadius(10)
                
                //  Wrapped line around button
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.fierySunsetGradient, lineWidth: 3)
                )
                //  Shadowing
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            }
        }
    }
}

#Preview {
    LaunchView()
}
