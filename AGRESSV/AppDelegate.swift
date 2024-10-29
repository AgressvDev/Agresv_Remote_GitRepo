//
//  AppDelegate.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/17/23.
//

import UIKit
import FirebaseCore
import UserNotifications
import Firebase
import FirebaseFirestore
import FirebaseAuth


@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Set the messaging delegate
        Messaging.messaging().delegate = self
        
        // Set UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request permission for notifications
        requestNotificationAuthorization()
        
        // Register for remote notifications
        application.registerForRemoteNotifications()

        return true
    }

    // Request notification authorization
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error)")
            }
            // Handle the granted status if necessary
            print("Notification permission granted: \(granted)")
        }
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Handle discarded scenes if necessary
    }

    // MARK: MessagingDelegate Methods

    // Handle receiving the FCM token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "")")
        // Send the FCM token to your server if needed
    }

    // Handle APNs token receipt
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // Handle incoming notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 didReceive response: UNNotificationResponse,
                                 withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Update badge count from the notification payload
        if let badge = userInfo["badge"] as? Int {
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
        
        completionHandler()
    }

    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show the notification even if the app is in the foreground
        completionHandler([.alert, .badge, .sound]) // Show alert if needed
    }

    
}
