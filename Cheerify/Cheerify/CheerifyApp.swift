//
//  CheerifyApp.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 16/10/2024.
//

import SwiftUI
import FirebaseCore
import UserNotifications

// MARK: - App Delegate
// It is used for managing the application's lifecycle and notifications
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: - Application Launch Setup
    // Configure the Firebase and set the UNUserNotificationCenter
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Set the UNUserNotificationCenter delegate to self
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // MARK: - Handle foreground notification
    // It is called when a notification arrives while the app is active
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notifications even if the app is in the foreground
        // Set up the banner, sound, and updating the badge count
        completionHandler([.banner, .sound, .badge])
    }

    // MARK: - Handle notification interaction
    // Handle user interaction with the notification
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
    ){
        print("User tapped on notification: \(response.notification.request.identifier)")
        // Reset the badge when the user taps the notification
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("Failed to reset badge count: \(error)")
            } else {
                print("Badge count reset successfully.")
            }
        }
        completionHandler()
    }
    
}

// MARK: - CheerifyApp
// The root of this application will begin with the LaunchScreenView
@main
struct CheerifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LaunchScreenView()
                
            }
        }
    }
}
