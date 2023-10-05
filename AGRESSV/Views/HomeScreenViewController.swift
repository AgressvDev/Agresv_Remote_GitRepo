//
//  HomeScreenViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/19/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import SwiftUI
import Foundation


class HomeScreenViewController: UIViewController {
    
    
    
 
    
   

    

//
//  var MainUNLabel: UILabel!
//
//    var lbl_DoublesHeader: UILabel!
//     var lbl_SinglesHeader: UILabel!
//
//
//   var NewDoublesRankLabel: UILabel!
//   var NewSinglesRankLabel: UILabel!
//
//
//    var DW_letter: UILabel!
//    var DL_Letter: UILabel!
//
//   var SW_Letter: UILabel!
//     var SL_Letter: UILabel!
//
//
//   var DoublesWinsLabel: UILabel!
//
//    var DoublesLossesLabel: UILabel!
//
//var SinglesWinsLabel: UILabel!
//
//     var SinglesLossesLabel: UILabel!
    
    
    
 
    
 
    
    
    
    // Create a UILabel
  
           
    
    
            
    let NewDoublesRankLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.backgroundColor = UIColor.lightGray
            label.textColor = .black // Set your desired text color
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 2.0 // Set your desired border width
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let NewSinglesRankLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.backgroundColor = UIColor.lightGray
            label.textColor = .black // Set your desired text color
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 2.0 // Set your desired border width
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    
    let DW_Letter: UILabel = {
            let label = UILabel()
            label.textColor = .systemGreen // Set your desired text color
            label.text = "W:"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let DL_Letter: UILabel = {
            let label = UILabel()
            label.textColor = .systemRed // Set your desired text color
            label.text = "L:"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let SW_Letter: UILabel = {
            let label = UILabel()
            label.textColor = .systemGreen // Set your desired text color
            label.text = "W:"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let SL_Letter: UILabel = {
            let label = UILabel()
            label.textColor = .systemRed // Set your desired text color
            label.text = "L:"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let DoublesWinsLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white // Set your desired text color
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let DoublesLossesLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white // Set your desired text color
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let SinglesWinsLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white // Set your desired text color
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let SinglesLossesLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white // Set your desired text color
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let lbl_DoublesHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Impact", size: 20)
        label.text = "Doubles" // You can set your desired text
        label.textColor = .white // Set your desired text color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lbl_SinglesHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Impact", size: 20)
        label.text = "Singles" // You can set your desired text
        label.textColor = .white // Set your desired text color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let MainUNLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .black
        label.textColor = .systemRed
        label.layer.cornerRadius = 15
        label.font = UIFont(name: "Impact", size: 20) // You can adjust the font size as needed
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   


    let lbl_GamesPlayed = UILabel()
    
    let lbl_testcount = UILabel()

    
    var labelgaugecount: String = ""
    let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
  
    
    public var gaugemetercount = ""
    
    var loadingView: UIView?
    var loadingLabel: UILabel?
    
    var gaugeactualcount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call a function to show the loading view
                showLoadingView()
                
       
        
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
               backgroundImage.image = UIImage(named: "AppBackgroundOne")

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

        //END BACKGROUND
        
       
        // GAME HISTORY BUTTON
        
        // Create a UIButton with a custom type
                let imageButton = UIButton(type: .custom)
                
        // Set the frame (position and size) of the button
                imageButton.frame = CGRect(x: 50 * scalingFactor, y: 130 * scalingFactor, width: 50 * scalingFactor, height: 50 * scalingFactor) // Adjust the values for your desired position and size
                
                // Set the background image for the button
                let buttonImage = UIImage(named: "GameHistoryIconWhite.png")
                imageButton.setBackgroundImage(buttonImage, for: .normal)
                
                // Add an action to the button (what happens when it's tapped)
                imageButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
                // Add the button to the view
                view.addSubview(imageButton)
        
        
        // Create the label
        let lbl_GameHistory = UILabel()
        lbl_GameHistory.text = "History"
        lbl_GameHistory.textColor = .white
        lbl_GameHistory.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_GameHistory.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_GameHistory)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_GameHistory: CGFloat = 13.0 // Set your base font size
        let adjustedFontSize_lbl_GameHistory = baseFontSize_lbl_GameHistory * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_GameHistory.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_GameHistory)
        
        // Define Auto Layout constraints to position and scale the label
//        NSLayoutConstraint.activate([
//            lbl_Playometer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40), // Left side of the screen
//            lbl_Playometer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -280), // A little higher than the bottom
//            lbl_Playometer.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
//            lbl_Playometer.heightAnchor.constraint(equalToConstant: 30 * scalingFactor), // Adjust the reference size as needed
//        ])
        
        // Define Auto Layout constraints to position and allow the label to expand its width based on content
                NSLayoutConstraint.activate([
                    lbl_GameHistory.leadingAnchor.constraint(equalTo: imageButton.leadingAnchor, constant: 5 * scalingFactor), // Left side of the screen
                    lbl_GameHistory.bottomAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 15 * scalingFactor), // A little higher than the bottom
                ])
        
        //END GAME HISTORY BUTTON
        
        
        //LABELS and IMAGES
        
        let btn_NewGame = UIButton(type: .system)
        btn_NewGame.translatesAutoresizingMaskIntoConstraints = false
        btn_NewGame.setTitle("New Game", for: .normal)
        btn_NewGame.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn_NewGame.setTitleColor(UIColor.white, for: .normal)

        // Add an action to the button to perform a segue
        btn_NewGame.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSizeNewGame: CGFloat = 20.0 // Set your base font size
        let adjustedFontSizeNewGame = baseFontSizeNewGame * scalingFactor

        // Set the font size for lbl_Playometer
        btn_NewGame.titleLabel?.font = UIFont.systemFont(ofSize: adjustedFontSizeNewGame)
        // Add the button to the view hierarchy
        view.addSubview(btn_NewGame)
        view.bringSubviewToFront(btn_NewGame)
        
        // Load the image
        if let AgressvLogo = UIImage(named: "AgressvLogoSmallWhite.png") {
            let myImageView = UIImageView()
            myImageView.contentMode = .scaleAspectFit
            myImageView.image = AgressvLogo
            myImageView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
            
            // Add the image view to the view hierarchy
            view.addSubview(myImageView)
            
            
            
            // Define Auto Layout constraints to position and scale the image
            NSLayoutConstraint.activate([
                myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                myImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                myImageView.widthAnchor.constraint(equalToConstant: 300 * scalingFactor), // Adjust the reference size as needed
                myImageView.heightAnchor.constraint(equalToConstant: 300 * scalingFactor), // Adjust the reference size as needed
            ])
            
      
        }
        
        
        
        // Create the label
        let lbl_Playometer = UILabel()
        lbl_Playometer.text = "Playometer"
        lbl_Playometer.textColor = .white
        lbl_Playometer.font = UIFont.systemFont(ofSize: 17)
        lbl_Playometer.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_Playometer.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_Playometer)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize: CGFloat = 17.0 // Set your base font size
        let adjustedFontSize = baseFontSize * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_Playometer.font = UIFont.systemFont(ofSize: adjustedFontSize)
        
