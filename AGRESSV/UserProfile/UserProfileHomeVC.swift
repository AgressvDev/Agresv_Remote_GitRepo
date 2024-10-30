//
//  UserProfileHomeVC.swift
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

class UserProfileHomeVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var UserHasMessages = false
    var messageLabel: UILabel?
    var BadgeCountNumber: String = ""
    
    var player: String = ""
    var Weighted_Score: Double = 0.60
    var Weighted_GamesPlayed: Double = 0.15
    var Weighted_WinPercentage: Double = 0.25
    
    var userDataDictionary: [String: [String: Double]] = [:]
    var sortedUsernames: [String] = []

    var userDataDictionarySingles: [String: [String: Double]] = [:]
    var sortedUsernamesSingles: [String] = []
    
    var playersEmail: String = ""
    var highestWinPercentage: Double = 0.0
    
    var UserHasHighestDoublesWinPercentage: Bool = false
    var D_highestWinPercentage: Double = 0.0
    var D_currentUserWinPercentage: Double = 0.0
    
    
    var UserHasHighestSinglesWinPercentage: Bool = false
    var S_highestWinPercentage: Double = 0.0
    var S_currentUserWinPercentage: Double = 0.0
    
    var UserEarnedRedFangs: Bool = false
    var HasAchievedGoldRibbon: Bool = false
    var HasAchievedBlueRibbon: Bool = false
    var HasAchievedRedFangs: Bool = false

 
    var Highest_Score_Doubles: Double = 0.0
    var Highest_Score_Singles: Double = 0.0
    var Player_DoublesRank: Double = 0.0
    var Player_SinglesRank: Double = 0.0
    
    var bluebadgecount: Int = 0
    var redfangscount: Int = 0
    var goldribboncount: Int = 0
    
    var lbl_bluebadgecount = UILabel()
    var lbl_redfangscount = UILabel()
    var lbl_goldribboncount = UILabel()
    
    
    var lbl_CurrentHighestScore = UILabel()
    var lbl_CurrentHighestScoreSingles = UILabel()
    
    let NewDoublesRankLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.backgroundColor = UIColor.lightGray
            label.textColor = .white // Set your desired text color
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 2.0 // Set your desired border width
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let NewSinglesRankLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.backgroundColor = UIColor.lightGray
            label.textColor = .white // Set your desired text color
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
    
    let DWP_Letter: UILabel = {
            let label = UILabel()
            label.textColor = .white // Set your desired text color
            label.text = "%:"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let SWP_Letter: UILabel = {
            let label = UILabel()
            label.textColor = .white // Set your desired text color
            label.text = "%:"
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
    
    var Doubles_WP_Label: UILabel = {
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
    
    
    let Singles_WP_Label: UILabel = {
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
        label.textColor = .black
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let lbl_SinglesNerdData: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
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
        
    
        
        view.addSubview(profileImageView)
       
        checkUserVerification()
        showLoadingView()
        
        // Load the user's profile image from Firestore
        loadProfileImage()
        
        // ... Your existing code ...
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
        let IconsPercentage: CGFloat = 2.10
        
        
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
      

        
        

        
        
        
        
        
        // Add profile image view to the view
        view.addSubview(profileImageView)
        
        // Set constraints for the profile image view
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40 * scalingFactor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5 * scalingFactor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150 * scalingFactor), // Increase the width
            profileImageView.heightAnchor.constraint(equalToConstant: 150 * scalingFactor) // Increase the height
        ])
        
        // Add tap gesture recognizer to the profile image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
        
        
        
        
        
        view.addSubview(UserNameLabelMain)

        if let customFont = UIFont(name: "Angel wish", size: 50.0 * scalingFactor) {
            UserNameLabelMain.font = customFont
            UserNameLabelMain.adjustsFontSizeToFitWidth = true // Allow text to resize to fit width
            UserNameLabelMain.minimumScaleFactor = 0.5 // Set a minimum scale factor as needed

            UserNameLabelMain.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                UserNameLabelMain.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20 * scalingFactor),
                UserNameLabelMain.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 15 * scalingFactor),
                //UserNameLabelMain.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15 * scalingFactor),
                UserNameLabelMain.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20 * scalingFactor) // Optional: Set a bottom constraint to define the bounds
            ])
        } else {
            // Handle the case where the custom font is not available
            print("Error: Custom font not available")
        }

        
        
        
       


        
        
        
        
        
        
        //GET DATA

        let db = Firestore.firestore()


        func GetHomeScreenData() {
            let uid = Auth.auth().currentUser!.email
            self.playersEmail = uid!
            
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
                    self.NewDoublesRankLabel.text = String(format: "%.2f", Int_Doubles_Rank!)
                    let rounded_int_doubles_rank = round(Int_Doubles_Rank! * 100) / 100.0
                    self.Player_DoublesRank = rounded_int_doubles_rank

                    //Singles Rank number to string conversion
                    let Singles_Rank = document!.data()!["Singles_Rank"]
                    let Singles_Rank_As_String = String(describing: Singles_Rank!)
                    let Int_Singles_Rank = Double(Singles_Rank_As_String)
                    self.NewSinglesRankLabel.text = String(format: "%.2f", Int_Singles_Rank!)
                    let rounded_int_singles_rank = round(Int_Singles_Rank! * 100) / 100.0
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

                    self.player = (document!.data()!["Username"] as? String)!
                    print(fetchRankDoubles())
                    print(fetchRankSingles())
                    
                    self.hasBadgeCountsGreaterThanZero {
                        // At this point, UserHasMessages has been set
                    }
                    
                    
                }
            }
        }


        //Calls the Username function
        print(GetHomeScreenData())
        
        
     





        func fetchRankDoubles() {
            let db = Firestore.firestore()

            self.userDataDictionary.removeAll()

            db.collection("Agressv_Users")
                .order(by: "Doubles_Rank", descending: false) // Order by ascending to get the lowest rank first
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            let username = data["Username"] as! String
                            
                            // Store the user's rank directly
                            if let rank = data["Doubles_Rank"] as? Double {
                                self.userDataDictionary[username, default: [:]]["Doubles_Rank"] = rank
                            }
                        }

                        // Sort usernames by the "Doubles_Rank" in ascending order
                        self.sortedUsernames = self.userDataDictionary.keys.sorted(by: {
                            (username1, username2) -> Bool in
                            return (self.userDataDictionary[username1]?["Doubles_Rank"] as? Double ?? Double.greatestFiniteMagnitude) <
                                   (self.userDataDictionary[username2]?["Doubles_Rank"] as? Double ?? Double.greatestFiniteMagnitude)
                        })

                        // Assign numerical order: the lowest rank gets the highest numerical value (1)
                        for (index, username) in self.sortedUsernames.enumerated() {
                            // The highest rank (lowest Doubles_Rank value) should get a numerical order of 1
                            let numericalOrder = Double(self.sortedUsernames.count - index)
                            self.userDataDictionary[username]?["Numerical_Order"] = numericalOrder
                        }
                        
                        // Update lbl_DoublesNerdData.text with the numerical order of the current player
                        if let numericalOrder = self.userDataDictionary[self.player]?["Numerical_Order"] {
                            let numericalOrderInt = Int(numericalOrder)
                            self.lbl_DoublesNerdData.text = "D: \(numericalOrderInt)"
                        }
                    }
                }
        }

        func fetchRankSingles() {
            let db = Firestore.firestore()

            self.userDataDictionarySingles.removeAll()

            db.collection("Agressv_Users")
                .order(by: "Singles_Rank", descending: false) // Order by ascending to get the lowest rank first
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            let username = data["Username"] as! String
                            
                            // Store the user's rank directly
                            if let rank = data["Singles_Rank"] as? Double {
                                self.userDataDictionary[username, default: [:]]["Singles_Rank"] = rank
                            }
                        }

                        // Sort usernames by the "Doubles_Rank" in ascending order
                        self.sortedUsernames = self.userDataDictionary.keys.sorted(by: {
                            (username1, username2) -> Bool in
                            return (self.userDataDictionary[username1]?["Singles_Rank"] as? Double ?? Double.greatestFiniteMagnitude) <
                                   (self.userDataDictionary[username2]?["Singles_Rank"] as? Double ?? Double.greatestFiniteMagnitude)
                        })

                        // Assign numerical order: the lowest rank gets the highest numerical value (1)
                        for (index, username) in self.sortedUsernames.enumerated() {
                            // The highest rank (lowest Doubles_Rank value) should get a numerical order of 1
                            let numericalOrder = Double(self.sortedUsernames.count - index)
                            self.userDataDictionary[username]?["Numerical_Order"] = numericalOrder
                        }
                        
                        // Update lbl_DoublesNerdData.text with the numerical order of the current player
                        if let numericalOrder = self.userDataDictionary[self.player]?["Numerical_Order"] {
                            let numericalOrderInt = Int(numericalOrder)
                            self.lbl_SinglesNerdData.text = "S: \(numericalOrderInt)"
                        }
                    }
                }
        }





      
        
       

        // Create the label
        let lbl_RanksTop = UILabel()
        lbl_RanksTop.text = "Current Rank"
        lbl_RanksTop.textColor = .black
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
      
    

        
        
        
        let fontSize: CGFloat = 25.0 // Set your default font size
     
                lbl_SinglesHeader.font = UIFont(name: "Impact", size: fontSize * scalingFactor)
                lbl_DoublesHeader.font = UIFont(name: "Impact", size: fontSize * scalingFactor)
           
      
        let xOffsetPercent: CGFloat = 0.22 // Default values (larger screens)
        
        

        
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
                    lbl_Games7Days.text = "Games played in last 7 days:"
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
        
        

        
        
        
        // Create buttons with actions and images
               let settingsButton = createButton(withImageName: "SettingsIconWhite")
               settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)

               let historyButton = createButton(withImageName: "GameHistoryIconWhite")
               historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)

               let PlayersButton = createButton(withImageName: "PlayersIconWhite")
               PlayersButton.addTarget(self, action: #selector(PlayersButtonTapped), for: .touchUpInside)

               let newGameButton = createButton(withImageName: "NewGameIconWhite")
               newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)

               // Add buttons to the view
               view.addSubview(settingsButton)
               view.addSubview(historyButton)
               view.addSubview(PlayersButton)
               view.addSubview(newGameButton)

        // Define layout guides for the leading and trailing edges
                let leadingGuide = UILayoutGuide()
                let trailingGuide = UILayoutGuide()
                view.addLayoutGuide(leadingGuide)
                view.addLayoutGuide(trailingGuide)
        
       


               // Set corner radius for all buttons and add a square border
               let cornerRadius: CGFloat = 15
               settingsButton.layer.cornerRadius = cornerRadius
               //settingsButton.layer.borderWidth = 1
               //settingsButton.layer.borderColor = UIColor.white.cgColor

               historyButton.layer.cornerRadius = cornerRadius
               //historyButton.layer.borderWidth = 1
               //historyButton.layer.borderColor = UIColor.white.cgColor

        PlayersButton.layer.cornerRadius = cornerRadius
        //PlayersButton.layer.borderWidth = 1
        //PlayersButton.layer.borderColor = UIColor.white.cgColor

               newGameButton.layer.cornerRadius = cornerRadius
               //newGameButton.layer.borderWidth = 1
               //newGameButton.layer.borderColor = UIColor.white.cgColor

        settingsButton.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
        historyButton.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
        PlayersButton.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
        newGameButton.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
           
        // Adjust the image size within the buttons
                settingsButton.imageView?.contentMode = .scaleAspectFit
                historyButton.imageView?.contentMode = .scaleAspectFit
                PlayersButton.imageView?.contentMode = .scaleAspectFit
                newGameButton.imageView?.contentMode = .scaleAspectFit
        
       
            
        
    func createButton(withImageName imageName: String) -> UIButton {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let image = UIImage(named: imageName) // Load the image from the asset catalog
            button.setImage(image, for: .normal)
            return button
        }
        
        
        func getHighestWinPercentage(playersEmail: String, completion: @escaping (Bool?, Error?) -> Void) {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email
            self.playersEmail = uid!
            let usersCollection = db.collection("Agressv_Users")

            usersCollection.getDocuments { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }

                

                for document in snapshot!.documents {
                    guard let gamesPlayed = document["Doubles_Games_Played"] as? Int,
                          let gamesWon = document["Doubles_Games_Wins"] as? Int else {
                        continue // Skip this document if the required fields are missing
                    }

                    let winPercentage = Double(gamesWon) / Double(gamesPlayed)

                    if winPercentage >= self.D_highestWinPercentage {
                        self.D_highestWinPercentage = winPercentage
                        
                    }

                    if let userEmail = document["Email"] as? String, userEmail == playersEmail {
                        self.D_currentUserWinPercentage = winPercentage
                        if winPercentage.isNaN {
                            self.Doubles_WP_Label.text = ""
                        
                        } else {
                            self.Doubles_WP_Label.text = String((winPercentage * 100).rounded())
                         
                        }
                    }
                }
                print("HIGHEST WIN PERCENTAGE!!!")
                print("highest: " + String(self.D_highestWinPercentage))
                print("user w p: " + String(self.D_currentUserWinPercentage))
                
             
                
                let userHasHighestWinPercentage = self.D_currentUserWinPercentage == self.D_highestWinPercentage
                completion(userHasHighestWinPercentage, nil)
            }
        }

       
        getHighestWinPercentage(playersEmail: playersEmail) { (userHasHighestWinPercentage, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                if let userHasHighestWinPercentage = userHasHighestWinPercentage {
                    print("User has the highest win percentage: \(userHasHighestWinPercentage)")
                    
                    if self.D_currentUserWinPercentage == self.D_highestWinPercentage {
                        
                        
                        NSLayoutConstraint.activate([
                            self.DWP_Letter.leadingAnchor.constraint(equalTo: self.DL_Letter.leadingAnchor),
                            self.DWP_Letter.topAnchor.constraint(equalTo: self.DL_Letter.bottomAnchor, constant: 20 * scalingFactor)
                            
                        ])
                        
                        // Set the text color for WP_Letter
                       // self.DWP_Letter.textColor = UIColor.systemYellow
                        
                        NSLayoutConstraint.activate([
                            self.Doubles_WP_Label.leadingAnchor.constraint(equalTo: self.DoublesWinsLabel.leadingAnchor),
                            self.Doubles_WP_Label.topAnchor.constraint(equalTo: self.DWP_Letter.topAnchor)
                            
                        ])
                        
                        // Set the text color for WP_Letter
                        //self.Doubles_WP_Label.textColor = UIColor.systemYellow
                        
                        
                    }
                    
                    else {
                        
                        
                        NSLayoutConstraint.activate([
                            self.DWP_Letter.leadingAnchor.constraint(equalTo: self.DL_Letter.leadingAnchor),
                            self.DWP_Letter.topAnchor.constraint(equalTo: self.DL_Letter.bottomAnchor, constant: 20 * scalingFactor)
                            
                        ])
                        
                        // Set the text color for WP_Letter
                        self.DWP_Letter.textColor = UIColor.white
                        
                        NSLayoutConstraint.activate([
                            self.Doubles_WP_Label.leadingAnchor.constraint(equalTo: self.DoublesWinsLabel.leadingAnchor),
                            self.Doubles_WP_Label.topAnchor.constraint(equalTo: self.DWP_Letter.topAnchor)
                            
                        ])
                        
                        // Set the text color for WP_Letter
                        self.Doubles_WP_Label.textColor = UIColor.white
                        
                    }
                }
            }
        }

      
        
        
        func getHighestSinglesWinPercentage(playersEmail: String, completion: @escaping (Bool?, Error?) -> Void) {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email
            self.playersEmail = uid!
            let usersCollection = db.collection("Agressv_Users")

            usersCollection.getDocuments { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }

                

                for document in snapshot!.documents {
                    guard let gamesPlayed = document["Singles_Games_Played"] as? Int,
                          let gamesWon = document["Singles_Games_Wins"] as? Int else {
                        continue // Skip this document if the required fields are missing
                    }

                    let winPercentage = Double(gamesWon) / Double(gamesPlayed)

                    if winPercentage >= self.S_highestWinPercentage {
                        self.S_highestWinPercentage = winPercentage
                        
                    }

                    if let userEmail = document["Email"] as? String, userEmail == playersEmail {
                        self.S_currentUserWinPercentage = winPercentage
                        if winPercentage.isNaN {
                            self.Singles_WP_Label.text = ""
                            
                        } else {
                            self.Singles_WP_Label.text = String((winPercentage * 100).rounded())
                            
                    
                        }
                    }
                }
                print("HIGHEST SINGLES WIN PERCENTAGE!!!")
                print("highest: " + String(self.S_highestWinPercentage))
                print("user w p: " + String(self.S_currentUserWinPercentage))
                
              
                
                let userHasHighestWinPercentage = self.S_currentUserWinPercentage == self.S_highestWinPercentage
                completion(userHasHighestWinPercentage, nil)
            }
        }

       
        getHighestSinglesWinPercentage(playersEmail: playersEmail) { (userHasHighestWinPercentage, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                if let userHasHighestWinPercentage = userHasHighestWinPercentage {
                    print("User has the highest win percentage: \(userHasHighestWinPercentage)")
                    
                    if self.S_currentUserWinPercentage == self.S_highestWinPercentage {
                        
                        
                        NSLayoutConstraint.activate([
                            self.SWP_Letter.leadingAnchor.constraint(equalTo: self.SL_Letter.leadingAnchor),
                            self.SWP_Letter.topAnchor.constraint(equalTo: self.SL_Letter.bottomAnchor, constant: 20 * scalingFactor)
                            
                        ])
                        
                        // Set the text color for WP_Letter
                        //self.SWP_Letter.textColor = UIColor.systemYellow
                        
                        NSLayoutConstraint.activate([
                            self.Singles_WP_Label.leadingAnchor.constraint(equalTo: self.SinglesWinsLabel.leadingAnchor),
                            self.Singles_WP_Label.topAnchor.constraint(equalTo: self.SWP_Letter.topAnchor)
                            
                        ])
                        
                        // Set the text color for WP_Letter
                        //self.Singles_WP_Label.textColor = UIColor.systemYellow
                        
                        
                    }
                    
                    else {
                        
                        
                        NSLayoutConstraint.activate([
                            self.SWP_Letter.leadingAnchor.constraint(equalTo: self.SL_Letter.leadingAnchor),
                            self.SWP_Letter.topAnchor.constraint(equalTo: self.SL_Letter.bottomAnchor, constant: 20 * scalingFactor)
                            
                        ])
                        
                        // Set the text color for WP_Letter
                        self.SWP_Letter.textColor = UIColor.white
                        
                        NSLayoutConstraint.activate([
                            self.Singles_WP_Label.leadingAnchor.constraint(equalTo: self.SinglesWinsLabel.leadingAnchor),
                            self.Singles_WP_Label.topAnchor.constraint(equalTo: self.SWP_Letter.topAnchor)
                            
                        ])
                        
                        // Set the text color for WP_Letter
                        self.Singles_WP_Label.textColor = UIColor.white
                        
                    }
                }
            }
        }
        
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
        view.addSubview(DWP_Letter)
        view.addSubview(Doubles_WP_Label)
        view.addSubview(SWP_Letter)
        view.addSubview(Singles_WP_Label)
               
        
        
        
        

        
        let buttons = [settingsButton, historyButton, PlayersButton, newGameButton]

        // Create a container stack view to hold the buttons
        let buttonsStackView = UIStackView(arrangedSubviews: buttons)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.spacing = 5 * IconsPercentage // Adjust spacing as needed
        view.addSubview(buttonsStackView)

        // Add constraints for the stack view
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -165 * scalingFactor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40 * scalingFactor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40 * scalingFactor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 65 * scalingFactor),
        ])

        // Set equal width and height constraints for each button
        buttons.forEach { button in
            button.widthAnchor.constraint(equalToConstant: 65 * scalingFactor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 65 * scalingFactor).isActive = true
        }


       


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
        let baseFontSize_lbl_NewGame: CGFloat = 14.0 // Set your base font size
        let adjustedFontSize_lbl_NewGame = baseFontSize_lbl_NewGame * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_NewGame.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_NewGame)
