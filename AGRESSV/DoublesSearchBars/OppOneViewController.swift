//
//  OppOneViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/27/23.
//

import UIKit

class OppOneViewController: UIViewController {

    
    
    @IBOutlet weak var lbl_OpponentOne: UILabel!
    


    @IBOutlet weak var SB_OpponentOne: UISearchBar!
    
    
    @IBOutlet weak var Table_OpponentOne: UITableView!
    
    var dataSourceArrayOpponentOne = [String]()
    var filteredDataSourceArrayOpponentOne = [String]()
    
    
    var searching = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor] //UIColor.red.cgColor]
        
        gradientLayer.shouldRasterize = true
        
        //GradientPartnerbackground.layer.addSublayer(gradientLayer)
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
       
    } //end of loading
    

   
    
    

} //end of class
