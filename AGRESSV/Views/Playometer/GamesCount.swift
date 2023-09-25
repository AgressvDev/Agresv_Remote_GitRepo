//
//  GamesCount.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/16/23.
//
import UIKit
import Firebase
import FirebaseFirestore
import SwiftUI
import Foundation

var gv_count: String = ""
//
//func CountForGauge() {
//    // Reference to Firestore collection
//    let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
//    let db = Firestore.firestore()
//    let uid = Auth.auth().currentUser!.email
//
//    // Define your query
////            let query = db.collection("Agressv_Games").whereFilter(
////                Filter.orFilter([Filter.whereField("Game_Partner", isEqualTo: uid!),
////                Filter.whereField("Game_Creator", isEqualTo:uid!)]))
//
//    //query trial 2
//    let query = db.collection("Agressv_Games").whereFilter(Filter.andFilter([
//        Filter.whereField("Game_Date", isGreaterOrEqualTo: CurrentDateMinus7!),
//        Filter.orFilter([
//            Filter.whereField("Game_Creator", isEqualTo: uid!),
//            Filter.whereField("Game_Opponent_One", isEqualTo: uid!),
//            Filter.whereField("Game_Opponent_Two", isEqualTo: uid!),
//            Filter.whereField("Game_Partner", isEqualTo: uid!)
//
//        ])
//    ]))
//
//    //query trial 3
////            let query = db.collection("Agressv_Games").whereFilter(
////                    Filter.andFilter([Filter.whereField("Game_Opponent_Two", isEqualTo: uid!),
////                    Filter.whereField("Game_Date", isGreaterOrEqualTo: CurrentDateMinus7!)]))
//
//
//    query.getDocuments { (querySnapshot, error) in
//        if error != nil {
//            return
//        }
//        else {
//
//             let mastercount = querySnapshot?.documents.count ?? 0
//
//            gv_count = String(mastercount)
//
//
//        }
//    }
//}


func getCountAsStringFromFirestore(collectionName: String, completion: @escaping (String?, Error?) -> Void)
{
    let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.email
    
    
    let query = db.collection("Agressv_Games").whereFilter(Filter.andFilter([
        Filter.whereField("Game_Date", isGreaterOrEqualTo: CurrentDateMinus7!),
        Filter.orFilter([
            Filter.whereField("Game_Creator", isEqualTo: uid!),
            Filter.whereField("Game_Opponent_One", isEqualTo: uid!),
            Filter.whereField("Game_Opponent_Two", isEqualTo: uid!),
            Filter.whereField("Game_Partner", isEqualTo: uid!)

        ])
    ]))
    
    query.getDocuments { (snapshot, error) in
        if let error = error {
            // Handle the error and call the completion handler with nil count and the error.
            completion(nil, error)
            return
        }
        
        if let snapshot = snapshot {
            let count = snapshot.documents.count
            let countString = String(count)
            // Return the count as a String via the completion handler.
            completion(countString, nil)
        }
    }
    
}




