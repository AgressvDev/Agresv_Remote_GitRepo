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
    
   // var currentValue: String = "4"
    
  
    public var currentValue: String

    
    
    
    
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
//    struct GaugeView_Previews: PreviewProvider {
//        static var previews: some View {
//            GaugeView(currentValue: doccount)
//        }
//    }
    
    
    
    
}
