//
//  AddGamesFunc.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/18/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

var Today = Date()

func addGame(){
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.email
    let ref = db.collection("Agressv_Games").document(uid!)
   
  

    ref.setData(["Game_Count" : 1, "Game_Date" : Today])
   
}
