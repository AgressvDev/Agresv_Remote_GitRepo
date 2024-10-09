//
//  NewGameViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/29/23.
//

import UIKit
import SwiftUI

class NewGameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
        
        
      
        
        //BACKGROUND
        // Create UIImageView for the background image
        let backgroundImage = UIImageView()
        
        // Set the image to "AppBackgroundOne.png" from your asset catalog
        backgroundImage.image = UIImage(named: "BackgroundCoolGreen")
        
        // Make sure the image doesn't stretch or distort
        backgroundImage.contentMode = .scaleAspectFill
        
        // Add the UIImageView as a subview to the view
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        // Disable autoresizing mask constraints for the UIImageView
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints to cover the full screen using the scaling factor
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0 * scalingFactor), // Left side of the screen
            backgroundImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0 * scalingFactor), // A little higher than the bottom
            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0 * scalingFactor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0 * scalingFactor)
        ])
        
        // Create a button "Doubles"
        let btnDoubles = createButton(title: "DOUBLES", action: #selector(btnDoublesTapped), scalingFactor: scalingFactor)
        view.addSubview(btnDoubles)
        
        // Set constraints to center and almost touch the edges
        btnDoubles.translatesAutoresizingMaskIntoConstraints = false
        btnDoubles.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnDoubles.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -45 * scalingFactor).isActive = true
        btnDoubles.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 * scalingFactor).isActive = true
        btnDoubles.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 * scalingFactor).isActive = true
        btnDoubles.heightAnchor.constraint(equalToConstant: 70 * scalingFactor).isActive = true // Adjust height as needed
        
        // Create a button "Singles"
        let btnSingles = createButton(title: "SINGLES", action: #selector(btnSinglesTapped), scalingFactor: scalingFactor)
        view.addSubview(btnSingles)
        
        // Set constraints below "btn_Doubles"
        btnSingles.translatesAutoresizingMaskIntoConstraints = false
        btnSingles.topAnchor.constraint(equalTo: btnDoubles.bottomAnchor, constant: 20 * scalingFactor).isActive = true
        btnSingles.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 * scalingFactor).isActive = true
        btnSingles.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 * scalingFactor).isActive = true
        btnSingles.heightAnchor.constraint(equalTo: btnDoubles.heightAnchor).isActive = true
    }
//                // Create a button "Singles"
//                let btnRR = createButton(title: "ROUND ROBIN", action: #selector(btnRR), scalingFactor: scalingFactor)
//                view.addSubview(btnRR)
//
//                // Set constraints below "btn_Doubles"
//                btnRR.translatesAutoresizingMaskIntoConstraints = false
//                btnRR.topAnchor.constraint(equalTo: btnSingles.bottomAnchor, constant: 20 * scalingFactor).isActive = true
//                btnRR.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 * scalingFactor).isActive = true
//                btnRR.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 * scalingFactor).isActive = true
//                btnRR.heightAnchor.constraint(equalTo: btnSingles.heightAnchor).isActive = true
//            }
        
        // Button action for "Doubles"
        @objc func btnDoublesTapped() {
             //Create an instance of DoublesSearchVCNew
            let doublesSearchVC = storyboard?.instantiateViewController(withIdentifier: "DoublesSearchVCNewID") as! DoublesSearchVCNew
            
             //Push to the DoublesSearchVCNew
            navigationController?.pushViewController(doublesSearchVC, animated: true)
        }
        
        // Button action for "Singles"
        @objc func btnSinglesTapped() {
            // Create an instance of SinglesSearchOppVC
            let singlesSearchVC = storyboard?.instantiateViewController(withIdentifier: "SinglesSearchOppVCID") as! SinglesSearchOppVC
            
            // Push to the SinglesSearchOppVC
            navigationController?.pushViewController(singlesSearchVC, animated: true)
        }
        
//            // Button action for "Doubles"
//            @objc func btnRR() {
//                // Create an instance of DoublesSearchVCNew
//                let RRVC = storyboard?.instantiateViewController(withIdentifier: "RRCreateRosterID") as! RRCreateRosterVC
//
//                // Push to the DoublesSearchVCNew
//                navigationController?.pushViewController(RRVC, animated: true)
//            }
        
        // Helper method to create a button with common properties
        func createButton(title: String, action: Selector, scalingFactor: CGFloat) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20 * scalingFactor)
            button.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0) //soft white
            button.layer.cornerRadius = 10
            button.addTarget(self, action: action, for: .touchUpInside)
            return button
        }
    }
    
