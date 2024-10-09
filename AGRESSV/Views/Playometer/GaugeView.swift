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
    
    
    
    public var currentValue: String
    
  

    
    let gradient = Gradient(colors: [.white, .gray, .red])
    @State private var minValue = 0.0
    @State private var maxValue = 20.0
    
    
    
    var body: some View {
        
        
       
        VStack{
            
                Gauge(value: Double(currentValue) ?? 0, in: minValue...maxValue){
                    
                    
                }
                
            currentValueLabel: {
                Text(currentValue)
            }
            minimumValueLabel: {
                Text("\(Int(minValue))")
                    .font(.headline)
                                    .foregroundColor(.white)
            }
            maximumValueLabel:{
                Text("\(Int(maxValue))")
                    .font(.headline)
                                    .foregroundColor(.white)
            }
            .gaugeStyle(.accessoryLinear)
            .tint(gradient)
            .padding()
            
                //.frame(width: 400)
                //.frame(height: 5)
                //.position(x:190, y:550)
                
                
                
            }
        .background(Color.clear)
       
            
        }
        //    struct GaugeView_Previews: PreviewProvider {
        //        static var previews: some View {
        //            GaugeView(currentValue: doccount)
        //            //GaugeView()
        //        }
        //    }
        
        
        
        
    }

