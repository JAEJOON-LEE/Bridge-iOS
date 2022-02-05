//
//  LocalNotificationManager.swift
//  FCM_test
//
//  Created by 이재준 on 2022/01/07.
//

import Foundation
import UserNotifications

//struct Notification {
//    var id : String
//    var title : String
//}

//final class LocalNotificationManager : ObservableObject{
//    @Published var notifications = [Notification]()
//    @Published var ReceiverFCMToken =  AppDelegate().fcmToken
//    //개인 기기 token -> 각 사용자마다 값 받아와야함
//    @Published var legacyServerKey = "AAAAFYLL65I:APA91bF_g2671df_634Qyr3V4RzDnGN6IP3YAcvbujSmUDqoq_mxLwYVIi6RJOeVILSIecTBPjFQKeR2hDeui1xf5OPBjNNbwsEXAptA0yvkZwp1AMgknVdEM20byDdh8if5qzLxuQ4D" //서버 token (변경 x)
//    @Published var badgeCnt = 0
//
//    func requestPermission() -> Void {
//        UNUserNotificationCenter
//            .current()
//            .requestAuthorization(options: [.alert, .badge, .alert]) {
//                granted, error in
//                if granted == true && error == nil {
//                    // we got permission
//                }
//            }
//    }
//
//    func addNotification(title: String) -> Void {
//        notifications.append(Notification(id: UUID().uuidString, title: title))
//    }
//
//    func scheduleNotifications() -> Void {
//        for notification in notifications {
//            let content = UNMutableNotificationContent()
//            content.title = notification.title
//
//            content.sound = UNNotificationSound.default
////            content.subtitle = "Test message"
//            content.body = "test message"
////            content.summaryArgument = "Alan Walker" //?
////            content.summaryArgumentCount = 40 // ?
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
//
//            UNUserNotificationCenter.current().add(request) { error in
//                guard error == nil else { return }
//                print("Scheduling notification with id : \(notification.id)")
//            }
//        }
//    }
//
//    func schedule() -> Void {
//        UNUserNotificationCenter.current().getNotificationSettings {
//            settings in
//
//            switch settings.authorizationStatus {
//            case .notDetermined:
//                self.requestPermission()
//            case .authorized, .provisional:
//                self.scheduleNotifications()
//            default:
//                break
//            }
//        }
//    }
//
//    func sendMessageTouser(to token: String, title: String, body: String) {
//            print("sendMessageTouser()")
//            badgeCnt = badgeCnt + 1
//
//            let urlString = "https://fcm.googleapis.com/fcm/send"
//            let url = NSURL(string: urlString)!
//            let paramString: [String : Any] = ["to" : token,
//                                               "notification" : ["title" : title, "body" : body, "badge" : badgeCnt],
//                                               "data" : ["user" : "test_id"]
//            ]
//            let request = NSMutableURLRequest(url: url as URL)
//            request.httpMethod = "POST"
//            request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("key=\(legacyServerKey)", forHTTPHeaderField: "Authorization")
//            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
//                do {
//                    if let jsonData = data {
//                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
//                            NSLog("Received data:\n\(jsonDataDict))")
//                        }
//                    }
//                } catch let err as NSError {
//                    print(err.debugDescription)
//                }
//            }
//            task.resume()
//        }
//
//}

