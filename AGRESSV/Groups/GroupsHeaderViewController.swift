//
//  GroupsHeaderViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/10/24.
//

import UIKit

class GroupsHeaderViewController: UIViewController {

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        // Set up the background image
        setupBackgroundImage()
        
      
    } //end of load
    

    
    private func setupBackgroundImage() {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "BackgroundCoolGreen")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)

        // Disable autoresizing mask constraints
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints to cover the full screen
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    

} //end of class
