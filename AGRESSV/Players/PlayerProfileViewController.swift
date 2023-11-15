//
//  PlayerProfileViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 11/9/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import MobileCoreServices
import AVFoundation
import SwiftUI
import Foundation
import Charts


class PlayerProfileViewController: UIViewController {

    var player: String = SharedPlayerData.shared.PlayerSelectedUsername_NoRank
    var playersEmail: String = ""
    
    var pieChartView: PieChartView!
    var pieChartViewSingles: PieChartViewSingles!
    
    
    var bluebadgecount: Int = 0
    var redfangscount: Int = 0
    var goldribboncount: Int = 0
    
    let lbl_bluebadgecount = UILabel()
    let lbl_redfangscount = UILabel()
    let lbl_goldribboncount = UILabel()
  
    
    var DoublesWinsPie: Double = 0.0
    var DoublesLossesPie: Double = 0.0
    var SinglesWinsPie: Double = 0.0
    var SinglesLossesPie: Double = 0.0
    
    var HasAchievedGoldRibbon: Bool = false
    var HasAchievedBlueRibbon: Bool = false
    var HasAchievedRedFangs: Bool = false

 
    var Highest_Score_Doubles: Double = 0.0
    var Highest_Score_Singles: Double = 0.0
    var Player_DoublesRank: Double = 0.0
    var Player_SinglesRank: Double = 0.0
    
    
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
    
   
    let UserNameLabelMain: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Impact", size: 20) // You can adjust the font size as needed
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let lbl_DoublesNerdData: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let lbl_SinglesNerdData: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let lbl_GamesPlayed = UILabel()
    
    let lbl_testcount = UILabel()

    
    var labelgaugecount: String = ""
    let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
  
    
    public var gaugemetercount = ""
    
    var gaugeactualcount: Int = 0
    
    
    var loadingView: UIView?
    var loadingLabel: UILabel?
    
    let db = Firestore.firestore()
    
    // Constants for Firestore
    let firestoreCollection = "Agressv_ProfileImages"
    
    // Reference to the current user's profile image document in Firestore
    var currentUserProfileImageRef: DocumentReference?
    
    // Create UIImageView for the profile picture
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 2.0
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        
        
              
        
   
        
        
        
        showLoadingView()
        
        
        
        
        // Call the function to retrieve user's email and update the variable
        retrieveUserEmailAndUpdateVariable()
        
        
        
        
    } // end of LOAD
    

    
    
    
    func updatePieChart() {
            // Calculate the percentage of wins and losses
            let totalGames = DoublesWinsPie + DoublesLossesPie

            guard totalGames > 0 else {
                // Handle the case where there are no games (to avoid division by zero)
                return
            }

            let winPercentage = DoublesWinsPie / totalGames
            let lossPercentage = DoublesLossesPie / totalGames

            // Update the data property of PieChartView
            pieChartView.data = [winPercentage, lossPercentage]
        
        
        }
    
    func updatePieChartSingles() {
            // Calculate the percentage of wins and losses
            let totalGames = SinglesWinsPie + SinglesLossesPie

            guard totalGames > 0 else {
                // Handle the case where there are no games (to avoid division by zero)
                return
            }

            let winPercentage = SinglesWinsPie / totalGames
            let lossPercentage = SinglesLossesPie / totalGames

            // Update the data property of PieChartView
            pieChartViewSingles.data = [winPercentage, lossPercentage]
        
        
        }
    
    
    func retrieveUserEmailAndUpdateVariable() {
        // Assuming you have a Firestore reference
        let db = Firestore.firestore()

        // Reference to the "Agressv_Users" collection
        let usersCollection = db.collection("Agressv_Users")

        // Query to get the user with the specified "Username"
        let query = usersCollection.whereField("Username", isEqualTo: player)

        // Perform the query
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                // Check if any documents are returned
                if let document = snapshot?.documents.first {
                    // Access the "Email" field from the document
                    if let userEmail = document.data()["Email"] as? String {
                        // Update the "playersEmail" variable
                        self.playersEmail = userEmail
                        // Now you can use 'self.playersEmail' in your view controller
                        print("Player's email: \(userEmail)")

                        // Perform any additional setup or code that depends on the player's email here
                        self.additionalSetupAfterEmailRetrieval()
                    } else {
                        // No "Email" field found in the document
                        print("Email not found.")
                    }
                } else {
                    // No document found with the specified "Username"
                    print("Player not found.")
                }
            }
        }
    }

    func additionalSetupAfterEmailRetrieval() {
        // Perform any additional setup or code that depends on the player's email here
        
        loadProfileImage()
        
        
        
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
        backgroundImage.image = UIImage(named: "NewProfileBackground")
        
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
        
        // Add profile image view to the view
        view.addSubview(profileImageView)
        
        // Set constraints for the profile image view
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40 * scalingFactor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5 * scalingFactor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150 * scalingFactor), // Increase the width
            profileImageView.heightAnchor.constraint(equalToConstant: 150 * scalingFactor) // Increase the height
        ])
        
       
        
        
      
        
        
        view.addSubview(UserNameLabelMain)
        
        
        let customFont = UIFont(name: "Angel wish", size: 50.0 * scalingFactor)
         UserNameLabelMain.font = customFont
        
        
        NSLayoutConstraint.activate([
           
            UserNameLabelMain.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20 * scalingFactor),
            UserNameLabelMain.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 15 * scalingFactor),
            
        ])
        
        
       
        
        
