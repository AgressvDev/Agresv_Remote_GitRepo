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
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
       
        return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}





//func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//    print("Background fetch started")
//
//    guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
//        print("User email not found")
//        completionHandler(.noData)
//        return
//    }
//
//    print("User email: \(userEmail)")
//
//    let db = Firestore.firestore()
//    db.collection("Agressv_BadgeCounts").document(userEmail).getDocument { document, error in
//        if let error = error {
//            print("Error fetching document: \(error.localizedDescription)")
//            completionHandler(.failed)
//            return
//        }
//
//        guard let document = document, document.exists,
//              let badgeCount = document.data()?["BadgeCount"] as? Int else {
//            print("Document does not exist or badge count not found")
//            completionHandler(.noData)
//            return
//        }
//
//        UIApplication.shared.applicationIconBadgeNumber = max(badgeCount, 0)
//        print("Badge count updated to: \(badgeCount)")
//        completionHandler(.newData)
//    }
//}

