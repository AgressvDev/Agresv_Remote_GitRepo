//
//  PieChart.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 11/12/23.
//

import Foundation
import UIKit

class PieChartView: UIView {
    
    var data: [CGFloat] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        var startAngle: CGFloat = 0
        
        for (index, value) in data.enumerated() {
            let endAngle = startAngle + (value * 2 * .pi)
            
            context.move(to: center)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.closePath()
            
            let color: UIColor
            if index == 0 {
                // Use green for winPercentage
                color = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
            } else {
                // Use black for lossPercentage
                color = UIColor.black
            }
            
            context.setFillColor(color.cgColor)
            context.fillPath()
            
            startAngle = endAngle
        }
    }
}