        // Define Auto Layout constraints to position and scale the label
//        NSLayoutConstraint.activate([
//            lbl_Playometer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40), // Left side of the screen
//            lbl_Playometer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -280), // A little higher than the bottom
//            lbl_Playometer.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
//            lbl_Playometer.heightAnchor.constraint(equalToConstant: 30 * scalingFactor), // Adjust the reference size as needed
//        ])
        
        // Define Auto Layout constraints to position and allow the label to expand its width based on content
                NSLayoutConstraint.activate([
                    lbl_Playometer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40 * scalingFactor), // Left side of the screen
                    lbl_Playometer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -285 * scalingFactor), // A little higher than the bottom
                    lbl_Playometer.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40 * scalingFactor), // Right side of the screen
                    lbl_Playometer.heightAnchor.constraint(equalToConstant: 30 * scalingFactor), // Adjust the reference height as needed
                ])
        
        // Set the width constraint to be greater than or equal to a minimum width
        let minWidthConstraintPlayometer = lbl_Playometer.widthAnchor.constraint(greaterThanOrEqualToConstant: 100 * scalingFactor) // Adjust the minimum width as needed
        minWidthConstraintPlayometer.priority = .defaultLow // Lower priority so that it can expand

        NSLayoutConstraint.activate([minWidthConstraintPlayometer])
        
        lbl_Playometer.layer.zPosition = 3
        
    
        
        
        // Create the label
       
        lbl_GamesPlayed.text = "Games played in rolling week:"
                lbl_GamesPlayed.textColor = .white
                lbl_GamesPlayed.numberOfLines = 0 // Allow multiple lines
                lbl_GamesPlayed.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout

                // Add the label to the view hierarchy
                view.addSubview(lbl_GamesPlayed)

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSizeGamesPlayed: CGFloat = 13.0 // Set your base font size
        let adjustedFontSizeGamesPlayed = baseFontSizeGamesPlayed * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_GamesPlayed.font = UIFont.systemFont(ofSize: adjustedFontSizeGamesPlayed)
        
        
                // Define Auto Layout constraints to position and allow the label to expand its width based on content
                NSLayoutConstraint.activate([
                    lbl_GamesPlayed.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40 * scalingFactor), // Left side of the screen
                    lbl_GamesPlayed.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -265 * scalingFactor), // A little higher than the bottom
                    lbl_GamesPlayed.heightAnchor.constraint(equalToConstant: 30 * scalingFactor), // Adjust the reference height as needed
                ])

                // Set the width constraint to be greater than or equal to a minimum width
                let minWidthConstraint = lbl_GamesPlayed.widthAnchor.constraint(greaterThanOrEqualToConstant: 100 * scalingFactor) // Adjust the minimum width as needed
                minWidthConstraint.priority = .defaultLow // Lower priority so that it can expand

                NSLayoutConstraint.activate([minWidthConstraint])
        
        
        lbl_GamesPlayed.layer.zPosition = 3
                
        
        
      
        lbl_testcount.textColor = .white
        lbl_testcount.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        
        // Add the label to the view hierarchy
        view.addSubview(lbl_testcount)
        
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSizeGaugeCount: CGFloat = 13.0 // Set your base font size
        let adjustedFontSizeGaugeCount = baseFontSizeGaugeCount * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_testcount.font = UIFont.systemFont(ofSize: adjustedFontSizeGaugeCount)
        
        
        // Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
            lbl_testcount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 230 * scalingFactor), // Left side of the screen
            lbl_testcount.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -265 * scalingFactor), // A little higher than the bottom
            lbl_testcount.heightAnchor.constraint(equalToConstant: 30 * scalingFactor), // Adjust the reference size as needed
        ])
        
        lbl_testcount.layer.zPosition = 3
  
        
        
        
        let lbl_Playmoregames = UILabel()
        lbl_Playmoregames.text = "Play more games. Be"
        lbl_Playmoregames.textColor = .white
        lbl_Playmoregames.font = UIFont.systemFont(ofSize: 12)
        lbl_Playmoregames.numberOfLines = 0 // Allow multiple lines
        lbl_Playmoregames.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout

                // Add the label to the view hierarchy
                view.addSubview(lbl_Playmoregames)

                // Define Auto Layout constraints to position and allow the label to expand its width based on content
                NSLayoutConstraint.activate([
                    lbl_Playmoregames.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150 * scalingFactor), // Left side of the screen
                    lbl_Playmoregames.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200 * scalingFactor), // A little higher than the bottom
                    lbl_Playmoregames.heightAnchor.constraint(equalToConstant: 30 * scalingFactor), // Adjust the reference height as needed
                ])

                // Set the width constraint to be greater than or equal to a minimum width
                let minWidthConstraint_playmoregames = lbl_Playmoregames.widthAnchor.constraint(greaterThanOrEqualToConstant: 100 * scalingFactor) // Adjust the minimum width as needed
        minWidthConstraint_playmoregames.priority = .defaultLow // Lower priority so that it can expand

                NSLayoutConstraint.activate([minWidthConstraint_playmoregames])
        
        
        lbl_Playmoregames.layer.zPosition = 3
        

        
      
        // Add the labels to the view hierarchy
                view.addSubview(NewDoublesRankLabel)
                view.addSubview(NewSinglesRankLabel)
                view.addSubview(DW_Letter)
                view.addSubview(DL_Letter)
                view.addSubview(SW_Letter)
                view.addSubview(SL_Letter)
                view.addSubview(DoublesWinsLabel)
                view.addSubview(DoublesLossesLabel)
                view.addSubview(SinglesWinsLabel)
                view.addSubview(SinglesLossesLabel)
                view.addSubview(lbl_DoublesHeader)
                view.addSubview(lbl_SinglesHeader)
                view.addSubview(MainUNLabel)
                view.bringSubviewToFront(btn_NewGame)
                btn_NewGame.layer.zPosition = 4
        
        if let dobermanleft = UIImage(named: "dobermanpsdleft.png") {
            let myImageViewdl = UIImageView()
            myImageViewdl.contentMode = .scaleAspectFit
            myImageViewdl.image = dobermanleft
            myImageViewdl.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout

            // Add the image view to the view hierarchy
            view.addSubview(myImageViewdl)
            view.bringSubviewToFront(myImageViewdl)

            myImageViewdl.layer.zPosition = 4
            // Define Auto Layout constraints to position and scale the image
            NSLayoutConstraint.activate([
                myImageViewdl.leadingAnchor.constraint(equalTo: MainUNLabel.leadingAnchor, constant: -20 * scalingFactor),
                myImageViewdl.bottomAnchor.constraint(equalTo: MainUNLabel.bottomAnchor, constant: -34 * scalingFactor),
                myImageViewdl.widthAnchor.constraint(equalToConstant: 120 * scalingFactor), // Adjust the reference size as needed
                myImageViewdl.heightAnchor.constraint(equalToConstant: 120 * scalingFactor), // Adjust the reference size as needed
            ])


        }
        
        if let dobermanright = UIImage(named: "dobermanpsd.png") {
            let myImageViewd2 = UIImageView()
            myImageViewd2.contentMode = .scaleAspectFit
            myImageViewd2.image = dobermanright
            myImageViewd2.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
            
            // Add the image view to the view hierarchy
            view.addSubview(myImageViewd2)
            view.bringSubviewToFront(myImageViewd2)
            
            myImageViewd2.layer.zPosition = 4
            // Define Auto Layout constraints to position and scale the image
            NSLayoutConstraint.activate([
                myImageViewd2.trailingAnchor.constraint(equalTo: MainUNLabel.trailingAnchor, constant: 20 * scalingFactor),
                myImageViewd2.bottomAnchor.constraint(equalTo: MainUNLabel.bottomAnchor, constant: -34 * scalingFactor),
                myImageViewd2.widthAnchor.constraint(equalToConstant: 120 * scalingFactor), // Adjust the reference size as needed
                myImageViewd2.heightAnchor.constraint(equalToConstant: 120 * scalingFactor), // Adjust the reference size as needed
            ])
            
      
        }
        
        if let blackcircle = UIImage(named: "blackcircle.png") {
            let blackcircleimamge = UIImageView()
            blackcircleimamge.contentMode = .scaleAspectFit
            blackcircleimamge.image = blackcircle
            blackcircleimamge.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
            
            // Add the image view to the view hierarchy
            view.addSubview(blackcircleimamge)
            
           
            // Define Auto Layout constraints to position and scale the image
            NSLayoutConstraint.activate([
                blackcircleimamge.centerXAnchor.constraint(equalTo: MainUNLabel.centerXAnchor, constant: 1 * scalingFactor),
                blackcircleimamge.bottomAnchor.constraint(equalTo: MainUNLabel.bottomAnchor, constant: -100 * scalingFactor),
                blackcircleimamge.widthAnchor.constraint(equalToConstant: 150 * scalingFactor), // Adjust the reference size as needed
                blackcircleimamge.heightAnchor.constraint(equalToConstant: 150 * scalingFactor), // Adjust the reference size as needed
            ])
            
      
        }
        
        let fontSize: CGFloat = 25.0 // Set your default font size
        let MainfontSize: CGFloat = 30.0 // Set your default font size
                lbl_SinglesHeader.font = UIFont(name: "Impact", size: fontSize * scalingFactor)
                lbl_DoublesHeader.font = UIFont(name: "Impact", size: fontSize * scalingFactor)
                MainUNLabel.font = UIFont(name: "Impact", size: MainfontSize * scalingFactor)
        
        // Set the size of the labels to be 80x80 and scale based on the screen size
                let labelSize: CGFloat = 80.0
                let xOffsetPercent: CGFloat = 0.22 // Default values (larger screens)
               
            
        
        // Create Auto Layout constraints for the button's position and size
                NSLayoutConstraint.activate([
                    btn_NewGame.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    btn_NewGame.bottomAnchor.constraint(equalTo: MainUNLabel.topAnchor, constant: -75 * scalingFactor)
               
                ])
               
        
        
        
        
        // Create a constraint to position the label horizontally (x percent away from the edges)
                let marginPercentage: CGFloat = 0.07 // Adjust this value as needed
                NSLayoutConstraint.activate([
                    MainUNLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
                    MainUNLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
                    MainUNLabel.heightAnchor.constraint(equalToConstant: 80 * scalingFactor), // Adjust the height as needed
                ])

                // Position the label above the NewDoublesRankLabel
                NSLayoutConstraint.activate([
                    MainUNLabel.bottomAnchor.constraint(equalTo: NewDoublesRankLabel.topAnchor, constant: -45 * scalingFactor), // Adjust the vertical spacing as needed
                ])
        