//        let lbl_Playmoregames = UILabel()
//        lbl_Playmoregames.text = "Play more games. Be"
//        lbl_Playmoregames.textColor = .white
//        lbl_Playmoregames.font = UIFont.systemFont(ofSize: 12)
//        lbl_Playmoregames.numberOfLines = 0 // Allow multiple lines
//        lbl_Playmoregames.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
//
//                // Add the label to the view hierarchy
//                view.addSubview(lbl_Playmoregames)
//
//                // Define Auto Layout constraints to position and allow the label to expand its width based on content
//                NSLayoutConstraint.activate([
//                    lbl_Playmoregames.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150 * scalingFactor), // Left side of the screen
//                    lbl_Playmoregames.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200 * scalingFactor), // A little higher than the bottom
//                    lbl_Playmoregames.heightAnchor.constraint(equalToConstant: 30 * scalingFactor), // Adjust the reference height as needed
//                ])
//
//                // Set the width constraint to be greater than or equal to a minimum width
//                let minWidthConstraint_playmoregames = lbl_Playmoregames.widthAnchor.constraint(greaterThanOrEqualToConstant: 100 * scalingFactor) // Adjust the minimum width as needed
//        minWidthConstraint_playmoregames.priority = .defaultLow // Lower priority so that it can expand
//
//                NSLayoutConstraint.activate([minWidthConstraint_playmoregames])
//
//
//        lbl_Playmoregames.layer.zPosition = 3
//
//
//        // Load the image
//        if let AgressvLogo = UIImage(named: "AgressvLogoSmallWhite.png") {
//            let myImageView = UIImageView()
//            myImageView.contentMode = .scaleAspectFit
//            myImageView.image = AgressvLogo
//            myImageView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
//
//            // Add the image view to the view hierarchy
//            view.addSubview(myImageView)
//
//
//
//            // Define Auto Layout constraints to position and scale the image
//            NSLayoutConstraint.activate([
//                myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                myImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//                myImageView.widthAnchor.constraint(equalToConstant: 300 * scalingFactor), // Adjust the reference size as needed
//                myImageView.heightAnchor.constraint(equalToConstant: 300 * scalingFactor), // Adjust the reference size as needed
//            ])
//
//
//        }
        
        
        
        //GET DATA

        let db = Firestore.firestore()


        func GetHomeScreenData() {
          
            let docRef = db.collection("Agressv_Users").document(playersEmail)

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
                    self.UserNameLabelMain.text = document!.data()!["Username"] as? String

                    
                    let DoublesWinsPie = document!.data()!["Doubles_Games_Wins"] as? Double ?? 0.0
                    let DoublesLossesPie = document!.data()!["Doubles_Games_Losses"] as? Double ?? 0.0
                    let SinglesWinsPie = document!.data()!["Singles_Games_Wins"] as? Double ?? 0.0
                    let SinglesLossesPie = document!.data()!["Singles_Games_Losses"] as? Double ?? 0.0
                    
                    self.DoublesWinsPie = DoublesWinsPie
                    self.DoublesLossesPie = DoublesLossesPie
                    
                    self.SinglesWinsPie = SinglesWinsPie
                    self.SinglesLossesPie = SinglesLossesPie
                    
                    print(self.DoublesWinsPie)
                    print(self.DoublesLossesPie)
                    
                 
                   
                    self.updatePieChart()
                    self.updatePieChartSingles()

                }
            }
        }


        //Calls the Username function
        print(GetHomeScreenData())
        
                           
       

        // Function to query Firestore and determine rank
        func calculateAndSetDoublesRank() {
            let db = Firestore.firestore()
            let uid = playersEmail
            let collectionReference = db.collection("Agressv_Users")
            
            collectionReference.order(by: "Doubles_Rank", descending: true).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    // Process documents and calculate rank
                    print(self.playersEmail)
                    print("THE NERD DATA FUNCTION IS RUNNING!!!!")
                    var rank = 1

                    for (index, document) in querySnapshot!.documents.enumerated() {
                        let doublesRank = (document.data()["Doubles_Rank"] as? Double ?? 0.0).rounded(toPlaces: 1)

                        if index > 0 {
                            let previousDocument = querySnapshot!.documents[index - 1]
                            let previousDoublesRank = (previousDocument.data()["Doubles_Rank"] as? Double ?? 0.0).rounded(toPlaces: 1)

                            if doublesRank < previousDoublesRank {
                                rank = index + 1
                            }
                        }

                        // Assuming you want to find the rank for the current user
                        if document.documentID == uid {
                            // Update UI on the main thread
                            self.lbl_DoublesNerdData.text = "D: \(rank)"
                        
                           
                        }
                    }
                }
            }
        }
        
        // Function to query Firestore and determine rank
        func calculateAndSetSinglesRank() {
            let db = Firestore.firestore()
            let uid = playersEmail
            let collectionReference = db.collection("Agressv_Users")
            
            collectionReference.order(by: "Singles_Rank", descending: true).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    // Process documents and calculate rank
                    print(self.playersEmail)
                    print("THE NERD DATA FUNCTION IS RUNNING!!!!")
                    var rank = 1

                    for (index, document) in querySnapshot!.documents.enumerated() {
                        let singlesRank = (document.data()["Singles_Rank"] as? Double ?? 0.0).rounded(toPlaces: 1)

                        if index > 0 {
                            let previousDocument = querySnapshot!.documents[index - 1]
                            let previousSinglesRank = (previousDocument.data()["Singles_Rank"] as? Double ?? 0.0).rounded(toPlaces: 1)

                            if singlesRank < previousSinglesRank {
                                rank = index + 1
                            }
                        }

                        // Assuming you want to find the rank for the current user
                     
                        if document.documentID == uid {
                            // Update UI on the main thread
                          
                                self.lbl_SinglesNerdData.text = "S: \(rank)"
                                
                                    
                                   
                          
                                
                           
                        }
                    }
                }
            }
        }

        // Call this function when you want to calculate and set the rank
      
            print(calculateAndSetDoublesRank())
        print(calculateAndSetSinglesRank())
        

        // Create the label
        let lbl_RanksTop = UILabel()
        lbl_RanksTop.text = "Current Rank"
        lbl_RanksTop.textColor = .lightGray
        lbl_RanksTop.font = UIFont.systemFont(ofSize: 15)
        lbl_RanksTop.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_RanksTop.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        self.view.addSubview(lbl_RanksTop)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_RanksTop: CGFloat = 15.0 // Set your base font size
        let adjustedFontSize_lbl_RanksTop = baseFontSize_lbl_RanksTop * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_RanksTop.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_RanksTop)
        
        lbl_RanksTop.font = UIFont(name: "Thonburi", size: adjustedFontSize_lbl_RanksTop)
        
        // Define Auto Layout constraints to position and allow the label to expand its width based on content
                NSLayoutConstraint.activate([
                    lbl_RanksTop.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 50 * scalingFactor),
                    lbl_RanksTop.topAnchor.constraint(equalTo: self.profileImageView.topAnchor, constant: 55 * scalingFactor)
                    
                ])
        
        
        
        self.lbl_DoublesNerdData.textColor = .white
        
    self.view.addSubview(self.lbl_DoublesNerdData)
        
        self.lbl_DoublesNerdData.layer.zPosition = 5
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_DoublesNerdData: CGFloat = 20.0 // Set your base font size
        let adjustedFontSize_lbl_DoublesNerdData = baseFontSize_lbl_DoublesNerdData * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_DoublesNerdData.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_DoublesNerdData)
        self.lbl_DoublesNerdData.font = UIFont(name: "Thonburi", size: adjustedFontSize_lbl_DoublesNerdData)
        
        NSLayoutConstraint.activate([
            // Position NewDoublesRankLabel to the left of the center by a certain percentage
            self.lbl_DoublesNerdData.leadingAnchor.constraint(equalTo: lbl_RanksTop.leadingAnchor),
            self.lbl_DoublesNerdData.topAnchor.constraint(equalTo: lbl_RanksTop.bottomAnchor, constant: 5 * scalingFactor)
            ])
        
        
        
        
        self.lbl_SinglesNerdData.textColor = .white
        
        self.view.addSubview(self.lbl_SinglesNerdData)
        
        self.lbl_SinglesNerdData.layer.zPosition = 5
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_SinglesNerdData: CGFloat = 20.0 // Set your base font size
        let adjustedFontSize_lbl_SinglesNerdData = baseFontSize_lbl_SinglesNerdData * scalingFactor

        // Set the font size for lbl_Playometer
        self.lbl_SinglesNerdData.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_SinglesNerdData)
        self.lbl_SinglesNerdData.font = UIFont(name: "Thonburi", size: adjustedFontSize_lbl_SinglesNerdData)
        
        NSLayoutConstraint.activate([
            // Position NewDoublesRankLabel to the left of the center by a certain percentage
            self.lbl_SinglesNerdData.leadingAnchor.constraint(equalTo: self.lbl_DoublesNerdData.trailingAnchor, constant: 25 * scalingFactor),
            self.lbl_SinglesNerdData.topAnchor.constraint(equalTo: self.lbl_DoublesNerdData.topAnchor)
            ])
        
        
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
            let uid = playersEmail
            let docRef = db.collection("Agressv_Badges").document(uid)
            
            docRef.getDocument { (document, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    print("\(document!.documentID) => \(String(describing: document!.data()))")
                    
                    let blueribbondoubles = document!.data()!["Blue_Ribbon_Doubles"] as! Int
                    let blueribbonsingles = document!.data()!["Blue_Ribbon_Singles"] as! Int
                    let blueribbonsum = blueribbondoubles + blueribbonsingles
                    
                    self.bluebadgecount = blueribbonsum
                    self.redfangscount = document!.data()!["Red_Fangs"] as! Int
                    self.goldribboncount = document!.data()!["Gold_Ribbon"] as! Int
                    
                    print(self.bluebadgecount)
                    print(self.redfangscount)
                    print(self.goldribboncount)
                    
                    self.lbl_bluebadgecount.text = String(self.bluebadgecount)
                    self.lbl_goldribboncount.text = String(self.goldribboncount)
                    self.lbl_redfangscount.text = String(self.redfangscount)
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
                            img_GoldRibbon.topAnchor.constraint(equalTo: self.lbl_DoublesNerdData.bottomAnchor, constant: 20 * scalingFactor), // Anchor to the bottom of the view
                            img_GoldRibbon.leadingAnchor.constraint(equalTo: self.lbl_DoublesNerdData.leadingAnchor, constant: 55 * scalingFactor),  // Anchor to the left of the view
                            img_GoldRibbon.widthAnchor.constraint(equalToConstant: 25 * scalingFactor),
                            img_GoldRibbon.heightAnchor.constraint(equalToConstant: 25 * scalingFactor)
                        ])
                        
                        let baseFontSize: CGFloat = 8.0 // Set your base font size
                        let adjustedFontSize = baseFontSize * scalingFactor

                 
                        self.lbl_goldribboncount.font = UIFont.systemFont(ofSize: adjustedFontSize)
                        
                        self.lbl_goldribboncount.textColor = UIColor.white
                        self.lbl_goldribboncount.translatesAutoresizingMaskIntoConstraints = false
                        print(self.lbl_goldribboncount)
                        self.view.addSubview(self.lbl_goldribboncount)
                        
                        NSLayoutConstraint.activate([
                            self.lbl_goldribboncount.bottomAnchor.constraint(equalTo: img_GoldRibbon.topAnchor),
                            self.lbl_goldribboncount.leadingAnchor.constraint(equalTo: img_GoldRibbon.trailingAnchor, constant: -2 * scalingFactor),
                            self.lbl_goldribboncount.widthAnchor.constraint(equalToConstant: 10 * scalingFactor),
                            self.lbl_goldribboncount.heightAnchor.constraint(equalToConstant: 10 * scalingFactor)
                        ])
                        
                    }
                    if self.HasAchievedBlueRibbon {
                        
                    
                        self.view.addSubview(img_BlueRibbon)
                
                        NSLayoutConstraint.activate([
                            img_BlueRibbon.topAnchor.constraint(equalTo: self.lbl_DoublesNerdData.bottomAnchor, constant: 20 * scalingFactor),
                            img_BlueRibbon.leadingAnchor.constraint(equalTo: self.lbl_DoublesNerdData.leadingAnchor, constant: -5 * scalingFactor),
                            img_BlueRibbon.widthAnchor.constraint(equalToConstant: 25 * scalingFactor),
                            img_BlueRibbon.heightAnchor.constraint(equalToConstant: 25 * scalingFactor)
                        ])
                        
                        let baseFontSize: CGFloat = 8.0 // Set your base font size
                        let adjustedFontSize = baseFontSize * scalingFactor

                 
                        self.lbl_bluebadgecount.font = UIFont.systemFont(ofSize: adjustedFontSize)
                        
                        self.lbl_bluebadgecount.textColor = UIColor.white
                        self.lbl_bluebadgecount.translatesAutoresizingMaskIntoConstraints = false
                        print(self.lbl_bluebadgecount)
                        self.view.addSubview(self.lbl_bluebadgecount)
                        
                        NSLayoutConstraint.activate([
                            self.lbl_bluebadgecount.bottomAnchor.constraint(equalTo: img_BlueRibbon.topAnchor),
                            self.lbl_bluebadgecount.leadingAnchor.constraint(equalTo: img_BlueRibbon.trailingAnchor, constant: -2 * scalingFactor),
                            self.lbl_bluebadgecount.widthAnchor.constraint(equalToConstant: 10 * scalingFactor),
                            self.lbl_bluebadgecount.heightAnchor.constraint(equalToConstant: 10 * scalingFactor)
                        ])
                        
                        
                        
                        
                    }
                    if self.HasAchievedRedFangs {
                        //put red fangs top right
                        self.view.addSubview(img_RedFangs)
                        
                        // Position the label above the NewDoublesRankLabel
                        NSLayoutConstraint.activate([
                            img_RedFangs.topAnchor.constraint(equalTo: self.lbl_DoublesNerdData.bottomAnchor, constant: 20 * scalingFactor),
                            img_RedFangs.leadingAnchor.constraint(equalTo: self.lbl_DoublesNerdData.leadingAnchor, constant: 25 * scalingFactor),
                            img_RedFangs.widthAnchor.constraint(equalToConstant: 25 * scalingFactor),
                            img_RedFangs.heightAnchor.constraint(equalToConstant: 25 * scalingFactor)
                        ])
                        
                        let baseFontSize: CGFloat = 8.0 // Set your base font size
                        let adjustedFontSize = baseFontSize * scalingFactor

                 
                        self.lbl_redfangscount.font = UIFont.systemFont(ofSize: adjustedFontSize)
                        
                        self.lbl_redfangscount.textColor = UIColor.white
                        self.lbl_redfangscount.translatesAutoresizingMaskIntoConstraints = false
                        print(self.lbl_redfangscount)
                        self.view.addSubview(self.lbl_redfangscount)
                        
                        NSLayoutConstraint.activate([
                            self.lbl_redfangscount.bottomAnchor.constraint(equalTo: img_RedFangs.topAnchor),
                            self.lbl_redfangscount.leadingAnchor.constraint(equalTo: img_RedFangs.trailingAnchor, constant: -2 * scalingFactor),
                            self.lbl_redfangscount.widthAnchor.constraint(equalToConstant: 10 * scalingFactor),
                            self.lbl_redfangscount.heightAnchor.constraint(equalToConstant: 10 * scalingFactor)
                        ])
                    }
                }
                
            }
            
        }
        print(GetBadgeData())
        
        let fontSize: CGFloat = 25.0 // Set your default font size
     
                lbl_SinglesHeader.font = UIFont(name: "Impact", size: fontSize * scalingFactor)
                lbl_DoublesHeader.font = UIFont(name: "Impact", size: fontSize * scalingFactor)
           
      
        let xOffsetPercent: CGFloat = 0.22 // Default values (larger screens)
        
        

        
        func currentcountforgauge() {
            // Reference to Firestore collection

            let db = Firestore.firestore()
            let uid = playersEmail


            let query = db.collection("Agressv_Games").whereFilter(Filter.andFilter([
                Filter.whereField("Game_Date", isGreaterOrEqualTo: CurrentDateMinus7!),
                Filter.orFilter([
                    Filter.whereField("Game_Creator", isEqualTo: uid),
                    Filter.whereField("Game_Opponent_One", isEqualTo: uid),
                    Filter.whereField("Game_Opponent_Two", isEqualTo: uid),
                    Filter.whereField("Game_Partner", isEqualTo: uid)

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
                        swiftuiView_gauge.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 200 * scalingFactor),
                        swiftuiView_gauge.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -500 * scalingFactor)
                    ])
                    
                    
                    // Create the label
                    let lbl_Playometer = UILabel()
                    lbl_Playometer.text = "Playometer"
                    lbl_Playometer.textColor = .white
                    lbl_Playometer.font = UIFont.systemFont(ofSize: 17)
                    lbl_Playometer.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
                    lbl_Playometer.numberOfLines = 0 // Allow multiple lines
                    // Add the label to the view hierarchy
                    self.view.addSubview(lbl_Playometer)
                    
                    // Calculate the adjusted font size based on the scalingFactor
                    let baseFontSize: CGFloat = 17.0 // Set your base font size
                    let adjustedFontSize = baseFontSize * scalingFactor

                    // Set the font size for lbl_Playometer
                    lbl_Playometer.font = UIFont.systemFont(ofSize: adjustedFontSize)
                    

                    
                    // Define Auto Layout constraints to position and allow the label to expand its width based on content
                            NSLayoutConstraint.activate([
                                lbl_Playometer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50 * scalingFactor), // Left side of the screen
                                lbl_Playometer.bottomAnchor.constraint(equalTo: swiftuiView_gauge.topAnchor, constant: -27 * scalingFactor), // A little higher than the bottom
                                
                            ])
                    
                    // Set the width constraint to be greater than or equal to a minimum width
                    let minWidthConstraintPlayometer = lbl_Playometer.widthAnchor.constraint(greaterThanOrEqualToConstant: 100 * scalingFactor) // Adjust the minimum width as needed
                    minWidthConstraintPlayometer.priority = .defaultLow // Lower priority so that it can expand

                    NSLayoutConstraint.activate([minWidthConstraintPlayometer])
                    
                    lbl_Playometer.layer.zPosition = 3
                    
                    
                    
                    
                    // Create the label
                    let lbl_Games7Days = UILabel()
                    lbl_Games7Days.text = "Games played in rolling 7 days:"
                    lbl_Games7Days.textColor = .lightGray
                    lbl_Games7Days.font = UIFont.systemFont(ofSize: 17)
                    lbl_Games7Days.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
                    lbl_Games7Days.numberOfLines = 0 // Allow multiple lines
                    // Add the label to the view hierarchy
                    self.view.addSubview(lbl_Games7Days)
                    
                    // Calculate the adjusted font size based on the scalingFactor
                    let baseFontSize_lbl_Games7Days: CGFloat = 13.0 // Set your base font size
                    let adjustedFontSize_lbl_Games7Days = baseFontSize_lbl_Games7Days * scalingFactor

                    // Set the font size for lbl_Playometer
                    lbl_Games7Days.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_Games7Days)
                    

                    
                    // Define Auto Layout constraints to position and allow the label to expand its width based on content
                            NSLayoutConstraint.activate([
                                lbl_Games7Days.leadingAnchor.constraint(equalTo: lbl_Playometer.leadingAnchor), // Left side of the screen
                                lbl_Games7Days.bottomAnchor.constraint(equalTo: swiftuiView_gauge.topAnchor, constant: -12 * scalingFactor), // A little higher than the bottom
                                
                            ])
                    
                    
                    lbl_Games7Days.layer.zPosition = 3
                    
                    
                   
                    self.lbl_testcount.textColor = .white
                    self.lbl_testcount.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
                    
                    // Add the label to the view hierarchy
                    self.view.addSubview(self.lbl_testcount)
                    
                    
                    // Calculate the adjusted font size based on the scalingFactor
                    let baseFontSizeGaugeCount: CGFloat = 13.0 // Set your base font size
                    let adjustedFontSizeGaugeCount = baseFontSizeGaugeCount * scalingFactor

                    // Set the font size for lbl_Playometer
                    self.lbl_testcount.font = UIFont.systemFont(ofSize: adjustedFontSizeGaugeCount)
                    
                    
                    // Define Auto Layout constraints to position and scale the label
                    NSLayoutConstraint.activate([
                        self.lbl_testcount.leadingAnchor.constraint(equalTo: lbl_Games7Days.trailingAnchor, constant: 5 * scalingFactor), // Left side of the screen
                        self.lbl_testcount.bottomAnchor.constraint(equalTo: lbl_Games7Days.bottomAnchor) // A little higher than the bottom
                        //self.lbl_testcount.heightAnchor.constraint(equalToConstant: 10 * scalingFactor), // Adjust the reference size as needed
                    ])
                    
                    self.lbl_testcount.layer.zPosition = 3
                    
