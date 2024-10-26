//
//  ProfileViewModel.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 23/10/2024.
//

import FirebaseAuth
import SwiftUI

// MARK: - Profile View Model
// Handle the main functionality for the authentication using Firebase
class ProfileViewModel: ObservableObject {
    
    // App Storage to store the display mode preference
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    // MARK: - Load User Theme Preference
    // Load the current logged user display mode preference (either light mode or dark mode)
    func loadUserThemePreference() {
        if let userId = Auth.auth().currentUser?.uid {
            isDarkMode = UserDefaults.standard.bool(forKey: "\(userId)_isDarkMode")
        }
    }
    
    // MARK: - Update Color Scheme Function
    // Update the color scheme
    func updateColorScheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        // Display the window scene if it is dark or light mode
        for window in windowScene.windows {
            window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
        // Store the updated display mode for the specific user id
        if let userId = Auth.auth().currentUser?.uid {
            UserDefaults.standard.set(isDarkMode, forKey: "\(userId)_isDarkMode")
        }
    }
    
    // MARK: - Get Intial Function
    // Get the first initial from the user email to show as the profile
    func getInitial(from email: String) -> String {
        let firstInitial = email.prefix(1).uppercased()
        return firstInitial
    }
    
    // MARK: - Set App to Light Mode Function
    // Set the application in light display mode (default)
    func setAppToLightMode() {
        // Error Handling
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        for window in windowScene.windows {
            // Force light mode since it is default
            window.overrideUserInterfaceStyle = .light
        }
    }
}
