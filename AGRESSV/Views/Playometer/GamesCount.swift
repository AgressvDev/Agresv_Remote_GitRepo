//
//  GamesCount.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/16/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore





////Get username to match for count of games
//let db = Firestore.firestore()
//     
//var UserForMatch: [String]!
//
//func GetCurrentUsername() {
//    let uid = Auth.auth().currentUser!.email
//    let docRef = db.collection("Agressv_Users").document(uid!)
//    
//    docRef.getDocument { (document, error) in
//        if let err = error {
//            print("Error getting documents: \(err)")
//        } else {
//            print("\(document!.documentID) => \(String(describing: document!.data()))")
//            
//            UserForMatch = document!.data()!["Username"] as? [String]
//            
//        }
//    }
//}
//
//
//
//let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
//
//func getgamescount() async {
//    let query = db.collection("Agressv_Games").whereField("Game_Date", isGreaterThanOrEqualTo: CurrentDateMinus7 ?? "")
//
//    let countQuery = query.count
//    
//    do {
//        let snapshot = try await countQuery.getAggregation(source: .server)
//        print(snapshot.count)
//    }catch {
//        print(error)
//    }
//}


//class SomeClass {
//    let finalcountofgames: String
//    //let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
//    class func getGameCount() {
//        
//        let db = Firestore.firestore()
//        let uid = Auth.auth().currentUser!.email
//        
//         let query = db.collection("Agressv_Games")
//            .whereField("Game_Creator", isEqualTo:uid!)
//            .whereField("Game_Date", isGreaterThanOrEqualTo: Date())
//         
//         
//        print(query.count)
//       
//         }
//    init() {
//        finalcountofgames = SomeClass.getGameCount()
//    }
//}
