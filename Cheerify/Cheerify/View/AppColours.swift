//
//  AppColours.swift
//  Cheerify
//
//  Created by Hang Vu on 22/10/2024.
//

import SwiftUI

struct AppColors {
    static let darkYellow = Color(red: 255 / 255, green: 194 / 255, blue: 81 / 255)    // FFC251
    static let lightYellow = Color(red: 255 / 255, green: 231 / 255, blue: 186 / 255)  // FFE7BA

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
}