//        // Define the initial width, height, and edge percentages
//        var initialWidth: CGFloat = 365 // Set your initial width
//        var initialHeight: CGFloat = 80.0  // Set your initial height
//
//        // Calculate the adjusted size based on the scalingFactor
//            var adjustedWidth = initialWidth * widthScalingFactor
//            var adjustedHeight = initialHeight * heightScalingFactor
//
//        if scalingFactor <= 0.95 {
//
//            initialWidth = 365
//            initialHeight = 80
//
//             adjustedWidth = initialWidth * widthScalingFactor
//             adjustedHeight = initialHeight * heightScalingFactor
            
           
//            // Set the initial width and height of MainUNLabel
//            NSLayoutConstraint.activate([
//                    MainUNLabel.widthAnchor.constraint(equalToConstant: adjustedWidth),
//                    MainUNLabel.heightAnchor.constraint(equalToConstant: adjustedHeight),
//                    MainUNLabel.centerXAnchor.constraint(equalTo: NewSinglesRankLabel.centerXAnchor, constant: -130  * scalingFactor ),
//                    MainUNLabel.topAnchor.constraint(equalTo: NewSinglesRankLabel.bottomAnchor, constant: -200  * scalingFactor)
//
//            ])
//        }
//
//
//        // Set the initial width and height of MainUNLabel
//        NSLayoutConstraint.activate([
//                MainUNLabel.widthAnchor.constraint(equalToConstant: adjustedWidth),
//                MainUNLabel.heightAnchor.constraint(equalToConstant: adjustedHeight),
//                MainUNLabel.centerXAnchor.constraint(equalTo: NewSinglesRankLabel.centerXAnchor, constant: -95  * scalingFactor),
//                MainUNLabel.topAnchor.constraint(equalTo: NewSinglesRankLabel.bottomAnchor, constant: -220 * scalingFactor)
//
//        ])
        
                NSLayoutConstraint.activate([
                    // Position NewDoublesRankLabel to the left of the center by a certain percentage
                    NewDoublesRankLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.bounds.width * xOffsetPercent * scalingFactor),
                    
                    // Position NewDoublesRankLabel to be a certain percentage from the bottom
                    NewDoublesRankLabel.bottomAnchor.constraint(equalTo: lbl_Playometer.bottomAnchor, constant: -150 * scalingFactor),
                    
                    // Set the width and height of NewDoublesRankLabel
                    NewDoublesRankLabel.widthAnchor.constraint(equalToConstant: labelSize * scalingFactor),
                    NewDoublesRankLabel.heightAnchor.constraint(equalToConstant: labelSize * scalingFactor),
                    
                    lbl_SinglesHeader.centerXAnchor.constraint(equalTo: NewSinglesRankLabel.centerXAnchor, constant: -3 * scalingFactor),
                    lbl_SinglesHeader.topAnchor.constraint(equalTo: NewSinglesRankLabel.bottomAnchor, constant: -115 * scalingFactor),
                    
                    lbl_DoublesHeader.centerXAnchor.constraint(equalTo: NewDoublesRankLabel.centerXAnchor, constant: -3 * scalingFactor),
                    lbl_DoublesHeader.topAnchor.constraint(equalTo: NewDoublesRankLabel.bottomAnchor, constant: -115 * scalingFactor),
                    
                    // Position DW_Letter a certain percentage lower than NewDoublesRankLabel
                                DW_Letter.centerXAnchor.constraint(equalTo: NewDoublesRankLabel.centerXAnchor, constant: -22 * scalingFactor),
                                DW_Letter.topAnchor.constraint(equalTo: NewDoublesRankLabel.bottomAnchor, constant: 30 * scalingFactor),
                    
                    DoublesWinsLabel.centerXAnchor.constraint(equalTo: NewDoublesRankLabel.centerXAnchor, constant: 9 * scalingFactor),
                    DoublesWinsLabel.topAnchor.constraint(equalTo: NewDoublesRankLabel.bottomAnchor, constant: 30 * scalingFactor),
                    
                    // Position DW_Letter a certain percentage lower than NewDoublesRankLabel
                                DL_Letter.centerXAnchor.constraint(equalTo: NewDoublesRankLabel.centerXAnchor, constant: -22 * scalingFactor),
                                DL_Letter.topAnchor.constraint(equalTo: NewDoublesRankLabel.bottomAnchor, constant: 70 * scalingFactor),
                    
                    DoublesLossesLabel.centerXAnchor.constraint(equalTo: NewDoublesRankLabel.centerXAnchor, constant: 9 * scalingFactor),
                    DoublesLossesLabel.topAnchor.constraint(equalTo: NewDoublesRankLabel.bottomAnchor, constant: 70 * scalingFactor),
                   
                    // Position DW_Letter a certain percentage lower than NewDoublesRankLabel
                                SW_Letter.centerXAnchor.constraint(equalTo: NewSinglesRankLabel.centerXAnchor, constant: -22 * scalingFactor),
                                SW_Letter.topAnchor.constraint(equalTo: NewSinglesRankLabel.bottomAnchor, constant: 30 * scalingFactor),
                    
                    SinglesWinsLabel.centerXAnchor.constraint(equalTo: NewSinglesRankLabel.centerXAnchor, constant: 9 * scalingFactor),
                    SinglesWinsLabel.topAnchor.constraint(equalTo: NewSinglesRankLabel.bottomAnchor, constant: 30 * scalingFactor),
                    
                    
                    // Position DW_Letter a certain percentage lower than NewDoublesRankLabel
                                SL_Letter.centerXAnchor.constraint(equalTo: NewSinglesRankLabel.centerXAnchor, constant: -22 * scalingFactor),
                                SL_Letter.topAnchor.constraint(equalTo: NewSinglesRankLabel.bottomAnchor, constant: 70 * scalingFactor),
                    
                    SinglesLossesLabel.centerXAnchor.constraint(equalTo: NewSinglesRankLabel.centerXAnchor, constant: 9 * scalingFactor),
                    SinglesLossesLabel.topAnchor.constraint(equalTo: NewSinglesRankLabel.bottomAnchor, constant: 70 * scalingFactor),
                    
                    // Position NewSinglesRankLabel to the right of the center by the same percentage
                    NewSinglesRankLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width * xOffsetPercent * scalingFactor),
                    
                    // Position NewSinglesRankLabel to be a certain percentage from the bottom
                    NewSinglesRankLabel.bottomAnchor.constraint(equalTo: lbl_Playometer.bottomAnchor, constant: -150 * scalingFactor),
                    
                    // Set the width and height of NewSinglesRankLabel
                    NewSinglesRankLabel.widthAnchor.constraint(equalToConstant: labelSize * scalingFactor),
                    NewSinglesRankLabel.heightAnchor.constraint(equalToConstant: labelSize * scalingFactor)
                ])
               
