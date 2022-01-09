//
//  LocalNotificationManager.swift
//  FCM_test
//
//  Created by 이재준 on 2022/01/07.
//

import Foundation
import UserNotifications

struct Notification {
    var id : String
    var title : String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) {
                granted, error in
                if granted == true && error == nil {
                    // we got permission
                }
            }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }

    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            
            content.sound = UNNotificationSound.default
//            content.subtitle = "Test message"
            content.body = "test message"
//            content.summaryArgument = "Alan Walker" //?
//            content.summaryArgumentCount = 40 // ?
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
        
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id : \(notification.id)")
            }
        }
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings {
            settings in
            
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
}

