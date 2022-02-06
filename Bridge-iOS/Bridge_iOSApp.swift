//
//  Bridge_iOSApp.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import Combine
import Alamofire

@main
struct Bridge_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            BaseView()
                .preferredColorScheme(.light)
        }
    }
}

//class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject, UNUserNotificationCenterDelegate, MessagingDelegate{
//
//    var firebaseToken: String = ""
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//        FirebaseApp.configure()
//        self.registerForFirebaseNotification(application: application)
//        Messaging.messaging().delegate = self
//        return true
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//    func registerForFirebaseNotification(application: UIApplication) {
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//    }
//        //background에서 푸시 알림 받으면
//        func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
//            print("userinfo=== \(userInfo)")
//            completionHandler(.newData)
//        }
//
//        // 푸시메세지가 앱이 켜져 있을때 나올때
//        func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                    willPresent notification: UNNotification,
//                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//            let userInfo = notification
//
//            print("willPresent: userInfo: ", userInfo)
//    //        print("userinfo data : ", userInfo.title)
//    //        print("userinfo data : ", userInfo.body)
//            completionHandler([.banner, .sound, .badge])
//        }
//
//        // 백그라운드에서 푸시메세지를 받았을 때
//        func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                    didReceive response: UNNotificationResponse,
//                                    withCompletionHandler completionHandler: @escaping () -> Void) {
//            let userInfo = response.notification.request.content.userInfo
//            print("didReceive: userInfo: ", userInfo)
//            completionHandler()
//        }
//
//
//        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//            print("messaging")
//            //very important !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
////            self.fcmToken = fcmToken!
////            print("AppDelegate - Firebase registration token: \(String(describing: self.fcmToken))")
//        }
//}


class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    @EnvironmentObject var signInViewModel : SignInViewModel
    @AppStorage("fcmToken") var fcmToken : String = "dihWMDcUVUBCsRFyxSa078:APA91bG-jKjLllf5KtEBhMMksIjm8W3e6Nvswp783LVOQmYNXptN0-Swe-CWX2gAGUhamdgakpcKutKOQ5fW82lTrOFHVC237kGt0dKErCxU-bNEVXU6R6qy7V229oDcLVhdaWSVEJ8F"

    // 앱이 켜졌을때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // Use Firebase library to configure APIs
        // 파이어베이스 설정
        FirebaseApp.configure()

        // 원격 알림 등록
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
            print("A")
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
            print("B")
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
//        application.registerForRemoteNotifications()

        // 메세징 델리겟
        Messaging.messaging().delegate = self


        // 푸시 포그라운드 설정
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("등록 token : ", deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }
    // fcm 토큰 등록 실패ㅐ
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("등록 실패")
    }


}

extension AppDelegate : MessagingDelegate {

    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //very important !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        self.fcmToken = fcmToken!
        print("AppDelegate - Firebase registration token: \(String(describing: self.fcmToken))")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {

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


    //background에서 푸시 알림 받으면
    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        print("userinfo=== \(userInfo)")
        completionHandler(.newData)
    }

    // 푸시메세지가 앱이 켜져 있을때 나올때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification

        print("willPresent: userInfo: ", userInfo)
//        print("userinfo data : ", userInfo.title)
//        print("userinfo data : ", userInfo.body)
        completionHandler([.banner, .sound, .badge])
    }

    // 백그라운드에서 푸시메세지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive: userInfo: ", userInfo)
        completionHandler()
    }
}
