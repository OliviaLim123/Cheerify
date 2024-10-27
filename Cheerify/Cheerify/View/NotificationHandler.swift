//
//  NotificationHandler.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 27/10/2024.
//

import Foundation
import UserNotifications

// MARK: - Notification Handler Struct
// Manages the notification-related operations
struct NotificationHandler {
    
    // MARK: - Request Notification Permission
    // Request permission from the user to display alerts, badges, and sounds of the notification
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
                completion(false)
            } else {
                if granted {
                    setupNotifications()
                    print("Permission granted!")
                    completion(true)
                } else {
                    print("Permission denied.")
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Schedule Notification Function
    // Schedules a local notification with a title, body, and time interval
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "moodCategory"
        
        // Trigger the notification after a specific interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        // Create the request with the provided identifier and schedule it
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled: \(identifier)")
            }
        }
    }
    
    
    // MARK: - Set up Notification Function
    // Schedules multiple predefined notification with several time interval
    func setupNotifications() {
        
        // For the testing and demonstration (10 seconds)
        scheduleNotification(
            title: "⭐️ Just a Quick Check-in?",
            body: "How are you feeling right now? Your mood matters",
            timeInterval: 10,
            identifier: "quickCheckIn"
        )
        
        // Schedule notification 2 hours from now
        scheduleNotification(
            title: "🌸 Mood Check: What's on your mind?",
            body: "Take a breath! Every feeling counts - capture yours now.",
            timeInterval: 60 * 60 * 2,
            identifier: "littleSelfCare"
        )
        
        // Schedule notification 5 hours from now
        scheduleNotification(
            title: "Do take care of your me...",
            body: "Record your day. 🌹",
            timeInterval: 60 * 60 * 5,
            identifier: "recordYourDay"
        )

        // Schedule notification 8 hours from now
        scheduleNotification(
            title: "💭 How's Your Day Going?",
            body: "Track you feelings - It's okay to feel whatever you feel.",
            timeInterval: 60 * 60 * 8,
            identifier: "yourDay"
        )
        
        // Schedule notification 12 hours from now
        scheduleNotification(
            title: "🌙 End the Day with Checking Your Mood",
            body: "Let's us know what you are feel now.",
            timeInterval: 60 * 60 * 12,
            identifier: "endTheDay"
        )
    }
}
