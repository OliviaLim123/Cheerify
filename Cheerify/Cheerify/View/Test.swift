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
            AppColors.gradientBGM_topShadow
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
            }
        }
    }
}

#Preview {
    LaunchView()
}
