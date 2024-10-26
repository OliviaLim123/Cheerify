//
//  CheerifyApp.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 16/10/2024.
//

import SwiftUI
import FirebaseCore

// MARK: - App Delegate
// It is used for connecting the Firebase with this project
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
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
