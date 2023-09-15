//
//  GaugeView.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/28/23.
//

import SwiftUI

struct GaugeView: View {
    
    @State var current = 14.0 //change to actual data
    let gradient = Gradient(colors: [.white, .black, .red])
    @State private var minValue = 0.0
    @State private var maxValue = 32.0
    
    
        
    
    
    var body: some View {
        
        VStack{
            Gauge(value: current, in: minValue...maxValue){
                
                
            }
            .gaugeStyle(.accessoryLinear)
            .tint(gradient)
            .padding()
            .position(x: 200, y: 560)
            
            
            
            
        }
        
    }
    struct GaugeView_Previews: PreviewProvider {
        static var previews: some View {
            GaugeView()
        }
    }
    
    
}