//
//  GaugeView.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/28/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import UIKit
import Swift


struct GaugeView: View {
    
    
     var currentValue = "12"
    
//    func currentcountforgauge() {
//        // Reference to Firestore collection
//
//        //let db = Firestore.firestore()
//        let uid = Auth.auth().currentUser!.email
//
//        // Define your query
//        let query = db.collection("Agressv_Games")
//            .whereField("Game_Creator", isEqualTo:uid!)
//            .whereField("Game_Date", isGreaterThanOrEqualTo: CurrentDateMinus7!)
//
//        query.getDocuments { (querySnapshot, error) in
//            if error != nil {
//                return
//            } else {
//                let count = querySnapshot?.documents.count ?? 0
//                var gv = GaugeView()
//
//                gv.currentValue = String(count)
//            }
//        }}
        
   
    
    
        let gradient = Gradient(colors: [.white, .black, .red])
        @State private var minValue = 0.0
        @State private var maxValue = 32.0
    
    
        
        var body: some View {
            
            
            
            VStack{
                Gauge(value: Double(currentValue) ?? 0, in: minValue...maxValue){
                    
                    
                }
            currentValueLabel: {
                Text(currentValue)
            }
            minimumValueLabel: {
                Text("\(Int(minValue))")
            }
            maximumValueLabel:{
                Text("\(Int(maxValue))")
            }
            .gaugeStyle(.accessoryLinear)
            .tint(gradient)
            .padding()
            .position(x: 195, y: 560)
                
                
                
                
            }
            
        }
//        struct GaugeView_Previews: PreviewProvider {
//            static var previews: some View {
//                GaugeView()
//            }
        }
        
        
    