//        NewDoublesRankLabel.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
//
//                // Add the label to the view hierarchy
//                view.addSubview(NewDoublesRankLabel)
//
//        // Define Auto Layout constraints to set the frame and scale the label
//                NSLayoutConstraint.activate([
//                    NewDoublesRankLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80 * scalingFactor),
//                    NewDoublesRankLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -500 * scalingFactor),
//                    NewDoublesRankLabel.widthAnchor.constraint(equalToConstant: 80 * scalingFactor),
//                    NewDoublesRankLabel.heightAnchor.constraint(equalToConstant: 80 * scalingFactor),
//                ])
//
//
//
//
//        NewDoublesRankLabel.layer.zPosition = 2
//
//        NewSinglesRankLabel.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
//
//                // Add the label to the view hierarchy
//                view.addSubview(NewSinglesRankLabel)
//
//
//        // Define Auto Layout constraints to position NewSinglesRankLabel to the right of NewDoublesRankLabel with increased spacing
//        let spacing: CGFloat = 100 * scalingFactor // Increase the spacing here
//
//        NSLayoutConstraint.activate([
//            // Align the top of NewSinglesRankLabel with the top of NewDoublesRankLabel
//            NewSinglesRankLabel.topAnchor.constraint(equalTo: NewDoublesRankLabel.topAnchor),
//
//            // Set the leading (left) edge of NewSinglesRankLabel to the trailing (right) edge of NewDoublesRankLabel with increased spacing
//            NewSinglesRankLabel.leadingAnchor.constraint(equalTo: NewDoublesRankLabel.trailingAnchor, constant: spacing),
//
//            // Set the width and height of NewSinglesRankLabel
//            NewSinglesRankLabel.widthAnchor.constraint(equalToConstant: 80 * scalingFactor),
//            NewSinglesRankLabel.heightAnchor.constraint(equalToConstant: 80 * scalingFactor),
//
//            // Align the bottom of NewSinglesRankLabel with the bottom of NewDoublesRankLabel
//            NewSinglesRankLabel.bottomAnchor.constraint(equalTo: NewDoublesRankLabel.bottomAnchor),
//        ])
//
//
//
//
//
//        NewSinglesRankLabel.layer.zPosition = 2
        
        
        //ADD GAUGE / PLAYOMETER

        func currentcountforgauge() {
            // Reference to Firestore collection

            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email


            let query = db.collection("Agressv_Games").whereFilter(Filter.andFilter([
                Filter.whereField("Game_Date", isGreaterOrEqualTo: CurrentDateMinus7!),
                Filter.orFilter([
                    Filter.whereField("Game_Creator", isEqualTo: uid!),
                    Filter.whereField("Game_Opponent_One", isEqualTo: uid!),
                    Filter.whereField("Game_Opponent_Two", isEqualTo: uid!),
                    Filter.whereField("Game_Partner", isEqualTo: uid!)

                ])
            ]))



            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    return
                }
                else {

                    let count = querySnapshot?.documents.count ?? 0


                    self.labelgaugecount = String(count)
                    //self.lbl_testcount.frame.origin = CGPoint(x:225, y:612)
                    //self.lbl_testcount.textColor = UIColor.systemGray
                    //self.lbl_testcount.font = UIFont.systemFont(ofSize: 12)
                    self.lbl_testcount.text = self.labelgaugecount
                    self.gaugeactualcount = count
                    self.gaugemetercount = String(count)
                    let vc = UIHostingController(rootView: GaugeView(currentValue: self.gaugemetercount))

                        let swiftuiView_gauge = vc.view!
                        swiftuiView_gauge.translatesAutoresizingMaskIntoConstraints = false
                    
                    
                            //let screenSize = UIScreen.main.bounds.size
                    
//                    // Calculate the x and y coordinates based on the screen size
//                            let screenWidth = screenSize.width
//                            let screenHeight = screenSize.height
                            
//                            // Calculate the x and y coordinates as a percentage of the screen size
//                            let xCoordinate = screenWidth * 0.05 // 25% of the screen width
//                            let yCoordinate = screenHeight * 0.72 // 25% of the screen height
//
//                            // Calculate the width and height based on the screen width (adjust as needed)
//                            let frameWidth = screenWidth * 0.90 // 50% of the screen width
//                            let frameHeight = frameWidth * 0.01 // Maintain an aspect ratio (adjust as needed)
//
                    
                    
                        //swiftuiView_gauge.frame.size.width = 400
                   // let scaleFactorGauge: CGFloat = UIScreen.main.bounds.width / 430.0 // 375.0 is a reference width
                            
                            // Set the subview's initial frame (you can adjust this as needed)
                    //swiftuiView_gauge.frame = CGRect(x: xCoordinate, y: yCoordinate, width: frameWidth, height: frameHeight)


                        // Add the view controller to the destination view controller.
                    self.addChild(vc)
                    self.view.addSubview(swiftuiView_gauge)

                        self.view.bringSubviewToFront(swiftuiView_gauge)
                     
                    swiftuiView_gauge.layer.zPosition = 2
                    
                    
                        // Notify the child view controller that the move is complete.
                        vc.didMove(toParent: self)
                    
                    // Define Auto Layout constraints to position and allow the label to expand its width based on content
                    NSLayoutConstraint.activate([
                        swiftuiView_gauge.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 5 * scalingFactor), // Left side of the screen
                        swiftuiView_gauge.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -5 * scalingFactor), // A little higher than the bottom
                        swiftuiView_gauge.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: 690 * scalingFactor),
                        swiftuiView_gauge.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -250 * scalingFactor)
                    ])
                }
            }

        }

        //update the gauge value
        print(currentcountforgauge())


        
        
        
        
            //GET DATA

            let db = Firestore.firestore()


            func GetHomeScreenData() {
                let uid = Auth.auth().currentUser!.email
                let docRef = db.collection("Agressv_Users").document(uid!)

                docRef.getDocument { (document, error) in
                    if let err = error {
                        print("Error getting documents: \(err)")
                    } else {
                        print("\(document!.documentID) => \(String(describing: document!.data()))")

                        //Doubles Rank number to string conversion
                        let Doubles_Rank = document!.data()!["Doubles_Rank"]
                        let Doubles_Rank_As_String = String(describing: Doubles_Rank!)
                        let Int_Doubles_Rank = Double(Doubles_Rank_As_String)
                        self.NewDoublesRankLabel.text = String(format: "%.1f", Int_Doubles_Rank!)


                        //Singles Rank number to string conversion
                        let Singles_Rank = document!.data()!["Singles_Rank"]
                        let Singles_Rank_As_String = String(describing: Singles_Rank!)
                        let Int_Singles_Rank = Double(Singles_Rank_As_String)
                        self.NewSinglesRankLabel.text = String(format: "%.1f", Int_Singles_Rank!)

                        //Doubles Wins number to string conversion
                        let DoublesWins = document!.data()!["Doubles_Games_Wins"]
                        let DoublesWins_As_String = String(describing: DoublesWins!)
                        self.DoublesWinsLabel.text = DoublesWins_As_String

                        //Doubles Losses number to string conversion
                        let DoublesLosses = document!.data()!["Doubles_Games_Losses"]
                        let DoublesLosses_As_String = String(describing: DoublesLosses!)
                        self.DoublesLossesLabel.text = DoublesLosses_As_String

                        //Singles Wins number to string conversion
                        let SinglesWins = document!.data()!["Singles_Games_Wins"]
                        let SinglesWins_As_String = String(describing: SinglesWins!)
                        self.SinglesWinsLabel.text = SinglesWins_As_String

                        //Singles Losses number to string conversion
                        let SinglesLosses = document!.data()!["Singles_Games_Losses"]
                        let SinglesLosses_As_String = String(describing: SinglesLosses!)
                        self.SinglesLossesLabel.text = SinglesLosses_As_String
//
//
//
                        self.MainUNLabel.text = document!.data()!["Username"] as? String



                    }
                }
            }


            //Calls the Username function
            print(GetHomeScreenData())



            //Font aspects for Username
            //let CustomFont = UIFont(name: "Impact", size: 30)
            let usernamelabel = MainUNLabel

            //usernamelabel!.center = CGPoint(x: 200, y: 285)
            usernamelabel.textAlignment = .center
            //usernamelabel.font = CustomFont
            usernamelabel.adjustsFontSizeToFitWidth = true
            usernamelabel.backgroundColor = UIColor.black
            usernamelabel.layer.cornerRadius = 15
            usernamelabel.clipsToBounds = true