//                    // Check if gaugeactualcount is greater than or equal to 32
//                    if self.gaugeactualcount >= 14 {
//
//
//
//                        // Create an image view for the "Fire" image
//                        let fireImage = UIImageView(image: UIImage(named: "Fire"))
//                        fireImage.contentMode = .scaleAspectFit // Adjust content mode as needed
//                        fireImage.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
//
//                        // Add the "Fire" image as a subview
//                        self.view.addSubview(fireImage)
//
//                        // Define Auto Layout constraints to position and scale the image over the word "fire"
//                        NSLayoutConstraint.activate([
//                            fireImage.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -15 * scalingFactor),
//                            fireImage.bottomAnchor.constraint(equalTo: self.lbl_testcount.bottomAnchor, constant: 5 * scalingFactor),
//                            fireImage.widthAnchor.constraint(equalToConstant: 50 * scalingFactor), // Set the width to 10
//                            fireImage.heightAnchor.constraint(equalToConstant: 50 * scalingFactor), // Set the height to 10
//                        ])
//                    }
                    
                    let labelSize: CGFloat = 80.0
                    
                    NSLayoutConstraint.activate([
                        // Position NewDoublesRankLabel to the left of the center by a certain percentage
                        self.NewDoublesRankLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -self.view.bounds.width * xOffsetPercent * scalingFactor),
                        
                        // Position NewDoublesRankLabel to be a certain percentage from the bottom
                        self.NewDoublesRankLabel.topAnchor.constraint(equalTo: lbl_Games7Days.bottomAnchor, constant: 80 * scalingFactor),
                        
                        // Set the width and height of NewDoublesRankLabel
                        self.NewDoublesRankLabel.widthAnchor.constraint(equalToConstant: labelSize * scalingFactor),
                        self.NewDoublesRankLabel.heightAnchor.constraint(equalToConstant: labelSize * scalingFactor),
                        
                        self.lbl_SinglesHeader.centerXAnchor.constraint(equalTo: self.NewSinglesRankLabel.centerXAnchor, constant: 1 * scalingFactor),
                        self.lbl_SinglesHeader.topAnchor.constraint(equalTo: self.NewSinglesRankLabel.bottomAnchor, constant: -115 * scalingFactor),
                        
                        self.lbl_DoublesHeader.centerXAnchor.constraint(equalTo: self.NewDoublesRankLabel.centerXAnchor, constant: 1 * scalingFactor),
                        self.lbl_DoublesHeader.topAnchor.constraint(equalTo: self.NewDoublesRankLabel.bottomAnchor, constant: -115 * scalingFactor),
                        
                        // Position DW_Letter a certain percentage lower than NewDoublesRankLabel
                        self.DW_Letter.centerXAnchor.constraint(equalTo: self.NewDoublesRankLabel.centerXAnchor, constant: -22 * scalingFactor),
                        self.DW_Letter.topAnchor.constraint(equalTo: self.NewDoublesRankLabel.bottomAnchor, constant: 30 * scalingFactor),
                        
                        self.DoublesWinsLabel.centerXAnchor.constraint(equalTo: self.NewDoublesRankLabel.centerXAnchor, constant: 9 * scalingFactor),
                        self.DoublesWinsLabel.topAnchor.constraint(equalTo: self.NewDoublesRankLabel.bottomAnchor, constant: 30 * scalingFactor),
                        
                        // Position DW_Letter a certain percentage lower than NewDoublesRankLabel
                        self.DL_Letter.centerXAnchor.constraint(equalTo: self.NewDoublesRankLabel.centerXAnchor, constant: -22 * scalingFactor),
                        self.DL_Letter.topAnchor.constraint(equalTo: self.NewDoublesRankLabel.bottomAnchor, constant: 70 * scalingFactor),
                        
                        self.DoublesLossesLabel.centerXAnchor.constraint(equalTo: self.NewDoublesRankLabel.centerXAnchor, constant: 9 * scalingFactor),
                        self.DoublesLossesLabel.topAnchor.constraint(equalTo: self.NewDoublesRankLabel.bottomAnchor, constant: 70 * scalingFactor),
                       
                        // Position DW_Letter a certain percentage lower than NewDoublesRankLabel
                        self.SW_Letter.centerXAnchor.constraint(equalTo: self.NewSinglesRankLabel.centerXAnchor, constant: -22 * scalingFactor),
                        self.SW_Letter.topAnchor.constraint(equalTo: self.NewSinglesRankLabel.bottomAnchor, constant: 30 * scalingFactor),
                        
                        self.SinglesWinsLabel.centerXAnchor.constraint(equalTo: self.NewSinglesRankLabel.centerXAnchor, constant: 9 * scalingFactor),
                        self.SinglesWinsLabel.topAnchor.constraint(equalTo: self.NewSinglesRankLabel.bottomAnchor, constant: 30 * scalingFactor),
                        
                        
                        // Position DW_Letter a certain percentage lower than NewDoublesRankLabel
                        self.SL_Letter.centerXAnchor.constraint(equalTo: self.NewSinglesRankLabel.centerXAnchor, constant: -22 * scalingFactor),
                        self.SL_Letter.topAnchor.constraint(equalTo: self.NewSinglesRankLabel.bottomAnchor, constant: 70 * scalingFactor),
                        
                        self.SinglesLossesLabel.centerXAnchor.constraint(equalTo: self.NewSinglesRankLabel.centerXAnchor, constant: 9 * scalingFactor),
                        self.SinglesLossesLabel.topAnchor.constraint(equalTo: self.NewSinglesRankLabel.bottomAnchor, constant: 70 * scalingFactor),
                        
                        // Position NewSinglesRankLabel to the right of the center by the same percentage
                        self.NewSinglesRankLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.bounds.width * xOffsetPercent * scalingFactor),
                        
                        // Position NewSinglesRankLabel to be a certain percentage from the bottom
                        self.NewSinglesRankLabel.topAnchor.constraint(equalTo: lbl_Games7Days.bottomAnchor, constant: 80 * scalingFactor),
                        
                        // Set the width and height of NewSinglesRankLabel
                        self.NewSinglesRankLabel.widthAnchor.constraint(equalToConstant: labelSize * scalingFactor),
                        self.NewSinglesRankLabel.heightAnchor.constraint(equalToConstant: labelSize * scalingFactor)
                    ])
                    
                    
                    
                }
            }

        }

        //update the gauge value
        print(currentcountforgauge())
        
        

        
        
  
        
        
        
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
        
        
               
      

        // Create an instance of PieChartView
        pieChartView = PieChartView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false




        view.addSubview(pieChartView)



        // Set Auto Layout constraints for PieChartView
        NSLayoutConstraint.activate([
            pieChartView.leadingAnchor.constraint(equalTo: lbl_DoublesHeader.leadingAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130 * scalingFactor),
            pieChartView.widthAnchor.constraint(equalToConstant: 90 * scalingFactor),
            pieChartView.heightAnchor.constraint(equalToConstant: 90 * scalingFactor)
        ])


        
        
        
        pieChartViewSingles = PieChartViewSingles()
        pieChartViewSingles.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(pieChartViewSingles)

      

        // Set Auto Layout constraints for PieChartView
        NSLayoutConstraint.activate([
            pieChartViewSingles.leadingAnchor.constraint(equalTo: lbl_SinglesHeader.leadingAnchor),
            pieChartViewSingles.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130 * scalingFactor),
            pieChartViewSingles.widthAnchor.constraint(equalToConstant: 90 * scalingFactor),
            pieChartViewSingles.heightAnchor.constraint(equalToConstant: 90 * scalingFactor)
        ])
        
