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
    
    
    
 
    
   

    var HasAchievedGoldRibbon: Bool = false
    var HasAchievedBlueRibbon: Bool = false
    var HasAchievedRedFangs: Bool = false

 
    var Highest_Score_Doubles: Double = 0.0
    var Highest_Score_Singles: Double = 0.0
    var Player_DoublesRank: Double = 0.0
    var Player_SinglesRank: Double = 0.0
    
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
                
       
//        func deleteDocumentsInCollection() {
//            let db = Firestore.firestore()
//            let collectionReference = db.collection("Agressv_Games")
//            let query = collectionReference.whereField("Game_Creator", isEqualTo: "staygold@gmail.com")
//
//            query.getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    print("Error getting documents: \(error)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let documentRef = collectionReference.document(document.documentID)
//                        documentRef.delete { error in
//                            if let error = error {
//                                print("Error deleting document: \(error)")
//                            } else {
//                                print("Document successfully deleted.")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        print(deleteDocumentsInCollection())
        
    

     

        
        
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
        let marginPercentage: CGFloat = 0.07
        let IconsPercentage: CGFloat = 2.10
     
    
        // Create buttons with actions and images
               let settingsButton = createButton(withImageName: "SettingsIconWhite")
               settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)

               let historyButton = createButton(withImageName: "GameHistoryIconWhite")
               historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)

               let badgesButton = createButton(withImageName: "BadgesIcon")
               badgesButton.addTarget(self, action: #selector(badgesButtonTapped), for: .touchUpInside)

               let newGameButton = createButton(withImageName: "NewGameIconWhite")
               newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)

               // Add buttons to the view
               view.addSubview(settingsButton)
               view.addSubview(historyButton)
               view.addSubview(badgesButton)
               view.addSubview(newGameButton)

        // Define layout guides for the leading and trailing edges
                let leadingGuide = UILayoutGuide()
                let trailingGuide = UILayoutGuide()
                view.addLayoutGuide(leadingGuide)
                view.addLayoutGuide(trailingGuide)
        
       


               // Set corner radius for all buttons and add a square border
               let cornerRadius: CGFloat = 15
               settingsButton.layer.cornerRadius = cornerRadius
               settingsButton.layer.borderWidth = 1
               settingsButton.layer.borderColor = UIColor.white.cgColor

               historyButton.layer.cornerRadius = cornerRadius
               historyButton.layer.borderWidth = 1
               historyButton.layer.borderColor = UIColor.white.cgColor

               badgesButton.layer.cornerRadius = cornerRadius
               badgesButton.layer.borderWidth = 1
               badgesButton.layer.borderColor = UIColor.white.cgColor

               newGameButton.layer.cornerRadius = cornerRadius
               newGameButton.layer.borderWidth = 1
               newGameButton.layer.borderColor = UIColor.white.cgColor

               // Set the background color to teal blue
               settingsButton.backgroundColor = UIColor(red: 0, green: 142/255, blue: 184/255, alpha: 1) // Teal blue
               historyButton.backgroundColor = UIColor(red: 0, green: 142/255, blue: 184/255, alpha: 1) // Teal blue
               badgesButton.backgroundColor = UIColor(red: 0, green: 142/255, blue: 184/255, alpha: 1) // Teal blue
               newGameButton.backgroundColor = UIColor(red: 0, green: 142/255, blue: 184/255, alpha: 1) // Teal blue
           
        // Adjust the image size within the buttons
                settingsButton.imageView?.contentMode = .scaleAspectFit
                historyButton.imageView?.contentMode = .scaleAspectFit
                badgesButton.imageView?.contentMode = .scaleAspectFit
                newGameButton.imageView?.contentMode = .scaleAspectFit
        
  
        
    func createButton(withImageName imageName: String) -> UIButton {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let image = UIImage(named: imageName) // Load the image from the asset catalog
            button.setImage(image, for: .normal)
            return button
        }
        
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
//                view.bringSubviewToFront(btn_NewGame)
//                btn_NewGame.layer.zPosition = 4
        
        
        
        
       
        
        let dobermanleft = UIImage(named: "DogLfilled.png")
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


        
        
        let dobermanright = UIImage(named: "DogRfilled.png")
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
            
      
        
        
        NSLayoutConstraint.activate([
                    // Position the "Settings" button
                    settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5 * scalingFactor),
                    settingsButton.leadingAnchor.constraint(equalTo: MainUNLabel.leadingAnchor, constant: 10 * scalingFactor),
                    settingsButton.widthAnchor.constraint(equalToConstant: 65 * scalingFactor),
                    settingsButton.heightAnchor.constraint(equalToConstant: 65 * scalingFactor),

                    // Position the "History" button
                    historyButton.topAnchor.constraint(equalTo: settingsButton.topAnchor),
                    historyButton.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: 15 * IconsPercentage),
                    historyButton.widthAnchor.constraint(equalToConstant: 65 * scalingFactor),
                    historyButton.heightAnchor.constraint(equalToConstant: 65 * scalingFactor),

                    // Position the "Badges" button
                    badgesButton.topAnchor.constraint(equalTo: settingsButton.topAnchor),
                    badgesButton.trailingAnchor.constraint(equalTo: newGameButton.leadingAnchor, constant: -15 * IconsPercentage),
                    badgesButton.widthAnchor.constraint(equalToConstant: 65 * scalingFactor),
                    badgesButton.heightAnchor.constraint(equalToConstant: 65 * scalingFactor),

                    // Position the "NewGame" button
                    newGameButton.topAnchor.constraint(equalTo: settingsButton.topAnchor),
                    //newGameButton.leadingAnchor.constraint(equalTo: badgesButton.trailingAnchor, constant: 20 * scalingFactor),
                    newGameButton.trailingAnchor.constraint(equalTo: MainUNLabel.trailingAnchor, constant: -10 * scalingFactor),
                    newGameButton.widthAnchor.constraint(equalToConstant: 65 * scalingFactor),
                    newGameButton.heightAnchor.constraint(equalToConstant: 65 * scalingFactor)
                ])
        


