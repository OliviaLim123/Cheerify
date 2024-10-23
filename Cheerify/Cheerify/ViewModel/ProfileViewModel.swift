//
//  ProfileViewModel.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 23/10/2024.
//

import FirebaseAuth
import SwiftUI

// MARK: PROFILE VIEW MODEL
class ProfileViewModel: ObservableObject {
    
    // APP STORAGE to store the display mode preference
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    // METHOD to load the current logged user display mode preference
    func loadUserThemePreference() {
        if let userId = Auth.auth().currentUser?.uid {
            isDarkMode = UserDefaults.standard.bool(forKey: "\(userId)_isDarkMode")
        }
    }
    
    // METHOD to update the color scheme
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
    
    // METHOD to get the first initial from the user email
    func getInitial(from email: String) -> String {
        let firstInitial = email.prefix(1).uppercased()
        return firstInitial
    }
    // FUNCTION to set the application in light display mode (default)
    func setAppToLightMode() {
        // ERROR HANDLING
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        for window in windowScene.windows {
            // Force light mode since it is default
            window.overrideUserInterfaceStyle = .light
        }
    }
}
