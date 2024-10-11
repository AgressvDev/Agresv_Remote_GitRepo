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

        
        
        // Create the label
               let lbl_Groups = UILabel()
               lbl_Groups.text = "Groups"
               lbl_Groups.textColor = .white
               lbl_Groups.font = UIFont.boldSystemFont(ofSize: 25) // Set the desired font size
               lbl_Groups.translatesAutoresizingMaskIntoConstraints = false
               
               // Add the label to the view
               view.addSubview(lbl_Groups)
               
               // Set constraints to position the label at the top left
               NSLayoutConstraint.activate([
                   lbl_Groups.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                   lbl_Groups.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25)
               ])
        
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