//
//
        // Create the label
        let lbl_NewGame = UILabel()
        lbl_NewGame.text = "New Game"
        lbl_NewGame.textColor = .white
        lbl_NewGame.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_NewGame.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_NewGame)

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_NewGame: CGFloat = 10.0 // Set your base font size
        let adjustedFontSize_lbl_NewGame = baseFontSize_lbl_NewGame * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_NewGame.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_NewGame)
//
         //Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
           
            lbl_NewGame.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 3 * scalingFactor),
            lbl_NewGame.leadingAnchor.constraint(equalTo: newGameButton.leadingAnchor, constant: 5 * scalingFactor),
            lbl_NewGame.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
            lbl_NewGame.heightAnchor.constraint(equalToConstant: 30 * scalingFactor) // Adjust the reference size as needed
        ])
        
        
        // Create the label
        let lbl_Settings = UILabel()
        lbl_Settings.text = "Settings"
        lbl_Settings.textColor = .white
        lbl_Settings.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_Settings.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_Settings)

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_Settings: CGFloat = 10.0 // Set your base font size
        let adjustedFontSize_lbl_Settings = baseFontSize_lbl_Settings * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_Settings.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_Settings)
//
         //Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
           
            lbl_Settings.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 3 * scalingFactor),
            lbl_Settings.leadingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: 10 * scalingFactor),
            lbl_Settings.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
            lbl_Settings.heightAnchor.constraint(equalToConstant: 30 * scalingFactor) // Adjust the reference size as needed
        ])
        
        // Create the label
        let lbl_History = UILabel()
        lbl_History.text = "History"
        lbl_History.textColor = .white
        lbl_History.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_History.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_History)

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_History: CGFloat = 10.0 // Set your base font size
        let adjustedFontSize_lbl_History = baseFontSize_lbl_History * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_History.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_History)