//        NSLayoutConstraint.activate([
//                    // Position the "Settings" button
//                    settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -125 * scalingFactor),
//                    settingsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40 * scalingFactor),
//                    settingsButton.widthAnchor.constraint(equalToConstant: 65 * scalingFactor),
//                    settingsButton.heightAnchor.constraint(equalToConstant: 65 * scalingFactor),
//
//                    // Position the "History" button
//                    historyButton.topAnchor.constraint(equalTo: settingsButton.topAnchor),
//                    historyButton.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: 20 * IconsPercentage),
//                    historyButton.widthAnchor.constraint(equalToConstant: 65 * scalingFactor),
//                    historyButton.heightAnchor.constraint(equalToConstant: 65 * scalingFactor),
//
//                    // Position the "Badges" button
//                    PlayersButton.topAnchor.constraint(equalTo: settingsButton.topAnchor),
//                    PlayersButton.trailingAnchor.constraint(equalTo: newGameButton.leadingAnchor, constant: -20 * IconsPercentage),
//                    PlayersButton.widthAnchor.constraint(equalToConstant: 65 * scalingFactor),
//                    PlayersButton.heightAnchor.constraint(equalToConstant: 65 * scalingFactor),
//
//                    // Position the "NewGame" button
//                    newGameButton.topAnchor.constraint(equalTo: settingsButton.topAnchor),
//                    //newGameButton.leadingAnchor.constraint(equalTo: badgesButton.trailingAnchor, constant: 20 * scalingFactor),
//                    newGameButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40 * scalingFactor),
//                    newGameButton.widthAnchor.constraint(equalToConstant: 65 * scalingFactor),
//                    newGameButton.heightAnchor.constraint(equalToConstant: 65 * scalingFactor)
//                ])
        
     

        // Create a UIColor with the desired light blueish gray color
        let lightBlueishGrayColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)
        lbl_DoublesHeader.textColor = lightBlueishGrayColor
        lbl_SinglesHeader.textColor = lightBlueishGrayColor

        DL_Letter.textColor = lightBlueishGrayColor
        SL_Letter.textColor = lightBlueishGrayColor
        UserNameLabelMain.textColor = lightBlueishGrayColor
        
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
                                            self.profileImageView.layer.borderColor = UIColor.blue.cgColor
