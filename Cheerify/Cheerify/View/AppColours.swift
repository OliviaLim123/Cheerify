//
//  AppColours.swift
//  Cheerify
//
//  Created by Hang Vu on 22/10/2024.
//

import SwiftUI

// MARK: - AppColors
// Handle the gradient backgound colour for the dark mode and light mode
struct AppColors {
    
    // FFC251
    static let darkYellow = Color(red: 255 / 255, green: 194 / 255, blue: 81 / 255)
    // FFE7BA
    static let lightYellow = Color(red: 255 / 255, green: 231 / 255, blue: 186 / 255)
    
    // 2D2011
    static let darkBrown = Color(red: 45 / 255, green: 32 / 255, blue: 17 / 255)
    // 936A38
    static let lightBrown = Color(red: 147 / 255, green: 106 / 255, blue: 56 / 255)
    
    // MARK: - Custom Gradient
        static let sunsetGradient = LinearGradient(
            gradient: Gradient(colors: [Color.orange, Color.yellow, Color.orange.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    
    static let fierySunsetGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 245 / 255, green: 58 / 255, blue: 9 / 255), // #f53a09
            Color(red: 255 / 255, green: 200 / 255, blue: 79 / 255) // #ffc84f
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Light mode background
    static let gradientBGM_topShadow = LinearGradient(
        gradient: Gradient(colors: [AppColors.lightYellow, AppColors.darkYellow]),
        startPoint: .bottom,
        endPoint: .top
    )
    
    static let gradientBGM_bottomShadow = LinearGradient(
        gradient: Gradient(colors: [AppColors.lightYellow, AppColors.darkYellow]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // MARK: - Dark mode background
    static let darkGradientBGM_topShadow = LinearGradient(
            gradient: Gradient(colors: [AppColors.lightBrown, AppColors.darkBrown]),
            startPoint: .bottom,
            endPoint: .top
    )
    
    static let darkGradientBGM_bottomShadow = LinearGradient(
            gradient: Gradient(colors: [AppColors.lightBrown, AppColors.darkBrown]),
            startPoint: .top,
            endPoint: .bottom
    )
}
