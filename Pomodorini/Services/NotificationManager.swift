//
//  NotificationManager.swift
//  Pomodorini
//
//  Created by Nicolas Kargruber on 17.12.24.
//


import UserNotifications
import Foundation

/// A service to handle user notifications for the Pomodorini app.
final class NotificationManager {
    // MARK: - Shared Instance
    
    static let shared = NotificationManager()
    private init() {}
    
    // MARK: - Authorization Request
    
    /// Requests notification authorization from the user.
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("Notification authorization failed: \(error.localizedDescription)")
            } else if granted {
                print("Notification authorization granted.")
            } else {
                print("Notification authorization denied.")
            }
        }
    }
    
    // MARK: - Scheduling Notification
    
    /// Schedules a notification when the timer completes.
    /// - Parameters:
    ///   - title: The title of the notification.
    ///   - body: The body text of the notification.
    ///   - timeInterval: The time interval after which the notification will be triggered.
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        
        let trigger =  UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
}