//
            //Font aspects for Doubles Rank
            let DoublesRankFont = UIFont(name: "Impact", size: 30)
            let DoublesRankLabelC = NewDoublesRankLabel

            //DoublesRankLabel!.frame.origin = CGPoint(x: 65, y: 340)
           DoublesRankLabelC.textAlignment = .center
            DoublesRankLabelC.font = DoublesRankFont
            DoublesRankLabelC.adjustsFontSizeToFitWidth = true
            DoublesRankLabelC.backgroundColor = UIColor.lightGray
            //DoublesRankLabelC.layer.borderColor = UIColor.red.cgColor
            //DoublesRankLabelC.layer.borderWidth = 2.0
            DoublesRankLabelC.layer.cornerRadius = 5
            DoublesRankLabelC.clipsToBounds = true

            //Font aspects for Singles Rank
            let SinglesRankFont = UIFont(name: "Impact", size: 30)
            let SinglesRankLabel = NewSinglesRankLabel

            //SinglesRankLabel!.center = CGPoint(x: 240, y: 465)
            SinglesRankLabel.textAlignment = .center
            SinglesRankLabel.font = SinglesRankFont
            SinglesRankLabel.adjustsFontSizeToFitWidth = true
            SinglesRankLabel.backgroundColor = UIColor.lightGray
            //SinglesRankLabel.layer.borderColor = UIColor.red.cgColor
            //SinglesRankLabel.layer.borderWidth = 2.0
            SinglesRankLabel.layer.cornerRadius = 5
            SinglesRankLabel.clipsToBounds = true

        // Create a UIColor with the desired light blueish gray color
        let lightBlueishGrayColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)
        lbl_DoublesHeader.textColor = lightBlueishGrayColor
        lbl_SinglesHeader.textColor = lightBlueishGrayColor

        DL_Letter.textColor = lightBlueishGrayColor
        SL_Letter.textColor = lightBlueishGrayColor
        MainUNLabel.textColor = lightBlueishGrayColor
        
        
       
            MainUNLabel.layer.borderColor = UIColor.white.cgColor // Border color
            MainUNLabel.layer.borderWidth = 1.0 // Border width
        
        
        
            //POSITION ALL LABELS