//                                            //ADD BLACK RIBBON
//                                            let BlackRibbon_Doubles = UIImage(named: "BlueRibbon.png")
//                                            let BlackRibbonDoubles = UIImageView()
//                                            BlackRibbonDoubles.contentMode = .scaleAspectFit
//                                            BlackRibbonDoubles.image = BlackRibbon_Doubles
//                                            BlackRibbonDoubles.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
//
//                                            // Add the image view to the view hierarchy
//                                            self.view.addSubview(BlackRibbonDoubles)
//                                            self.view.bringSubviewToFront(BlackRibbonDoubles)
//
//                                            BlackRibbonDoubles.layer.zPosition = 5
//
//                                            NSLayoutConstraint.activate([
//                                                BlackRibbonDoubles.trailingAnchor.constraint(equalTo: self.NewDoublesRankLabel.leadingAnchor, constant: -10 * scalingFactor),
//                                                BlackRibbonDoubles.centerYAnchor.constraint(equalTo: self.NewDoublesRankLabel.centerYAnchor),
//                                                BlackRibbonDoubles.widthAnchor.constraint(equalToConstant: 50 * scalingFactor), // Adjust the reference size as needed
//                                                BlackRibbonDoubles.heightAnchor.constraint(equalToConstant: 50 * scalingFactor), // Adjust the reference size as needed
//                                            ])
                                            
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
                                            self.profileImageView.layer.borderColor = UIColor.blue.cgColor