//
         //Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
           
            lbl_NewGame.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 3 * scalingFactor),
            lbl_NewGame.leadingAnchor.constraint(equalTo: newGameButton.leadingAnchor),
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
        let baseFontSize_lbl_Settings: CGFloat = 14.0 // Set your base font size
        let adjustedFontSize_lbl_Settings = baseFontSize_lbl_Settings * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_Settings.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_Settings)
//
         //Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
           
            lbl_Settings.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 3 * scalingFactor),
            lbl_Settings.leadingAnchor.constraint(equalTo: settingsButton.leadingAnchor),
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
        let baseFontSize_lbl_History: CGFloat = 14.0 // Set your base font size
        let adjustedFontSize_lbl_History = baseFontSize_lbl_History * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_History.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_History)
//
         //Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
           
            lbl_History.topAnchor.constraint(equalTo: historyButton.bottomAnchor, constant: 3 * scalingFactor),
            lbl_History.leadingAnchor.constraint(equalTo: historyButton.leadingAnchor, constant: 5 * scalingFactor),
            lbl_History.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
            lbl_History.heightAnchor.constraint(equalToConstant: 30 * scalingFactor) // Adjust the reference size as needed
        ])
        
        // Create the label
        let lbl_Badges = UILabel()
        lbl_Badges.text = "Players"
        lbl_Badges.textColor = .white
        lbl_Badges.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_Badges.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_Badges)

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_Badges: CGFloat = 14.0 // Set your base font size
        let adjustedFontSize_lbl_Badges = baseFontSize_lbl_Badges * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_Badges.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_Badges)