//
         //Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
           
            lbl_History.topAnchor.constraint(equalTo: historyButton.bottomAnchor, constant: 3 * scalingFactor),
            lbl_History.leadingAnchor.constraint(equalTo: historyButton.leadingAnchor, constant: 15 * scalingFactor),
            lbl_History.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
            lbl_History.heightAnchor.constraint(equalToConstant: 30 * scalingFactor) // Adjust the reference size as needed
        ])
        
        // Create the label
        let lbl_Badges = UILabel()
        lbl_Badges.text = "Badges"
        lbl_Badges.textColor = .white
        lbl_Badges.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_Badges.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_Badges)

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_Badges: CGFloat = 10.0 // Set your base font size
        let adjustedFontSize_lbl_Badges = baseFontSize_lbl_Badges * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_Badges.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_Badges)
//
         //Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
           
            lbl_Badges.topAnchor.constraint(equalTo: badgesButton.bottomAnchor, constant: 3 * scalingFactor),
            lbl_Badges.leadingAnchor.constraint(equalTo: badgesButton.leadingAnchor, constant: 15 * scalingFactor),
            lbl_Badges.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
            lbl_Badges.heightAnchor.constraint(equalToConstant: 30 * scalingFactor) // Adjust the reference size as needed
        ])
//


        
        let fontSize: CGFloat = 25.0 // Set your default font size
        let MainfontSize: CGFloat = 30.0 // Set your default font size
                lbl_SinglesHeader.font = UIFont(name: "Impact", size: fontSize * scalingFactor)
                lbl_DoublesHeader.font = UIFont(name: "Impact", size: fontSize * scalingFactor)
                MainUNLabel.font = UIFont(name: "Impact", size: MainfontSize * scalingFactor)
        
        // Set the size of the labels to be 80x80 and scale based on the screen size
                let labelSize: CGFloat = 80.0
                let xOffsetPercent: CGFloat = 0.22 // Default values (larger screens)
               
            
        

        
        
        
        
        // Create a constraint to position the label horizontally (x percent away from the edges)
             
                NSLayoutConstraint.activate([
                    MainUNLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
                    MainUNLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
                    MainUNLabel.heightAnchor.constraint(equalToConstant: 80 * scalingFactor), // Adjust the height as needed
                ])

                // Position the label above the NewDoublesRankLabel
                NSLayoutConstraint.activate([
                    MainUNLabel.bottomAnchor.constraint(equalTo: NewDoublesRankLabel.topAnchor, constant: -45 * scalingFactor), // Adjust the vertical spacing as needed
                ])
        


        
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
                        let rounded_int_doubles_rank = round(Int_Doubles_Rank! * 10) / 10.0
                        self.Player_DoublesRank = rounded_int_doubles_rank

                        //Singles Rank number to string conversion
                        let Singles_Rank = document!.data()!["Singles_Rank"]
                        let Singles_Rank_As_String = String(describing: Singles_Rank!)
                        let Int_Singles_Rank = Double(Singles_Rank_As_String)
                        self.NewSinglesRankLabel.text = String(format: "%.1f", Int_Singles_Rank!)
                        let rounded_int_singles_rank = round(Int_Singles_Rank! * 10) / 10.0
                        self.Player_SinglesRank = rounded_int_singles_rank
                        
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
        
        
        
           //change Dogs to Gold if player is Ranked #1 and add Label "You are a Golden Dog, currently ranked #1"
        
        
        func GetHighScores() {
           
            let agressvUsersRef = db.collection("Agressv_Users")
          

            // Query to get the documents with max Doubles_Rank and max Singles_Rank
            agressvUsersRef
                .order(by: "Doubles_Rank", descending: true)
                .limit(to: 1)
                .getDocuments { (doublesRankQuerySnapshot, error) in
                    if let err = error {
                        print("Error getting documents: \(err)")
                    } else {
                        let maxDoublesRank = doublesRankQuerySnapshot?.documents.first?["Doubles_Rank"] as? Double
                        let roundedValue = round(maxDoublesRank! * 10) / 10.0
                        
                        
                        self.Highest_Score_Doubles = roundedValue
                        print(self.Highest_Score_Doubles)
                        // Query to get the documents with max Singles_Rank
                        agressvUsersRef
                            .order(by: "Singles_Rank", descending: true)
                            .limit(to: 1)
                            .getDocuments { (singlesRankQuerySnapshot, error) in
                                if let err = error {
                                    print("Error getting documents: \(err)")
                                } else {
                                    let maxSinglesRank = singlesRankQuerySnapshot?.documents.first?["Singles_Rank"] as? Double
                                    let roundedValueSingles = round(maxSinglesRank! * 10) / 10.0
                                    
                                    self.Highest_Score_Singles = roundedValueSingles
                                    print(self.Highest_Score_Singles)
                                    
                                    
                                    
                                    // Now you have the highest score in the variable Highest_Score
                                    if self.Highest_Score_Doubles > 8.5 {
                                        if
                                            self.Player_DoublesRank == self.Highest_Score_Doubles
                                        {
                                            print("HIGHEST SCORE IS GREATER THAN 8.5 AND PLAYER IS IT SO GOLDEN DOG!!!!!")
                                            myImageViewdl.image = UIImage(named: "DogLfilledGolden.png")
                                            let customMustardYellow = UIColor.mustardYellow()
                                            self.NewDoublesRankLabel.backgroundColor = customMustardYellow
                                            
                                            // Create a label
                                            let GoldenDogLabel = UILabel()
                                            
                                            // Set the label's text and font color
                                            GoldenDogLabel.text = "You are a Golden Dog,\ncurrently ranked #1 !!"
                                            GoldenDogLabel.textColor = customMustardYellow // Assuming you have defined your custom mustard yellow color
                                            
                                            // Set the font and font size
                                            let baseFontSize: CGFloat = 15.0
                                            let adjustedFontSize = baseFontSize * scalingFactor
                                            
                                            if let impactFont = UIFont(name: "Impact", size: adjustedFontSize) {
                                                GoldenDogLabel.font = impactFont
                                            } else {
                                                // Handle the case where the "Impact" font cannot be loaded (e.g., use a fallback font)
                                                GoldenDogLabel.font = UIFont.systemFont(ofSize: adjustedFontSize)
                                            }
                                            
                                            // Configure other label properties
                                            GoldenDogLabel.backgroundColor = UIColor.clear // No background
                                            GoldenDogLabel.textAlignment = .center // Center align the text
                                            GoldenDogLabel.numberOfLines = 0
                                            
                                            self.view.addSubview(GoldenDogLabel)
                                            
                                            // Add constraints to position the label and control its size
                                            GoldenDogLabel.translatesAutoresizingMaskIntoConstraints = false
                                            
                                            NSLayoutConstraint.activate([
                                                GoldenDogLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                                GoldenDogLabel.bottomAnchor.constraint(equalTo: self.MainUNLabel.topAnchor, constant: -20 * scalingFactor) // Adjust the vertical spacing as needed
                                            ])
                                            //ADD BLACK RIBBON
                                            let BlackRibbon_Doubles = UIImage(named: "BlackRibbonDoubles.png")
                                            let BlackRibbonDoubles = UIImageView()
                                            BlackRibbonDoubles.contentMode = .scaleAspectFit
                                            BlackRibbonDoubles.image = BlackRibbon_Doubles
                                            BlackRibbonDoubles.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
                                            
                                            // Add the image view to the view hierarchy
                                            self.view.addSubview(BlackRibbonDoubles)
                                            self.view.bringSubviewToFront(BlackRibbonDoubles)
                                            
                                            BlackRibbonDoubles.layer.zPosition = 5
                                            
                                            NSLayoutConstraint.activate([
                                                BlackRibbonDoubles.trailingAnchor.constraint(equalTo: self.NewDoublesRankLabel.leadingAnchor, constant: -10 * scalingFactor),
                                                BlackRibbonDoubles.centerYAnchor.constraint(equalTo: self.NewDoublesRankLabel.centerYAnchor),
                                                BlackRibbonDoubles.widthAnchor.constraint(equalToConstant: 50 * scalingFactor), // Adjust the reference size as needed
                                                BlackRibbonDoubles.heightAnchor.constraint(equalToConstant: 50 * scalingFactor), // Adjust the reference size as needed
                                            ])
                                            
                                            //Increment 1 for Blue Ribbon_Doubles in Badges table
                                            
                                        
                                        
                                        }
                                        else
                                        {
                                            print("HIGHEST SCORE IS GREATER THAN 8.5 BUUTTT PLAYER IS NOT EVALUATING TO IT")
                                        }
                                    }
                                    else
                                    {
                                        print("HIGHEST SCORE NOT EVALUATING TO > 8.5")
                                    }
                                    
                                    
                                    if self.Highest_Score_Singles > 8.5 {
                                        if
                                            self.Player_SinglesRank == self.Highest_Score_Singles
                                        {
                                            print("HIGHEST SCORE IS GREATER THAN 8.5 AND PLAYER IS IT SO GOLDEN DOG!!!!!")
                                            myImageViewd2.image = UIImage(named: "DogRfilledGolden.png")
                                            let customMustardYellow = UIColor.mustardYellow()
                                            self.NewSinglesRankLabel.backgroundColor = customMustardYellow
                                            
                                            // Create a label
                                            let GoldenDogLabel = UILabel()
                                            
                                            // Set the label's text and font color
                                            GoldenDogLabel.text = "You are a Golden Dog,\ncurrently ranked #1 !!"
                                            GoldenDogLabel.textColor = customMustardYellow // Assuming you have defined your custom mustard yellow color
                                            
                                            // Set the font and font size
                                            let baseFontSize: CGFloat = 15.0
                                            let adjustedFontSize = baseFontSize * scalingFactor
                                            
                                            if let impactFont = UIFont(name: "Impact", size: adjustedFontSize) {
                                                GoldenDogLabel.font = impactFont
                                            } else {
                                                // Handle the case where the "Impact" font cannot be loaded (e.g., use a fallback font)
                                                GoldenDogLabel.font = UIFont.systemFont(ofSize: adjustedFontSize)
                                            }
                                            
                                            // Configure other label properties
                                            GoldenDogLabel.backgroundColor = UIColor.clear // No background
                                            GoldenDogLabel.textAlignment = .center // Center align the text
                                            GoldenDogLabel.numberOfLines = 0
                                            
                                            self.view.addSubview(GoldenDogLabel)
                                            
                                            // Add constraints to position the label and control its size
                                            GoldenDogLabel.translatesAutoresizingMaskIntoConstraints = false
                                            
                                            NSLayoutConstraint.activate([
                                                GoldenDogLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                                GoldenDogLabel.bottomAnchor.constraint(equalTo: self.MainUNLabel.topAnchor, constant: -20 * scalingFactor) // Adjust the vertical spacing as needed
                                            ])
                                            //ADD BLACK RIBBON
                                            let BlackRibbon_Doubles = UIImage(named: "BlackRibbonSingles.png")
                                            let BlackRibbonDoubles = UIImageView()
                                            BlackRibbonDoubles.contentMode = .scaleAspectFit
                                            BlackRibbonDoubles.image = BlackRibbon_Doubles
                                            BlackRibbonDoubles.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
                                            
                                            // Add the image view to the view hierarchy
                                            self.view.addSubview(BlackRibbonDoubles)
                                            self.view.bringSubviewToFront(BlackRibbonDoubles)
                                            
                                            BlackRibbonDoubles.layer.zPosition = 5
                                            
                                            NSLayoutConstraint.activate([
                                                BlackRibbonDoubles.trailingAnchor.constraint(equalTo: self.NewSinglesRankLabel.leadingAnchor, constant: -10 * scalingFactor),
                                                BlackRibbonDoubles.centerYAnchor.constraint(equalTo: self.NewSinglesRankLabel.centerYAnchor),
                                                BlackRibbonDoubles.widthAnchor.constraint(equalToConstant: 50 * scalingFactor), // Adjust the reference size as needed
                                                BlackRibbonDoubles.heightAnchor.constraint(equalToConstant: 50 * scalingFactor), // Adjust the reference size as needed
                                            ])
                                            
                                            //Increment 1 for Blue Ribbon_Singles in Badges table
                                            
                                        }
                                        else
                                        {
                                            print("HIGHEST SCORE IS GREATER THAN 8.5 BUUTTT PLAYER IS NOT EVALUATING TO IT")
                                        }
                                    }
                                    else
                                    {
                                        print("HIGHEST SCORE NOT EVALUATING TO > 8.5")
                                    }
                                    
                                    if self.Highest_Score_Doubles > 8.5
                                    {
                                        if self.Highest_Score_Singles > 8.5
                                        {
                                            
                                        
                                        if self.Highest_Score_Doubles == self.Player_DoublesRank
                                            {
                                            if self.Highest_Score_Singles == self.Player_SinglesRank
                                                    {
                                            backgroundImage.image = UIImage(named: "ChampBackground.png")
                                                
                                                //Increment 1 for Gold Ribbon in Badges Table
                                               
                                                    }
                                           
                                            }
                                    }
                                    }
                                    else {}
                                }
                            }
                    }
                }
        }

        print(GetHighScores())
       
        //put gold ribbon top right
        let img_GoldRibbon = UIImageView(image: UIImage(named: "GoldRibbon"))
        img_GoldRibbon.translatesAutoresizingMaskIntoConstraints = false
      
    
        //put gold ribbon top right
        let img_BlueRibbon = UIImageView(image: UIImage(named: "BlueRibbon"))
        img_BlueRibbon.translatesAutoresizingMaskIntoConstraints = false
      
      
        
        //put gold ribbon top right
        let img_RedFangs = UIImageView(image: UIImage(named: "RedFangs"))
        img_RedFangs.translatesAutoresizingMaskIntoConstraints = false
       
    
