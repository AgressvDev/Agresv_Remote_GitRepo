//
//  BadgesViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/23/23.
//

import UIKit

class BadgesViewController: UIViewController {

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
               backgroundImage.image = UIImage(named: "ChampBackgroundBlur")

               // Make sure the image doesn't stretch or distort
               backgroundImage.contentMode = .scaleAspectFill

               // Add the UIImageView as a subview to the view
               view.addSubview(backgroundImage)
               view.sendSubviewToBack(backgroundImage)

               // Disable autoresizing mask constraints for the UIImageView
               backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        

               // Set constraints to cover the full screen using the scaling factor
        // Define Auto Layout constraints to position and allow the label to expand its width based on content
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0 * scalingFactor), // Left side of the screen
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0 * scalingFactor), // A little higher than the bottom
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0 * scalingFactor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0 * scalingFactor)
        ])
        
        
        
        let goldRibbon = UIImageView()
        goldRibbon.image = UIImage(named: "GoldRibbon") // Replace with the actual image name
        goldRibbon.translatesAutoresizingMaskIntoConstraints = false
        goldRibbon.contentMode = .scaleAspectFit // Adjust the content mode as needed
        view.addSubview(goldRibbon)
        
        
        
        //Define Auto Layout constraints to position and scale the label
       NSLayoutConstraint.activate([
          
        goldRibbon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70 * scalingFactor),
        goldRibbon.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40 * scalingFactor),
        goldRibbon.widthAnchor.constraint(equalToConstant: 60 * scalingFactor), // Adjust the reference size as needed
        goldRibbon.heightAnchor.constraint(equalToConstant: 60 * scalingFactor) // Adjust the reference size as needed
       ])
        
        // Create the label
        let lbl_goldRibbon = UILabel()
        lbl_goldRibbon.text = "The Golden Ribbon. Player is top ranked in both Doubles and Singles."
        lbl_goldRibbon.textColor = .black
        lbl_goldRibbon.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_goldRibbon.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_goldRibbon)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize: CGFloat = 12.0 // Set your base font size
        let adjustedFontSize = baseFontSize * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_goldRibbon.font = UIFont.systemFont(ofSize: adjustedFontSize)
        

        
        // Existing constraints for lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_goldRibbon.leadingAnchor.constraint(equalTo: goldRibbon.trailingAnchor, constant: 40 * scalingFactor),
            lbl_goldRibbon.topAnchor.constraint(equalTo: goldRibbon.topAnchor)
        ])

        // Add new constraints for limiting the width of lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_goldRibbon.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20 * scalingFactor), // Limit the trailing edge to some margin from the right of the view.
            lbl_goldRibbon.bottomAnchor.constraint(lessThanOrEqualTo: goldRibbon.bottomAnchor), // Allow the label to wrap based on content up to the goldRibbon's bottom anchor.
            lbl_goldRibbon.widthAnchor.constraint(lessThanOrEqualToConstant: 170) // Set a maximum width (adjust the constant as needed).
        ])
        
        
        
        
        let blueRibbon = UIImageView()
        blueRibbon.image = UIImage(named: "BlueRibbon") // Replace with the actual image name
        blueRibbon.translatesAutoresizingMaskIntoConstraints = false
        blueRibbon.contentMode = .scaleAspectFit // Adjust the content mode as needed
        view.addSubview(blueRibbon)
        
        
        
        //Define Auto Layout constraints to position and scale the label
       NSLayoutConstraint.activate([
          
        blueRibbon.topAnchor.constraint(equalTo: goldRibbon.bottomAnchor, constant: 25 * scalingFactor),
        blueRibbon.leadingAnchor.constraint(equalTo: goldRibbon.leadingAnchor),
        blueRibbon.widthAnchor.constraint(equalToConstant: 60 * scalingFactor), // Adjust the reference size as needed
        blueRibbon.heightAnchor.constraint(equalToConstant: 60 * scalingFactor) // Adjust the reference size as needed
       ])
        
        // Create the label
        let lbl_blueRibbon = UILabel()
        lbl_blueRibbon.text = "The Blue Ribbon. Player is top ranked in either Doubles or Singles."
        lbl_blueRibbon.textColor = .black
        lbl_blueRibbon.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_blueRibbon.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_blueRibbon)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_blueRibbon: CGFloat = 12.0 // Set your base font size
        let adjustedFontSize_lbl_blueRibbon = baseFontSize_lbl_blueRibbon * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_blueRibbon.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_blueRibbon)
        

        
        // Existing constraints for lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_blueRibbon.leadingAnchor.constraint(equalTo: blueRibbon.trailingAnchor, constant: 40 * scalingFactor),
            lbl_blueRibbon.topAnchor.constraint(equalTo: blueRibbon.topAnchor)
        ])

        // Add new constraints for limiting the width of lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_blueRibbon.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20 * scalingFactor), // Limit the trailing edge to some margin from the right of the view.
            lbl_blueRibbon.bottomAnchor.constraint(lessThanOrEqualTo: blueRibbon.bottomAnchor), // Allow the label to wrap based on content up to the goldRibbon's bottom anchor.
            lbl_blueRibbon.widthAnchor.constraint(lessThanOrEqualToConstant: 170) // Set a maximum width (adjust the constant as needed).
        ])
        
        
        
        
        
        
        
        let RedFangs = UIImageView()
        RedFangs.image = UIImage(named: "RedFangs") // Replace with the actual image name
        RedFangs.translatesAutoresizingMaskIntoConstraints = false
        RedFangs.contentMode = .scaleAspectFit // Adjust the content mode as needed
        view.addSubview(RedFangs)
        
        
        
        //Define Auto Layout constraints to position and scale the label
       NSLayoutConstraint.activate([
          
        RedFangs.topAnchor.constraint(equalTo: blueRibbon.bottomAnchor, constant: 25 * scalingFactor),
        RedFangs.leadingAnchor.constraint(equalTo: goldRibbon.leadingAnchor),
        RedFangs.widthAnchor.constraint(equalToConstant: 60 * scalingFactor), // Adjust the reference size as needed
        RedFangs.heightAnchor.constraint(equalToConstant: 60 * scalingFactor) // Adjust the reference size as needed
       ])
        
        
        
        // Create the label
        let lbl_RedFangs = UILabel()
        lbl_RedFangs.text = "The Red Fangs. Player is considered most agressive, has logged the highest number of games in rolling 30 days."
        lbl_RedFangs.textColor = .black
        lbl_RedFangs.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_RedFangs.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_RedFangs)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_RedFangs: CGFloat = 12.0 // Set your base font size
        let adjustedFontSize_RedFangs = baseFontSize_RedFangs * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_RedFangs.font = UIFont.systemFont(ofSize: adjustedFontSize_RedFangs)
        

        
        // Existing constraints for lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_RedFangs.leadingAnchor.constraint(equalTo: RedFangs.trailingAnchor, constant: 40 * scalingFactor),
            lbl_RedFangs.topAnchor.constraint(equalTo: RedFangs.topAnchor)
        ])

        // Add new constraints for limiting the width of lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_RedFangs.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20 * scalingFactor), // Limit the trailing edge to some margin from the right of the view.
            lbl_RedFangs.bottomAnchor.constraint(lessThanOrEqualTo: RedFangs.bottomAnchor), // Allow the label to wrap based on content up to the goldRibbon's bottom anchor.
            lbl_RedFangs.widthAnchor.constraint(lessThanOrEqualToConstant: 200) // Set a maximum width (adjust the constant as needed).
        ])
        
        
        // Set corner radius for all buttons and add a square border
        let cornerRadius: CGFloat = 15
        goldRibbon.layer.cornerRadius = cornerRadius
        goldRibbon.layer.borderWidth = 1
        goldRibbon.layer.borderColor = UIColor.white.cgColor

        blueRibbon.layer.cornerRadius = cornerRadius
        blueRibbon.layer.borderWidth = 1
        blueRibbon.layer.borderColor = UIColor.white.cgColor

        RedFangs.layer.cornerRadius = cornerRadius
        RedFangs.layer.borderWidth = 1
        RedFangs.layer.borderColor = UIColor.white.cgColor


        // Set the background color to teal blue
        goldRibbon.backgroundColor = .white
        blueRibbon.backgroundColor = .white
        RedFangs.backgroundColor = .white
       
        
        
        
    } //end of load
    

    
    
    
    
    

} //end of class
