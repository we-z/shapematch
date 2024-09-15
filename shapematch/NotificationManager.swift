//
//  NotificationManager.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/12/24.
//

import Foundation
import GameKit

class NotificationManager: ObservableObject {
    
    // Define arrays of titles and bodies
    let titles = [
        "Keep Pushing Forward",
        "Challenges Lead to Growth",
        "Stay Focused",
        "Every Step Counts",
        "Think, Plan, Solve",
        "Don’t Give Up",
        "Every Problem Has a Solution",
        "Success is Around the Corner"
    ]
    
    let bodies = [
        "Life is all about solving problems.",
        "The harder the problem, the greater the reward.",
        "Problems are opportunities in disguise.",
        "It’s not about how fast you solve, but how well you think.",
        "Every challenge you overcome sharpens your mind.",
        "Perseverance turns obstacles into stepping stones.",
        "The solution is just a few moves away.",
        "Stay patient, every problem can be solved."
    ]
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self.scheduleLocal()
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func scheduleLocal() {
        print("scheduleLocal called")
        let center = UNUserNotificationCenter.current()

        // Randomly select a title and body
        let randomTitleIndex = Int.random(in: 0..<titles.count)
        let randomBodyIndex = Int.random(in: 0..<bodies.count)
        
        let content = UNMutableNotificationContent()
        content.title = titles[randomTitleIndex]
        content.body = bodies[randomBodyIndex]
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "BoingNotification.caf"))

        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.removeAllPendingNotificationRequests()
        center.add(request)
    }

}