//RUN BADGES QUERY
        
        func GetBadgeData() {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email
            let docRef = db.collection("Agressv_Badges").document(uid!)
            
            docRef.getDocument { (document, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    print("\(document!.documentID) => \(String(describing: document!.data()))")
                    
                    //Doubles Wins number to string conversion
                    if let GoldRibbonValue = document!.data()!["Gold_Ribbon"] as? Int,
                    GoldRibbonValue > 0
                        {
                        self.HasAchievedGoldRibbon = true
                        }
                    
                    if let blueRibbonDoublesValue = document!.data()!["Blue_Ribbon_Doubles"] as? Int,
                        let blueRibbonSinglesValue = document!.data()!["Blue_Ribbon_Singles"] as? Int,
                        blueRibbonDoublesValue > 0 || blueRibbonSinglesValue > 0 {
                        self.HasAchievedBlueRibbon = true
                    }
                   
                    if let RedFangsValue = document!.data()!["Red_Fangs"] as? Int,
                       RedFangsValue > 0
                        {
                        self.HasAchievedRedFangs = true
                        }
                   
                    
                    if self.HasAchievedGoldRibbon {
                        
                        
                        self.view.addSubview(img_GoldRibbon)
                        
                        NSLayoutConstraint.activate([
                            img_GoldRibbon.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30 * scalingFactor), // Anchor to the bottom of the view
                            img_GoldRibbon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 35 * scalingFactor),  // Anchor to the left of the view
                            img_GoldRibbon.widthAnchor.constraint(equalToConstant: 40 * scalingFactor),
                            img_GoldRibbon.heightAnchor.constraint(equalToConstant: 40 * scalingFactor)
                        ])
                        
                    }
                    if self.HasAchievedBlueRibbon {
                        
                        
                        self.view.addSubview(img_BlueRibbon)
                        
                        // Position the label above the NewDoublesRankLabel
                        NSLayoutConstraint.activate([
                            img_BlueRibbon.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30 * scalingFactor),
                            img_BlueRibbon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 70 * scalingFactor),
                            img_BlueRibbon.widthAnchor.constraint(equalToConstant: 40 * scalingFactor),
                            img_BlueRibbon.heightAnchor.constraint(equalToConstant: 40 * scalingFactor)
                        ])
                    }
                    if self.HasAchievedRedFangs {
                        //put red fangs top right
                        self.view.addSubview(img_RedFangs)
                        
                        // Position the label above the NewDoublesRankLabel
                        NSLayoutConstraint.activate([
                            img_RedFangs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30 * scalingFactor),
                            img_RedFangs.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 110 * scalingFactor),
                            img_RedFangs.widthAnchor.constraint(equalToConstant: 40 * scalingFactor),
                            img_RedFangs.heightAnchor.constraint(equalToConstant: 40 * scalingFactor)
                        ])
                    }
                }
                
            }
            
        }
        print(GetBadgeData())
        
        
        
        
