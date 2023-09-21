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
    
    
//    struct gamecountstruct{
//        var GC: Any
//
//        mutating func getGameCount() -> Any {
//            let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
//            let db = Firestore.firestore()
//            let uid = Auth.auth().currentUser!.email
//
//            let query = db.collection("Agressv_Games")
//                .whereField("Game_Creator", isEqualTo:uid!)
//                .whereField("Game_Date", isGreaterThanOrEqualTo: CurrentDateMinus7!)
//
//            self.GC = query.count
//            //print(query.count)
//            return GC
//
//        }
//
//    }
    
    
        //    var gamecount: NSNumber = 0
        //
        //    mutating func countGames() async {
        //
        //        let uid = Auth.auth().currentUser!.email
        //        let query = db.collection("Agressv_Games").whereField("Game_Creator", isEqualTo:uid!)
        //            .whereField("Game_Date", isGreaterThanOrEqualTo: Today)
        //        let countQuery = query.count
        //        do {
        //            let snapshot = try await countQuery.getAggregation(source: .server)
        //            //print(snapshot.count)
        //            self.gamecount = snapshot.count
        //
        //        } catch{
        //           //do nothing
        //        }
        //    }
    //var countofgames: Any
    
    
        //let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
        
//         func getGameCount() -> Any {
//
//            let db = Firestore.firestore()
//            let uid = Auth.auth().currentUser!.email
//
//             let query = db.collection("Agressv_Games")
//                .whereField("Game_Creator", isEqualTo:uid!)
//                .whereField("Game_Date", isGreaterThanOrEqualTo: CurrentDateMinus7!)
//
//
//             //self.countofgames = query.count
//             print(query.count)
//             }
            
            




    

        
       
        
 
    
    
  
        
        
        
        let gradient = Gradient(colors: [.white, .black, .red])
        @State private var minValue = 0.0
        @State private var maxValue = 32.0
    
        @State var current = "28"
    
    
        
        
        
        
        var body: some View {
            
            
            
            VStack{
                Gauge(value: Double(current) ?? 0, in: minValue...maxValue){
                    
                    
                }
            currentValueLabel: {
                Text(current)
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
        struct GaugeView_Previews: PreviewProvider {
            static var previews: some View {
                GaugeView()
            }
        }
        
        
    }