//            let DogLeft = UIImage(named: "dobermanpsdleft.png")
//            let DogLeftView:UIImageView = UIImageView()
//            DogLeftView.contentMode = UIView.ContentMode.scaleAspectFit
//            DogLeftView.frame.size.width = 140
//            DogLeftView.frame.size.height = 140
//            //myImageView.center = self.view.center
//            DogLeftView.center = CGPoint(x: 70, y: 200)
//            DogLeftView.image = DogLeft
//            view.addSubview(DogLeftView)
//
//            let DogRight = UIImage(named: "dobermanpsd.png")
//            let DogRightView:UIImageView = UIImageView()
//            DogRightView.contentMode = UIView.ContentMode.scaleAspectFit
//            DogRightView.frame.size.width = 140
//            DogRightView.frame.size.height = 140
//            //myImageView.center = self.view.center
//            DogRightView.center = CGPoint(x: 360, y: 200)
//            DogRightView.image = DogRight
//            view.addSubview(DogRightView)
//
//            let BlackCircle = UIImage(named: "blackcircle.png")
//            let myImageView:UIImageView = UIImageView()
//            myImageView.contentMode = UIView.ContentMode.scaleAspectFit
//            myImageView.frame.size.width = 140
//            myImageView.frame.size.height = 140
//            //myImageView.center = self.view.center
//            myImageView.center = CGPoint(x: 211, y: 160)
//            myImageView.image = BlackCircle
//            view.addSubview(myImageView)

            //btn_NewGame.frame.origin = CGPoint(x:157, y:144)
            


            //MainUNLabel.frame.origin = CGPoint(x: 30, y:240)
            //MainUNLabel.frame.size.width = 370


            //lbl_DoublesHeader.frame.origin = CGPoint(x: 65, y:320)
            //lbl_SinglesHeader.frame.origin = CGPoint(x: 285, y:320)


            //NewDoublesRankLabel.frame.origin = CGPoint(x:65, y:370)
            //NewDoublesRankLabel.frame.size.width = 80
            //NewDoublesRankLabel.frame.size.height = 80


            //NewSinglesRankLabel.frame.origin = CGPoint(x:285, y:370)
            //NewSinglesRankLabel.frame.size.width = 80
            //NewSinglesRankLabel.frame.size.height = 80


            //DW_letter.frame.origin = CGPoint(x:65, y:480)
            //DL_Letter.frame.origin = CGPoint(x:65, y:520)
            //SW_Letter.frame.origin = CGPoint(x:285, y:480)
            //SL_Letter.frame.origin = CGPoint(x:285, y:520)