//                                            //ADD BLACK RIBBON
//                                            let BlackRibbon_Doubles = UIImage(named: "BlueRibbon.png")
//                                            let BlackRibbonDoubles = UIImageView()
//                                            BlackRibbonDoubles.contentMode = .scaleAspectFit
//                                            BlackRibbonDoubles.image = BlackRibbon_Doubles
//                                            BlackRibbonDoubles.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
//
//                                            // Add the image view to the view hierarchy
//                                            self.view.addSubview(BlackRibbonDoubles)
//                                            self.view.bringSubviewToFront(BlackRibbonDoubles)
//
//                                            BlackRibbonDoubles.layer.zPosition = 5
//
//                                            NSLayoutConstraint.activate([
//                                                BlackRibbonDoubles.trailingAnchor.constraint(equalTo: self.NewSinglesRankLabel.leadingAnchor, constant: -10 * scalingFactor),
//                                                BlackRibbonDoubles.centerYAnchor.constraint(equalTo: self.NewSinglesRankLabel.centerYAnchor),
//                                                BlackRibbonDoubles.widthAnchor.constraint(equalToConstant: 50 * scalingFactor), // Adjust the reference size as needed
//                                                BlackRibbonDoubles.heightAnchor.constraint(equalToConstant: 50 * scalingFactor), // Adjust the reference size as needed
//                                            ])
                                            
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
                                            //backgroundImage.image = UIImage(named: "ChampBackground.png")
                                                self.profileImageView.layer.borderColor = UIColor.yellow.cgColor
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
        
        
        
        
        
        
        
        
        
        
        // Simulate loading for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Call a function to hide the loading view
            self.hideLoadingView()
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()

           // Set corner radius to half of the image view's width
           profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.width
       }
    
    
    func loadProfileImage() {
        // Load the user's profile image from Firestore
        
        guard !playersEmail.isEmpty else {
            // Handle the case where the user's email is not available
            return
        }
        
        let docRef = db.collection("Agressv_ProfileImages").document(playersEmail)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, retrieve and set the profile image
                if let imageData = document.data()?["User_Img"] as? Data {
                    self.profileImageView.image = UIImage(data: imageData)
                } else {
                    // Handle the case where the "User_Img" field does not contain valid image data
                }
            } else {
                // Handle the case where the document does not exist (user does not have a profile image)
                self.profileImageView.image = UIImage(named: "DefaultPlayerImage")
            }
        }
    }
    
    
    func showLoadingView() {
            // Create a UIView that covers the entire screen
            loadingView = UIView(frame: view.bounds)
            loadingView?.backgroundColor = .white
            
            // Create a UILabel with the desired text
            loadingLabel = UILabel()
            loadingLabel?.text = "Loading player..."
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
            
          
        }
    
    
    
    
    
} //end of class