//END BADGES EVALUATION
        
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
                if gaugeactualcount >= 14 {
                    
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
                    
                    // Create an image view for the "Fire" image
                            let fireImage = UIImageView(image: UIImage(named: "Fire"))
                            fireImage.contentMode = .scaleAspectFit // Adjust content mode as needed
                            fireImage.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout

                            // Add the "Fire" image as a subview
                            self.view.addSubview(fireImage)

                            // Define Auto Layout constraints to position and scale the image over the word "fire"
                            NSLayoutConstraint.activate([
                                fireImage.leadingAnchor.constraint(equalTo: FireMessage.trailingAnchor, constant: -50 * scalingFactor),
                                fireImage.bottomAnchor.constraint(equalTo: FireMessage.topAnchor, constant: -2 * scalingFactor), // Position it just above the text
                                fireImage.widthAnchor.constraint(equalToConstant: 50 * scalingFactor), // Set the width to 10
                                fireImage.heightAnchor.constraint(equalToConstant: 50 * scalingFactor), // Set the height to 10
                            ])
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
       


    @objc func newGameButtonTapped() {
        // Create an alert controller
        let alertController = UIAlertController(title: "Game Logger Confirmation", message: "MAKE SURE ONLY ONE PLAYER LOGS THIS GAME.", preferredStyle: .alert)

        // Create a "Continue" action
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            // Move to the GameHistoryVC
            let DoublesOrSinglesVC = self.storyboard?.instantiateViewController(withIdentifier: "DoublesORSinglesID") as! NewGameViewController
            self.navigationController?.pushViewController(DoublesOrSinglesVC, animated: true)
        }

        // Create a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Add the actions to the alert controller
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func historyButtonTapped() {
        // Create an instance of opp two VC
        let GameHistoryVC = storyboard?.instantiateViewController(withIdentifier: "GameHistoryID") as! GameHistoryViewController
        
        // Push to the SecondViewController
        navigationController?.pushViewController(GameHistoryVC, animated: true)
        }
    
    
    @objc func settingsButtonTapped() {
            // Handle the button click and open the "AccountSettingsViewController" here
            let accountSettingsVC = AccountSettingsViewController()
            // Present or push the view controller as needed
            // For example:
             navigationController?.pushViewController(accountSettingsVC, animated: true)
            // or
            // present(accountSettingsVC, animated: true, completion: nil)
        }

@objc func badgesButtonTapped() {
    // Create an instance of opp two VC
    let BadgesVC = storyboard?.instantiateViewController(withIdentifier: "BadgesID") as! BadgesViewController
    
    // Push to the SecondViewController
    navigationController?.pushViewController(BadgesVC, animated: true)
    }
    
    
    } //end of class
    
    
    
    
    
extension UIColor {
    static func mustardYellow() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 219.0/255.0, blue: 88.0/255.0, alpha: 1.0)
    }
}