//
         //Define Auto Layout constraints to position and scale the label
        NSLayoutConstraint.activate([
           
            lbl_Badges.topAnchor.constraint(equalTo: PlayersButton.bottomAnchor, constant: 3 * scalingFactor),
            lbl_Badges.leadingAnchor.constraint(equalTo: PlayersButton.leadingAnchor, constant: 5 * scalingFactor),
            lbl_Badges.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
            lbl_Badges.heightAnchor.constraint(equalToConstant: 30 * scalingFactor) // Adjust the reference size as needed
        ])
//

        
        lbl_DoublesHeader.textColor = UIColor.white
        lbl_SinglesHeader.textColor = UIColor.white

        DL_Letter.textColor = UIColor.systemRed
        SL_Letter.textColor = UIColor.systemRed
        UserNameLabelMain.textColor = UIColor.black
        
        //Font aspects for Doubles Rank
        let DoublesRankFont = UIFont(name: "Impact", size: 30)
        
        let DoublesRankLabelC = NewDoublesRankLabel

        //DoublesRankLabel!.frame.origin = CGPoint(x: 65, y: 340)
       DoublesRankLabelC.textAlignment = .center
        DoublesRankLabelC.font = DoublesRankFont
        DoublesRankLabelC.adjustsFontSizeToFitWidth = true
        DoublesRankLabelC.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
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
        SinglesRankLabel.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
        //SinglesRankLabel.layer.borderColor = UIColor.red.cgColor
        //SinglesRankLabel.layer.borderWidth = 2.0
        SinglesRankLabel.layer.cornerRadius = 5
        SinglesRankLabel.clipsToBounds = true
        
        
        
        

        
        
        
        // Simulate loading for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            // Call a function to hide the loading view
            if self.UserHasMessages == true {
                self.createMessageLabel()
                
                NSLayoutConstraint.activate([
                    self.messageLabel!.bottomAnchor.constraint(equalTo: PlayersButton.topAnchor, constant: 7),
                    self.messageLabel!.leadingAnchor.constraint(equalTo: PlayersButton.trailingAnchor, constant: -15),
                    self.messageLabel!.widthAnchor.constraint(equalToConstant: 20),
                    self.messageLabel!.heightAnchor.constraint(equalToConstant: 20)
                    
                    
                        ])
            }
            
            
            self.hideLoadingView()
        }
        
        
        
       
        
        
    } //end of load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hasBadgeCountsGreaterThanZero {
            if !self.UserHasMessages {
                self.messageLabel?.isHidden = true
            } else {
                
            }
        }
        
       
    }
    
    
    func createMessageLabel() {
            // Create the label
            messageLabel = UILabel()
            messageLabel?.text = self.BadgeCountNumber
            messageLabel?.textColor = .white
            messageLabel?.backgroundColor = .red
            messageLabel?.textAlignment = .center
            messageLabel?.font = UIFont.systemFont(ofSize: 15)
            
        // Set a small size for the circular label
              
               messageLabel?.layer.cornerRadius = 10 // Half of the width/height for circular shape
               messageLabel?.clipsToBounds = true // Ensures the corners are clipped
        
            // Set the frame or constraints
            messageLabel?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(messageLabel!)
        
            
       
            
            // Bring label to the front
            view.bringSubviewToFront(messageLabel!)
        }

    
   


    func checkUserVerification() {
           let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.email
        self.playersEmail = uid!

           db.collection("Agressv_Users").document(uid!).getDocument { (document, error) in
               if let document = document, document.exists {
                   let data = document.data()
                   if let verifiedPro = data?["Verified_Pro"] as? Bool, verifiedPro {
                       // User is verified, add the verified image
                       self.addVerifiedImage()
                       print("RECOGNIZED BLUE CHECK MARK - VERIFIED PRO!!!!")
                   }
               } else {
                   print("Document does not exist or error: \(String(describing: error))")
               }
           }
       }

    func addVerifiedImage() {
        // Set up the verified image view
        let img_Verified_Pro = UIImageView(image: UIImage(named: "verified_pro"))
        img_Verified_Pro.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img_Verified_Pro)

        // Add constraints to position the verified image next to UserNameLabelMain
        NSLayoutConstraint.activate([
            img_Verified_Pro.leadingAnchor.constraint(equalTo: UserNameLabelMain.trailingAnchor, constant: 5),
            img_Verified_Pro.centerYAnchor.constraint(equalTo: UserNameLabelMain.centerYAnchor), // Vertically align with the label
            img_Verified_Pro.widthAnchor.constraint(equalToConstant: 30), // Set desired width
            img_Verified_Pro.heightAnchor.constraint(equalToConstant: 30) // Set desired height
        ])
        
        // Bring the verified image view to the front
        view.bringSubviewToFront(img_Verified_Pro)
    }
   
        
  
       
   
    
    
    
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()

           // Set corner radius to half of the image view's width
           profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.width
       }
    
    
    
    @objc func handleProfileImageTap() {
        // Show image picker when profile image is tapped
        showImagePicker()
    }
    
    func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
            alertController.addAction(choosePhotoAction)
        }

        // Add delete photo option
        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .destructive) { _ in
            self.deletePhoto()
        }
        alertController.addAction(deletePhotoAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    func deletePhoto() {
        // Check if there's an existing document reference
        if let currentUserProfileImageRef = currentUserProfileImageRef {
            // Delete the document from Firestore
            currentUserProfileImageRef.delete { error in
                if let error = error {
                    print("Error deleting image from Firestore: \(error.localizedDescription)")
                } else {
                    print("Image deleted from Firestore successfully!")
                    // Reset the profile image view to a default image or nil
                    self.profileImageView.image = UIImage(named: "DefaultPlayerImage")
                }
            }
        } else {
            // Handle the case where there's no existing document reference
            print("Error: No existing document reference to delete.")
        }
    }
        
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            // Update the profile image view with the selected image
            profileImageView.image = pickedImage
            
            // Upload the image to Firestore
            uploadImageToFirestore(image: pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirestore(image: UIImage) {
        
        // Convert the UIImage to Data
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            // Check if there's an existing document reference
            if let currentUserProfileImageRef = currentUserProfileImageRef {
                // Update the existing document with the new image data
                currentUserProfileImageRef.setData(["User_Img": imageData]) { error in
                    if let error = error {
                        print("Error updating image in Firestore: \(error.localizedDescription)")
                    } else {
                        print("Image updated in Firestore successfully!")
                    }
                }
            } else {
                // If there's no existing document reference, create a new one
                let uid = Auth.auth().currentUser?.email
                let collectionRef = Firestore.firestore().collection("Agressv_ProfileImages")
                
                // Use the user's email as the document ID
                if let uid = uid {
                    let documentRef = collectionRef.document(uid)
                    
                    // Save the reference for future updates
                    currentUserProfileImageRef = documentRef
                    
                    // Upload the image data to Firestore
                    documentRef.setData(["User_Img": imageData]) { error in
                        if let error = error {
                            print("Error uploading image to Firestore: \(error.localizedDescription)")
                        } else {
                            print("Image uploaded to Firestore successfully!")
                        }
                    }
                } else {
                    // Handle the case where the user's email is not available
                    print("Error: User email is nil.")
                }
            }
        }
    }

    
    

    
    func loadProfileImage() {
        // Load the user's profile image from Firestore
        
        guard let uid = Auth.auth().currentUser?.email else {
            // Handle the case where the user's email is not available
            return
        }
        
        let docRef = db.collection("Agressv_ProfileImages").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, retrieve and set the profile image
                if let imageData = document.data()?["User_Img"] as? Data {
                    self.profileImageView.image = UIImage(data: imageData)
                } else {
                    // Handle the case where the "User_Img" field does not contain valid image data
                    self.profileImageView.image = UIImage(named: "DefaultPlayerImage")
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
    
    
    @objc func PlayersButtonTapped() {
        // Create an instance of opp two VC
//        let PlayersVC = storyboard?.instantiateViewController(withIdentifier: "PlayersID") as! PlayersSearchViewController
//
//        // Push to the SecondViewController
//        navigationController?.pushViewController(PlayersVC, animated: true)
        
        
        //for testing
        
        let PlayersVC = storyboard?.instantiateViewController(withIdentifier: "NewPlayerSearchID") as! NewPlayerSearchVC
        
        // Push to the SecondViewController
        navigationController?.pushViewController(PlayersVC, animated: true)
        
        
        }
    
    
    
    
    func hasBadgeCountsGreaterThanZero(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        // Reference to the user's document
        let userRef = db.collection("Agressv_BadgeCounts").document(playersEmail)
        
        // Reference to the subcollection GroupName_ForBadge
        let groupRef = userRef.collection("GroupName_ForBadge")

        // Get documents from the subcollection
        groupRef.getDocuments { (subQuerySnapshot, error) in
            if let error = error {
                print("Error getting sub-collection documents: \(error)")
                self.UserHasMessages = false
                completion()
                return
            }

            if let subDocuments = subQuerySnapshot?.documents {
                for subDocument in subDocuments {
                    if let badgeCount = subDocument.data()["BadgeCount"] as? Int, badgeCount > 0 {
                        self.UserHasMessages = true
                        self.BadgeCountNumber = String(badgeCount)
                        
                        completion()
                        return
                    }
                }
            }
            
            // If no badge counts were found > 0
            self.UserHasMessages = false
            completion()
        }
    }
    
    
    
} // end of class
