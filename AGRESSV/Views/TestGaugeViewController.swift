//
//  TestGaugeViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/15/23.
//

import UIKit
import SwiftUI

class TestGaugeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //ADD GAUGE / PLAYOMETER
          
          let vc = UIHostingController(rootView: GaugeView())

              let swiftuiView_gauge = vc.view!
          swiftuiView_gauge.translatesAutoresizingMaskIntoConstraints = true
              
          swiftuiView_gauge.frame.size.width = 400
          
      
              // 2
              // Add the view controller to the destination view controller.
              addChild(vc)
              view.addSubview(swiftuiView_gauge)
              
          self.view.bringSubviewToFront(swiftuiView_gauge)
              swiftuiView_gauge.frame = CGRectMake( 15, 75, swiftuiView_gauge.frame.size.width, swiftuiView_gauge.frame.size.height ) // set new position exactly
          
          
              // 4
              // Notify the child view controller that the move is complete.
              vc.didMove(toParent: self)
        
        
    }
    

   

}
