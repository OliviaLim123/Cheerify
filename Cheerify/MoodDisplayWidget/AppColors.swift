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

    // MARK: - Light mode backgound
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
