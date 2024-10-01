//
//  NotificationManager.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/12/24.
//

import Foundation
import GameKit

class NotificationManager: ObservableObject {
    
    let bodies = [
        "A problem reveals itself only when you understand its structure.",
        "Clarity comes not from knowing the answer, but from refining the question.",
        "The best solutions emerge when you stop looking for easy ones.",
        "A problem often teaches more than the solution ever could.",
        "Solving isn't just about answers, it's about uncovering the right approach.",
        "Every complex problem is a network of smaller, simpler problems.",
        "A good problem solver is defined by how they handle uncertainty, not how they avoid it.",
        "Insight grows through iteration—each failure sharpens the next attempt.",
        "The depth of a problem is hidden in its assumptions.",
        "The simplest solutions are often found on the far side of complexity.",
        "True problem solvers are comfortable with ambiguity and thrive in uncertainty.",
        "To solve effectively, one must first see beyond the obvious.",
        "The process of solving a problem is as important as the solution itself.",
        "Questions shape the path; answers are just a byproduct of the journey.",
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
        let randomBodyIndex = Int.random(in: 0..<bodies.count)
        
        let content = UNMutableNotificationContent()
        content.title = "Shape Swap"
        content.body = bodies[randomBodyIndex]
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "BoingNotification.caf"))

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.removeAllPendingNotificationRequests()
        center.add(request)
    }

}
