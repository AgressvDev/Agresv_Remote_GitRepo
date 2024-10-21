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
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Set the messaging delegate
        Messaging.messaging().delegate = self
        
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
            // Optionally handle the granted status here
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
        // Send the FCM token to your server, if needed
    }

    // Handle APNs token receipt
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // Uncomment if you have background fetch implementation
    /*
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Background fetch started")
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            print("User email not found")
            completionHandler(.noData)
            return
        }
        print("User email: \(userEmail)")

        let db = Firestore.firestore()
        db.collection("Agressv_BadgeCounts").document(userEmail).getDocument { document, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completionHandler(.failed)
                return
            }

            guard let document = document, document.exists,
                  let badgeCount = document.data()?["BadgeCount"] as? Int else {
                print("Document does not exist or badge count not found")
                completionHandler(.noData)
                return
            }

            UIApplication.shared.applicationIconBadgeNumber = max(badgeCount, 0)
            print("Badge count updated to: \(badgeCount)")
            completionHandler(.newData)
        }
    }
    */
}
