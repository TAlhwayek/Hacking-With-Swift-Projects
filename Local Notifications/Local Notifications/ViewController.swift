//
//  ViewController.swift
//  Local Notifications
//
//  Created by Tony Alhwayek on 8/7/23.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        // Get permission for notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay")
            } else {
                print("D'oh!")
            }
            
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        // Remove all pending notifications (haven't been sent yet)
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        // Set what the notification will show
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        // Set a category
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzBuzz"]
        // Set default notification sound
        content.sound = .default
        
        // Specify time to schedule alarm
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 25
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Show alarm after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        // Get state of notifications
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            // What to do with notification
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                presentAC(title: "Default", message: "User opened the app from the notification")
                
            case "show":
                presentAC(title: "Show", message: "User tapped the show button")
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    // Challenge #1
    func presentAC(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        ac.addAction(ok)
        present(ac, animated: true)
    }
    
}

