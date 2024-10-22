//
//  TabBar.swift
//  Cheerify
//
//  Created by Hang Vu on 22/10/2024.
//

import SwiftUI

struct TabBar: View {
    
    //  MARK: - PROPERTY
    @State var current = "Home"
    
    //  MARK: - BODY
    var body: some View {
        ZStack {
            // TabView that extends across the entire screen
            tabView
            VStack {
                Spacer()
                tabButton // Tab buttons at the bottom
            }
        }
    }
    
    //  MARK: TabView - Navigation to each screen
    var tabView: some View {
        TabView(selection: $current) {
            HomeView()
                .tag("Home")
            MoodTrackingView()
                .tag("Tracking")
            ProfileView()
                .tag("Profile")
        }
    }
    
    //  MARK: TabBar - The appearance of tab Buttons
    var tabButton: some View {
        HStack(spacing:0) {
            TabButton(title: "Home", image: "house.fill", isSelected: $current)
            Spacer(minLength: 0)
            TabButton(title: "Tracking", image: "face.smiling.fill", isSelected: $current)
            Spacer(minLength: 0)
            TabButton(title: "Profile", image: "person.fill", isSelected: $current)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        
        //  INNER SHADOW (for TabView)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10.0) // Shape of the background
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.frangipani) // Adjust your color here
                    .frame(height: 65) // Set the height
                    .padding(.horizontal, -15) // Horizontal padding to extend the shadow area
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Shape for the shadow effect
                            .stroke(Color.gray, lineWidth: 4) // Shadow border color and width
                            .blur(radius: 3) // Blur for a soft shadow
                            .offset(x: 0, y: 2) // Offset to simulate depth
                            .mask(
                                RoundedRectangle(cornerRadius: 10) // Mask with the same shape
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .top, endPoint: .bottom) // Gradient for inner shadow effect
                                    )
                            )
                            .padding(.horizontal, -15)
                    )
            }
        )
        .clipShape(Capsule()) // Clip it to the shape of a capsule if desired
        .padding(.horizontal, 25)
        .padding(.bottom, 10)
    }
}

//  MARK: - PREVIEWS
#Preview {
    TabBar()
}