//            DoublesWinsLabel.frame.origin = CGPoint(x:95, y:480)
//            DoublesLossesLabel.frame.origin = CGPoint(x:95, y:520)
//            SinglesWinsLabel.frame.origin = CGPoint(x:315, y:480)
//            SinglesLossesLabel.frame.origin = CGPoint(x:315, y:520)


            //lbl_Playometer.frame.origin = CGPoint(x:65, y:595)
            //lbl_GamesPlayed.frame.origin = CGPoint(x:65, y:615)
        

            //lbl_PlayMoreGames.frame.origin = CGPoint(x:120, y: 715)

//            let AgressvLogo = UIImage(named: "AgressvLogoSmall.png")
//            let AgressvBtmLogo:UIImageView = UIImageView()
//            AgressvBtmLogo.contentMode = UIView.ContentMode.scaleAspectFit
//            AgressvBtmLogo.frame.size.width = 350
//            AgressvBtmLogo.frame.size.height = 350
//            //myImageView.center = self.view.center
//            AgressvBtmLogo.center = CGPoint(x: 217, y: 800)
//            AgressvBtmLogo.image = AgressvLogo
//            view.addSubview(AgressvBtmLogo)
            

        
        
        // Simulate loading for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Call a function to hide the loading view
            self.hideLoadingView()
        }
        
        
    
        } //end of loading bracket
        
    
    func AddFireMessage() {
        
        //GAUGE METER MESSAGE FOR 32 GAMES AND OVER
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
                
                // Create a label
                let FireMessage = UILabel()
               
        FireMessage.textColor = .white
        FireMessage.numberOfLines = 0 // Allow multiple lines
        FireMessage.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
               
            
                // Check if gaugeactualcount is greater than or equal to 32
                if gaugeactualcount >= 32 {
                    
                    // Calculate the adjusted font size based on the scalingFactor
                    let baseFontSizeActualGaugeCount: CGFloat = 13.0 // Set your base font size
                    let adjustedFontSizeActualGaugeCount = baseFontSizeActualGaugeCount * scalingFactor
                    // Apply text attributes
                    let fireFont = UIFont.systemFont(ofSize: 16.0, weight: .bold) // Adjust the size as needed
                    
                    // Set the font size for lbl_Playometer
                    FireMessage.font = UIFont.systemFont(ofSize: adjustedFontSizeActualGaugeCount)
                    
                    let attributedText = NSMutableAttributedString(string: "You're on fire !")
                    
                    attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: 9)) // "You're on"
                    attributedText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 10, length: 4)) // "fire"
                    // Increase font size for the "fire" portion
                    attributedText.addAttribute(.font, value: fireFont, range: NSRange(location: 10, length: 4)) // "fire"
                    
                    
                    FireMessage.attributedText = attributedText
                    
                    

                   
                    
                    // Add the label as a subview to your view (e.g., yourViewController.view)
                    // Replace `yourViewController.view` with the appropriate view reference
                    self.view.addSubview(FireMessage)
                    
                    // Define Auto Layout constraints to position and scale the label
                    NSLayoutConstraint.activate([
                        FireMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 300 * scalingFactor), // Left side of the screen
                        FireMessage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -265 * scalingFactor), // A little higher than the bottom
                        FireMessage.heightAnchor.constraint(equalToConstant: 30 * scalingFactor), // Adjust the reference size as needed
                    ])
                    
                    FireMessage.layer.zPosition = 4
                }
        //END OF GAUGE MESSAGE
        
        
    }
    func showLoadingView() {
            // Create a UIView that covers the entire screen
            loadingView = UIView(frame: view.bounds)
            loadingView?.backgroundColor = .white
            
            // Create a UILabel with the desired text
            loadingLabel = UILabel()
            loadingLabel?.text = "Loading your stats..."
            loadingLabel?.textColor = .black
            loadingLabel?.translatesAutoresizingMaskIntoConstraints = false
        loadingView?.layer.zPosition = 7
        loadingView?.layer.zPosition = 7
            
            // Add the label to the loading view
            if let loadingLabel = loadingLabel {
                loadingView?.addSubview(loadingLabel)
                loadingLabel.centerXAnchor.constraint(equalTo: loadingView!.centerXAnchor).isActive = true
                loadingLabel.centerYAnchor.constraint(equalTo: loadingView!.centerYAnchor).isActive = true
            }
            
            // Add the loading view to the main view controller
            if let loadingView = loadingView {
                view.addSubview(loadingView)
            }
        }
        
        func hideLoadingView() {
            // Remove the loading view and label from the main view controller
            loadingLabel?.removeFromSuperview()
            loadingView?.removeFromSuperview()
            
            // Set the references to nil to release memory
            loadingLabel = nil
            loadingView = nil
            
            AddFireMessage()
        }
       


    @objc func startNewGame() {
        // Create an instance of opp two VC
        let DoublesOrSinglesVC = storyboard?.instantiateViewController(withIdentifier: "DoublesORSinglesID") as! NewGameViewController
        
        // Push to the SecondViewController
        navigationController?.pushViewController(DoublesOrSinglesVC, animated: true)
        }
    
    
    @objc func buttonTapped() {
        // Create an instance of opp two VC
        let GameHistoryVC = storyboard?.instantiateViewController(withIdentifier: "GameHistoryID") as! GameHistoryViewController
        
        // Push to the SecondViewController
        navigationController?.pushViewController(GameHistoryVC, animated: true)
        }
    
    
    } //end of class
    
    
    
    
    
    
    

