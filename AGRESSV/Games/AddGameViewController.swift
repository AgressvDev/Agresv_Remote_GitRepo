//
//  AddGameViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/18/23.
//

import UIKit
import UIKit
import Firebase
import FirebaseFirestore


class AddGameViewController: UIViewController {
    
    
   
    

    
 //for Badge evaluations
    var current_user_after_log_doubles_rank: Double = 0.0
    var partner_user_after_log_doubles_rank: Double = 0.0
    var oppone_user_after_log_doubles_rank: Double = 0.0
    var opptwo_user_after_log_doubles_rank: Double = 0.0

    var Highest_Score_Doubles: Double = 0.0
    var Highest_Score_Singles: Double = 0.0
    
    var CurrentUserSinglesRank: Double = 0.0
    var PartnerSinglesRank: Double = 0.0
    var OppOneSinglesRank: Double = 0.0
    var OppTwoSinglesRank: Double = 0.0
    
    var CurrentISHighestDoubles: Bool = false
    var PartnerISHighestDoubles: Bool = false
    var OppOneISHighestDoubles: Bool = false
    var OppTwoISHighestDoubles: Bool = false
    
   //VARIABLES TO HOLD SUMS OF PLAYERS RANKINGS
    var CurrentUser_PercentDiff_Increment: Double = 0.0
    var Partner_PercentDiff_Increment: Double = 0.0
    var OppOne_PercentDiff_Increment: Double = 0.0
    var OppTwo_PercentDiff_Increment: Double = 0.0
    
    //STRING RANKS FOR DISPLAY
    var CurrentUserDoublesRank: Double = 0.0
    var PartnerDoublesRank: Double = 0.0
    var OppOneDoublesRank: Double = 0.0
    var OppTwoDoublesRank: Double = 0.0
    
    //Displaying game players
    var currentuser: String = ""
    var selectedCellValue: String = SharedData.shared.PartnerSelection//Partner
    var selectedCellValueOppOne: String =  SharedData.shared.OppOneSelection//Opp One
    var selectedCellValueOppTwo: String = SharedData.shared.OppTwoSelection // Opp Two
    
    //Use for queries Usernames without the Rank string
    var CurrentUser_Username_NoRank: String = ""
    var PartnerCellValue_NoRank: String = SharedDataNoRank.sharednorank.PartnerSelection_NoRank
    var OppOneCellValue_NoRank: String = SharedDataNoRank.sharednorank.OppOneSelection_NoRank
    var OppTwoCellValue_NoRank: String = SharedDataNoRank.sharednorank.OppTwoSelection_NoRank
    
   //For posting to Agressv_Games table to enable rolling 7 day count of games played
    var selectedCellValueEmail: String = ""
    var selectedCellValueOppOneEmail: String = ""
    var selectedCellValueOppTwoEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
        let marginPercentage: CGFloat = 0.07
        
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
        
        // Create a button
        let button = UIButton(type: .system)
        button.setTitle("Log Game", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8 // Adjust corner radius as needed
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.bringSubviewToFront(button)
        
         // Adjust this value as needed
        // Define constraints for the button
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60 * scalingFactor), // Adjust the constant for desired spacing from the bottom
            button.widthAnchor.constraint(equalToConstant: 400 * widthScalingFactor), // Adjust the width as needed
            button.heightAnchor.constraint(equalToConstant: 80 * heightScalingFactor)  // Adjust the height as needed
        ])
        
        // Add an action to the button
        button.addTarget(self, action: #selector(btn_Log(_:)), for: .touchUpInside)
        
        
        if let dobermanleft = UIImage(named: "DogLfilled.png") {
            let myImageViewdl = UIImageView()
            myImageViewdl.contentMode = .scaleAspectFit
            myImageViewdl.image = dobermanleft
            myImageViewdl.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
            
            // Add the image view to the view hierarchy
            view.addSubview(myImageViewdl)
            view.bringSubviewToFront(myImageViewdl)
            
            myImageViewdl.layer.zPosition = 3
            // Define Auto Layout constraints to position and scale the image
            NSLayoutConstraint.activate([
                myImageViewdl.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: -20 * scalingFactor),
                myImageViewdl.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -550 * scalingFactor),
                myImageViewdl.widthAnchor.constraint(equalToConstant: 120 * scalingFactor), // Adjust the reference size as needed
                myImageViewdl.heightAnchor.constraint(equalToConstant: 120 * scalingFactor), // Adjust the reference size as needed
            ])
            
      
        }
        
        if let dobermanleft2 = UIImage(named: "DogLfilled.png") {
            let myImageViewdl = UIImageView()
            myImageViewdl.contentMode = .scaleAspectFit
            myImageViewdl.image = dobermanleft2
            myImageViewdl.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
            
            // Add the image view to the view hierarchy
            view.addSubview(myImageViewdl)
            
            
            myImageViewdl.layer.zPosition = 2
            // Define Auto Layout constraints to position and scale the image
            NSLayoutConstraint.activate([
                myImageViewdl.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20 * scalingFactor),
                myImageViewdl.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -560 * scalingFactor),
                myImageViewdl.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
                myImageViewdl.heightAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
            ])
            
      
        }
        
        if let dobermanright = UIImage(named: "DogRfilled.png") {
            let myImageViewdl = UIImageView()
            myImageViewdl.contentMode = .scaleAspectFit
            myImageViewdl.image = dobermanright
            myImageViewdl.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
            
            // Add the image view to the view hierarchy
            view.addSubview(myImageViewdl)
            view.bringSubviewToFront(myImageViewdl)
            
            myImageViewdl.layer.zPosition = 3
            // Define Auto Layout constraints to position and scale the image
            NSLayoutConstraint.activate([
                myImageViewdl.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 20 * scalingFactor),
                myImageViewdl.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -550 * scalingFactor),
                myImageViewdl.widthAnchor.constraint(equalToConstant: 120 * scalingFactor), // Adjust the reference size as needed
                myImageViewdl.heightAnchor.constraint(equalToConstant: 120 * scalingFactor), // Adjust the reference size as needed
            ])
            
      
        }
        
        if let dobermanright2 = UIImage(named: "DogRfilled.png") {
            let myImageViewdl = UIImageView()
            myImageViewdl.contentMode = .scaleAspectFit
            myImageViewdl.image = dobermanright2
            myImageViewdl.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
            
            // Add the image view to the view hierarchy
            view.addSubview(myImageViewdl)
           
            
            myImageViewdl.layer.zPosition = 2
            // Define Auto Layout constraints to position and scale the image
            NSLayoutConstraint.activate([
                myImageViewdl.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20 * scalingFactor),
                myImageViewdl.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -560 * scalingFactor),
                myImageViewdl.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
                myImageViewdl.heightAnchor.constraint(equalToConstant: 100 * scalingFactor), // Adjust the reference size as needed
            ])
            
      
        }
        
        // Create a UIColor with the desired light blueish gray color
        let lightBlueishGrayColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)
        
        // Create a label
        let lbl_OppTwo = UILabel()
        lbl_OppTwo.textAlignment = .center
        lbl_OppTwo.textColor = .black
        lbl_OppTwo.backgroundColor = lightBlueishGrayColor //UIColor(red: 100.0, green: 0.8, blue: 0.8, alpha: 2.0) // Light red background color
        lbl_OppTwo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl_OppTwo)
        view.bringSubviewToFront(lbl_OppTwo)
        
    
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_OppTwo: CGFloat = 17.0 // Set your base font size
        let adjustedFontSize_lbl_OppTwo = baseFontSize_lbl_OppTwo * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_OppTwo.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_OppTwo)

        // Define constraints for lbl_OppTwo
        NSLayoutConstraint.activate([
            lbl_OppTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            lbl_OppTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            lbl_OppTwo.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -210 * scalingFactor), // Place it above the button with spacing
            lbl_OppTwo.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])
        
        // Create a label
        let lbl_OppOne = UILabel()
        lbl_OppOne.textAlignment = .center
        lbl_OppOne.textColor = .black
        lbl_OppOne.backgroundColor = lightBlueishGrayColor //UIColor(red: 100.0, green: 0.8, blue: 0.8, alpha: 2.0) // Light red background color
        lbl_OppOne.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl_OppOne)
        view.bringSubviewToFront(lbl_OppOne)
        
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_OppOne: CGFloat = 17.0 // Set your base font size
        let adjustedFontSize_lbl_OppOne = baseFontSize_lbl_OppOne * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_OppOne.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_OppOne)

        // Define constraints for lbl_OppTwo
        NSLayoutConstraint.activate([
            lbl_OppOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            lbl_OppOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            lbl_OppOne.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -270 * scalingFactor), // Place it above the button with spacing
            lbl_OppOne.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])
        
        
        
        
        // Create a label
        let lbl_Partner = UILabel()
        lbl_Partner.textAlignment = .center
        lbl_Partner.textColor = .black
        lbl_Partner.backgroundColor = lightBlueishGrayColor //UIColor(red: 100.0, green: 0.8, blue: 0.8, alpha: 2.0) // Light red background color
        lbl_Partner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl_Partner)
        view.bringSubviewToFront(lbl_Partner)
        
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_Partner: CGFloat = 17.0 // Set your base font size
        let adjustedFontSize_lbl_Partner = baseFontSize_lbl_Partner * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_Partner.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_Partner)

        // Define constraints for lbl_OppTwo
        NSLayoutConstraint.activate([
            lbl_Partner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            lbl_Partner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            lbl_Partner.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -400 * scalingFactor), // Place it above the button with spacing
            lbl_Partner.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])
        
        
        
        // Create a label
        let lbl_CurrentUser = UILabel()
        lbl_CurrentUser.textAlignment = .center
        lbl_CurrentUser.textColor = .black
        lbl_CurrentUser.backgroundColor = lightBlueishGrayColor //UIColor(red: 100.0, green: 0.8, blue: 0.8, alpha: 2.0) // Light red background color
        lbl_CurrentUser.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl_CurrentUser)
        view.bringSubviewToFront(lbl_CurrentUser)
        
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_CurrentUser: CGFloat = 17.0 // Set your base font size
        let adjustedFontSize_lbl_CurrentUser = baseFontSize_lbl_CurrentUser * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_CurrentUser.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_CurrentUser)

        // Define constraints for lbl_OppTwo
        NSLayoutConstraint.activate([
            lbl_CurrentUser.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            lbl_CurrentUser.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            lbl_CurrentUser.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -460 * scalingFactor), // Place it above the button with spacing
            lbl_CurrentUser.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])
        
        
        // Create a label
        let lbl_VS = UILabel()
        lbl_VS.textAlignment = .center
        lbl_VS.text = "VS."
        lbl_VS.textColor = .white
        
        lbl_VS.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl_VS)
        view.bringSubviewToFront(lbl_VS)
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_VS: CGFloat = 35.0 // Set your base font size
        let adjustedFontSize_lbl_VS = baseFontSize_lbl_VS * scalingFactor
        
        
        
        // Set the font size for lbl_Playometer
        lbl_VS.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_VS)

        // Define constraints for lbl_OppTwo
        NSLayoutConstraint.activate([
            lbl_VS.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            lbl_VS.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            lbl_VS.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -335 * scalingFactor), // Place it above the button with spacing
            lbl_VS.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])
        
        let fontsize: CGFloat = 45

        // Calculate the adjusted font size based on the scalingFactor
        let adjustedFontSize_lbl_Doubles = fontsize * scalingFactor

        // Create a label
        let lbl_Doubles = UILabel()
        lbl_Doubles.textAlignment = .center
        lbl_Doubles.text = "Doubles"
        lbl_Doubles.textColor = .white
        lbl_Doubles.font = UIFont(name: "Impact", size: adjustedFontSize_lbl_Doubles) // Set the font with the adjusted size
        lbl_Doubles.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl_Doubles)
        view.bringSubviewToFront(lbl_Doubles)

        // Define constraints for lbl_OppTwo
        NSLayoutConstraint.activate([
            lbl_Doubles.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            lbl_Doubles.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            lbl_Doubles.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -600 * scalingFactor), // Place it above the button with spacing
            lbl_Doubles.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])
        
        // Create a label
        let gameresult_prompt = UILabel()
        gameresult_prompt.textAlignment = .center
        gameresult_prompt.textColor = .white
        gameresult_prompt.text = "Did you win or lose?"
        gameresult_prompt.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameresult_prompt)
        view.bringSubviewToFront(gameresult_prompt)
        
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_gameresult_prompt: CGFloat = 16.0 // Set your base font size
        let adjustedFontSize_lbl_gameresult_prompt = baseFontSize_lbl_gameresult_prompt * scalingFactor

        // Set the font size for lbl_Playometer
        gameresult_prompt.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_gameresult_prompt)

        // Define constraints for the segmented control
        NSLayoutConstraint.activate([
            gameresult_prompt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1), // Adjust the leading spacing
            gameresult_prompt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.1), // Adjust the trailing spacing
            gameresult_prompt.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -120 * scalingFactor), // Place it above the button with spacing
            gameresult_prompt.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])
        
        // Create a segmented control
        
        // Define a custom green color
        let customGreen = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) // Adjust the RGB values as needed
        
        let seg_WLOutlet = UISegmentedControl(items: ["Won", "Lost"])
        seg_WLOutlet.selectedSegmentIndex = 0
        seg_WLOutlet.tintColor = customGreen
        seg_WLOutlet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(seg_WLOutlet)

        // Customize the text color for individual segments
        seg_WLOutlet.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected) // Set "Won" to green
        seg_WLOutlet.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)    // Set "Lost" to red
        
        // Add a target action to handle segment value changes
            seg_WLOutlet.addTarget(self, action: #selector(seg_WL(_:)), for: .valueChanged)
        
        // Define constraints for the segmented control
        NSLayoutConstraint.activate([
            seg_WLOutlet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1), // Adjust the leading spacing
                seg_WLOutlet.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.1), // Adjust the trailing spacing
            seg_WLOutlet.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -70 * scalingFactor), // Place it above the button with spacing
            seg_WLOutlet.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])

        
        
        
        
    func getcurrentuser() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.email
        let docRef = db.collection("Agressv_Users").document(uid!)
        
        docRef.getDocument { (document, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                print("\(document!.documentID) => \(String(describing: document!.data()))")
                
                //                    let CurrentUser = document!.data()!["Username"]
                //                    let Current_User_As_String = String(describing: CurrentUser!)
                if let username = document?["Username"] as? String,
                   let doublesRank = document?["Doubles_Rank"] as? Double {
                    let formattedRank = String(format: "%.1f", doublesRank)
                    let userWithFormattedRank = "\(username) - \(formattedRank)"
                    let norank = "\(username)"
                    self.currentuser = userWithFormattedRank
                    lbl_CurrentUser.text = self.currentuser
                    self.CurrentUser_Username_NoRank = norank
                  
                    
                }
            }
        }
    }
            
       
        
        
        
        func GetCurrentUserRank() {
            let db = Firestore.firestore()
            
            // Get the current user's email
            guard let uid = Auth.auth().currentUser?.email else {
                print("No current user")
                return
            }
            
            let documentRef = db.collection("Agressv_Users").document(uid)

            documentRef.getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    if let document = documentSnapshot, document.exists {
                        if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
                            // Convert the Double to a String
//                            let doublesRankAsString = String(format: "%.1f", doublesRank)
//                            self.CurrentUserDoublesRank = doublesRankAsString
                            let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
                            // Update the label here (on the main thread)
                            DispatchQueue.main.async {
                                // Assuming you have a label called lbl_CurrentUserRank
                                self.CurrentUserDoublesRank = currentUserRank
                            }
                        } else {
                            print("Doubles_Rank is not a valid number in the document")
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
        
        
       

        
        
        
        
        func GetPartnerEmail() {
            let db = Firestore.firestore()
            let uid = PartnerCellValue_NoRank
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerEmail = document.data()["Email"] as? String

                            self.selectedCellValueEmail = PartnerEmail!


                        }




                    }
                }
            }

        
       
      


        
    
        
        func GetOppOneEmail() {
            let db = Firestore.firestore()
            let uid = OppOneCellValue_NoRank
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerEmail = document.data()["Email"] as? String
                        if let PartnerEmail = PartnerEmail {
                            self.selectedCellValueOppOneEmail = PartnerEmail
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        
        
        
        
        func GetOppTwoEmail() {
            let db = Firestore.firestore()
            let uid = OppTwoCellValue_NoRank
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerEmail = document.data()["Email"] as? String
                        if let PartnerEmail = PartnerEmail {
                            self.selectedCellValueOppTwoEmail = PartnerEmail
                        } else {
                            return
                        }




                    }
                }
            }
        }



     
        
        
        func GetPartnerRank() {
            let db = Firestore.firestore()
            let uid = PartnerCellValue_NoRank
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        if let doublesRank = document.data()["Doubles_Rank"] as? Double {
                            let PartnerUserRank = (doublesRank * 10.0).rounded() / 10.0

                            // Update the label here
                            DispatchQueue.main.async {
                                self.PartnerDoublesRank = PartnerUserRank
                            }
                        } else {
                            print("Doubles_Rank is not a valid number in document with ID: \(document.documentID)")
                        }
                    }
                }
            }
        }
        
        
        
        
        
       
        func GetOppOneRank() {
            let db = Firestore.firestore()
            let uid = OppOneCellValue_NoRank
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        if let doublesRank = document.data()["Doubles_Rank"] as? Double {
                            let OppOneUserRank = (doublesRank * 10.0).rounded() / 10.0

                            // Update the label here
                            DispatchQueue.main.async {
                                self.OppOneDoublesRank = OppOneUserRank
                            }
                        } else {
                            print("Doubles_Rank is not a valid number in document with ID: \(document.documentID)")
                        }
                    }
                }
            }
        }

        
        
        func GetOppTwoRank() {
            let db = Firestore.firestore()
            let uid = OppTwoCellValue_NoRank
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        if let doublesRank = document.data()["Doubles_Rank"] as? Double {
                            let OppTwoUserRank = (doublesRank * 10.0).rounded() / 10.0

                            // Update the label here
                            DispatchQueue.main.async {
                                self.OppTwoDoublesRank = OppTwoUserRank
                            }
                        } else {
                            print("Doubles_Rank is not a valid number in document with ID: \(document.documentID)")
                        }
                    }
                }
            }
        }
        
        
        
        
        
        
       
      
  
        print(getcurrentuser())
        print(GetCurrentUserRank())
      
        
        
        print(GetPartnerEmail())
        print(GetOppOneEmail())
        print(GetOppTwoEmail())
        
        print(GetPartnerRank())
        print(GetOppOneRank())
        print(GetOppTwoRank())
        
  
       
        
        lbl_Partner.text = selectedCellValue
        lbl_OppOne.text = selectedCellValueOppOne
        lbl_OppTwo.text = selectedCellValueOppTwo
        
       
        
       
        
        
    } //end of load
    
    func GetCurrentUserRankSecond() {
        let db = Firestore.firestore()
        
        // Get the current user's email
        guard let uid = Auth.auth().currentUser?.email else {
            print("No current user")
            return
        }
        
        let documentRef = db.collection("Agressv_Users").document(uid)

        documentRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
                        // Convert the Double to a String
//                            let doublesRankAsString = String(format: "%.1f", doublesRank)
//                            self.CurrentUserDoublesRank = doublesRankAsString
                        let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
                        // Update the label here (on the main thread)
                        DispatchQueue.main.async {
                            // Assuming you have a label called lbl_CurrentUserRank
                            self.CurrentUserDoublesRank = currentUserRank
                        }
                    } else {
                        print("Doubles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func GetSinglesRanks(completion: @escaping () -> Void) {
            let db = Firestore.firestore()
                    
            
            // Get the current user's email
            guard let uid = Auth.auth().currentUser?.email else {
                print("No current user")
                return
            }
        
            let Partner_uid = selectedCellValueEmail
            let Partner_ref = db.collection("Agressv_Users").document(Partner_uid)

            let OppOne_uid = selectedCellValueOppOneEmail
            let OppOne_ref = db.collection("Agressv_Users").document(OppOne_uid)
            
            let OppTwo_uid = selectedCellValueOppTwoEmail
            let OppTwo_ref = db.collection("Agressv_Users").document(OppTwo_uid)
            
            let documentRef = db.collection("Agressv_Users").document(uid)

            documentRef.getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    if let document = documentSnapshot, document.exists {
                        if let doublesRank = document.data()?["Singles_Rank"] as? Double {
                            // Convert the Double to a String
    //                            let doublesRankAsString = String(format: "%.1f", doublesRank)
    //                            self.CurrentUserDoublesRank = doublesRankAsString
                            let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
                            // Update the label here (on the main thread)
                            DispatchQueue.main.async {
                                // Assuming you have a label called lbl_CurrentUserRank
                                self.CurrentUserSinglesRank = currentUserRank
                                
                            }
                        } else {
                            print("Doubles_Rank is not a valid number in the document")
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        
        Partner_ref.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let doublesRank = document.data()?["Singles_Rank"] as? Double {
                        // Convert the Double to a String
//                            let doublesRankAsString = String(format: "%.1f", doublesRank)
//                            self.CurrentUserDoublesRank = doublesRankAsString
                        let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
                        // Update the label here (on the main thread)
                        DispatchQueue.main.async {
                            // Assuming you have a label called lbl_CurrentUserRank
                            self.PartnerSinglesRank = currentUserRank
                            
                        }
                    } else {
                        print("Doubles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        OppOne_ref.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let doublesRank = document.data()?["Singles_Rank"] as? Double {
                        // Convert the Double to a String
//                            let doublesRankAsString = String(format: "%.1f", doublesRank)
//                            self.CurrentUserDoublesRank = doublesRankAsString
                        let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
                        // Update the label here (on the main thread)
                        DispatchQueue.main.async {
                            // Assuming you have a label called lbl_CurrentUserRank
                            self.OppOneSinglesRank = currentUserRank
                           
                        }
                    } else {
                        print("Doubles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        OppTwo_ref.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let doublesRank = document.data()?["Singles_Rank"] as? Double {
                        // Convert the Double to a String
//                            let doublesRankAsString = String(format: "%.1f", doublesRank)
//                            self.CurrentUserDoublesRank = doublesRankAsString
                        let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
                        // Update the label here (on the main thread)
                        DispatchQueue.main.async {
                            // Assuming you have a label called lbl_CurrentUserRank
                            self.OppTwoSinglesRank = currentUserRank
                            completion()
                        }
                    } else {
                        print("Doubles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        }
    
    
    func GetHighScoresInitial(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
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
                                
                                if self.CurrentUserDoublesRank == self.Highest_Score_Doubles
                                    {
                                    self.CurrentISHighestDoubles = true
                                    }
                                if self.PartnerDoublesRank == self.Highest_Score_Doubles
                                    {
                                    self.PartnerISHighestDoubles = true
                                    }
                                if self.OppOneDoublesRank == self.Highest_Score_Doubles
                                    {
                                    self.OppOneISHighestDoubles = true
                                    }
                                if self.OppTwoDoublesRank == self.Highest_Score_Doubles
                                    {
                                    self.OppTwoISHighestDoubles = true
                                    }
                                
                                completion()
                            }
                            
                        }
                    
                }
                
            }
        
    }
    
    
    func GetHighScores(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
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
                                
                                completion()
                            }
                            
                        }
                    
                }
                
            }
        
    }
    
   

    
//    func GetCurrentUserRankAfter(completion: @escaping () -> Void) {
//            let db = Firestore.firestore()
//
//
//            // Get the current user's email
//            guard let uid = Auth.auth().currentUser?.email else {
//                print("No current user")
//                return
//            }
//
//            let Partner_uid = selectedCellValueEmail
//            let Partner_ref = db.collection("Agressv_Users").document(Partner_uid)
//
//            let OppOne_uid = selectedCellValueOppOneEmail
//            let OppOne_ref = db.collection("Agressv_Users").document(OppOne_uid)
//
//            let OppTwo_uid = selectedCellValueOppTwoEmail
//            let OppTwo_ref = db.collection("Agressv_Users").document(OppTwo_uid)
//
//            let documentRef = db.collection("Agressv_Users").document(uid)
//
//            documentRef.getDocument { (documentSnapshot, error) in
//                if let error = error {
//                    print("Error: \(error)")
//                } else {
//                    if let document = documentSnapshot, document.exists {
//                        if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
//                            // Convert the Double to a String
//    //                            let doublesRankAsString = String(format: "%.1f", doublesRank)
//    //                            self.CurrentUserDoublesRank = doublesRankAsString
//                            let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
//                            // Update the label here (on the main thread)
//                            DispatchQueue.main.async {
//                                // Assuming you have a label called lbl_CurrentUserRank
//                                self.current_user_after_log_doubles_rank = currentUserRank
//
//                            }
//                        } else {
//                            print("Doubles_Rank is not a valid number in the document")
//                        }
//                    } else {
//                        print("Document does not exist")
//                    }
//                }
//            }
//
//        Partner_ref.getDocument { (documentSnapshot, error) in
//            if let error = error {
//                print("Error: \(error)")
//            } else {
//                if let document = documentSnapshot, document.exists {
//                    if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
//                        // Convert the Double to a String
////                            let doublesRankAsString = String(format: "%.1f", doublesRank)
////                            self.CurrentUserDoublesRank = doublesRankAsString
//                        let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
//                        // Update the label here (on the main thread)
//                        DispatchQueue.main.async {
//                            // Assuming you have a label called lbl_CurrentUserRank
//                            self.partner_user_after_log_doubles_rank = currentUserRank
//
//                        }
//                    } else {
//                        print("Doubles_Rank is not a valid number in the document")
//                    }
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
//
//        OppOne_ref.getDocument { (documentSnapshot, error) in
//            if let error = error {
//                print("Error: \(error)")
//            } else {
//                if let document = documentSnapshot, document.exists {
//                    if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
//                        // Convert the Double to a String
////                            let doublesRankAsString = String(format: "%.1f", doublesRank)
////                            self.CurrentUserDoublesRank = doublesRankAsString
//                        let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
//                        // Update the label here (on the main thread)
//                        DispatchQueue.main.async {
//                            // Assuming you have a label called lbl_CurrentUserRank
//                            self.oppone_user_after_log_doubles_rank = currentUserRank
//
//                        }
//                    } else {
//                        print("Doubles_Rank is not a valid number in the document")
//                    }
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
//
//        OppTwo_ref.getDocument { (documentSnapshot, error) in
//            if let error = error {
//                print("Error: \(error)")
//            } else {
//                if let document = documentSnapshot, document.exists {
//                    if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
//                        // Convert the Double to a String
////                            let doublesRankAsString = String(format: "%.1f", doublesRank)
////                            self.CurrentUserDoublesRank = doublesRankAsString
//                        let currentUserRank = (doublesRank * 10.0).rounded() / 10.0
//                        // Update the label here (on the main thread)
//                        DispatchQueue.main.async {
//                            // Assuming you have a label called lbl_CurrentUserRank
//                            self.opptwo_user_after_log_doubles_rank = currentUserRank
//                            completion()
//                        }
//                    } else {
//                        print("Doubles_Rank is not a valid number in the document")
//                    }
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
//
//
//        }

    func GetCurrentUserRankAfter(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        var currentUserRank: Double?
        var partnerRank: Double?
        var oppOneRank: Double?
        var oppTwoRank: Double?
        
        let dispatchGroup = DispatchGroup()
        
        // Get the current user's email
        guard let uid = Auth.auth().currentUser?.email else {
            print("No current user")
            return
        }
        
        let Partner_uid = selectedCellValueEmail
        let Partner_ref = db.collection("Agressv_Users").document(Partner_uid)
        
        let OppOne_uid = selectedCellValueOppOneEmail
        let OppOne_ref = db.collection("Agressv_Users").document(OppOne_uid)
        
        let OppTwo_uid = selectedCellValueOppTwoEmail
        let OppTwo_ref = db.collection("Agressv_Users").document(OppTwo_uid)
        
        let documentRef = db.collection("Agressv_Users").document(uid)
        
        dispatchGroup.enter()
        documentRef.getDocument { (documentSnapshot, error) in
            defer { dispatchGroup.leave() }
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
                        currentUserRank = (doublesRank * 10.0).rounded() / 10.0
                    } else {
                        print("Doubles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        dispatchGroup.enter()
        Partner_ref.getDocument { (documentSnapshot, error) in
            defer { dispatchGroup.leave() }
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
                        partnerRank = (doublesRank * 10.0).rounded() / 10.0
                    } else {
                        print("Doubles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        dispatchGroup.enter()
        OppOne_ref.getDocument { (documentSnapshot, error) in
            defer { dispatchGroup.leave() }
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
                        oppOneRank = (doublesRank * 10.0).rounded() / 10.0
                    } else {
                        print("Doubles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        dispatchGroup.enter()
        OppTwo_ref.getDocument { (documentSnapshot, error) in
            defer { dispatchGroup.leave() }
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let doublesRank = document.data()?["Doubles_Rank"] as? Double {
                        oppTwoRank = (doublesRank * 10.0).rounded() / 10.0
                    } else {
                        print("Doubles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // All Firestore calls have completed here
            if let currentUserRank = currentUserRank, let partnerRank = partnerRank, let oppOneRank = oppOneRank, let oppTwoRank = oppTwoRank {
                self.current_user_after_log_doubles_rank = currentUserRank
                self.partner_user_after_log_doubles_rank = partnerRank
                self.oppone_user_after_log_doubles_rank = oppOneRank
                self.opptwo_user_after_log_doubles_rank = oppTwoRank
            }
            completion()
        }
    }

    
    func performCalculations() {
           let CurrentUserAndPartner_Combined_Rank = CurrentUserDoublesRank + PartnerDoublesRank
           let Opponents_Combined_Rank = OppOneDoublesRank + OppTwoDoublesRank

           let higherNumber = max(CurrentUserAndPartner_Combined_Rank, Opponents_Combined_Rank)

           // Calculate the percent difference
           let percentDifference = abs((CurrentUserAndPartner_Combined_Rank - Opponents_Combined_Rank) / higherNumber * 100.0) / 100

           if CurrentUserAndPartner_Combined_Rank > Opponents_Combined_Rank {
               // Perform calculations based on your conditions
               OppOne_PercentDiff_Increment = OppOneDoublesRank * percentDifference
               OppTwo_PercentDiff_Increment = OppTwoDoublesRank * percentDifference
               CurrentUser_PercentDiff_Increment = 0.1
               Partner_PercentDiff_Increment = 0.1
               
               if OppOne_PercentDiff_Increment <= 0.1 {
                   OppOne_PercentDiff_Increment = 0.1
               }
               if OppTwo_PercentDiff_Increment <= 0.1 {
                   OppTwo_PercentDiff_Increment = 0.1
               }
           } else if Opponents_Combined_Rank > CurrentUserAndPartner_Combined_Rank {
               // Perform calculations based on your conditions
               CurrentUser_PercentDiff_Increment = CurrentUserDoublesRank * percentDifference
               Partner_PercentDiff_Increment = PartnerDoublesRank * percentDifference
               OppOne_PercentDiff_Increment = 0.1
               OppTwo_PercentDiff_Increment = 0.1
               if CurrentUser_PercentDiff_Increment <= 0.1 {
                   CurrentUser_PercentDiff_Increment = 0.1
               }
               if Partner_PercentDiff_Increment <= 0.1 {
                   Partner_PercentDiff_Increment = 0.1
               }
           }
        else if Opponents_Combined_Rank == CurrentUserAndPartner_Combined_Rank
        {
            CurrentUser_PercentDiff_Increment = 0.1
            Partner_PercentDiff_Increment = 0.1
            OppOne_PercentDiff_Increment = 0.1
            OppTwo_PercentDiff_Increment = 0.1
        }
        
       }
           

    
    var WL_Selection = "W"
    var Selection_Opposite = ""
    
    var Today = Date()
 
    
    
    @IBAction func seg_WL(_ sender: UISegmentedControl) {

       
        
        if sender.selectedSegmentIndex == 0
        {

            self.WL_Selection = "W"
            
            
          
            }
            else if sender.selectedSegmentIndex == 1
                        
            {
            
            self.WL_Selection = "L"
                
                        
            }
        }
   
    
    
    
    
    
    
    @IBAction func btn_Log(_ sender: UIButton) {
        
        performCalculations()
        
        
        
        
        
        GetSinglesRanks {
            
            self.GetHighScoresInitial {
                
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.email
                let Partner_ref = db.collection("Agressv_Users").document(self.selectedCellValueEmail)
                let OppOne_ref = db.collection("Agressv_Users").document(self.selectedCellValueOppOneEmail)
                let OppTwo_ref = db.collection("Agressv_Users").document(self.selectedCellValueOppTwoEmail)
        let Game_ref = db.collection("Agressv_Games").document()
        let User_ref = db.collection("Agressv_Users").document(uid!)
        
        let User_Badges_ref = db.collection("Agressv_Badges").document(uid!)
                let Partner_Badges_ref = db.collection("Agressv_Badges").document(self.selectedCellValueEmail)
                let OppOne_Badges_ref = db.collection("Agressv_Badges").document(self.selectedCellValueOppOneEmail)
                let OppTwo_Badgres_ref = db.collection("Agressv_Badges").document(self.selectedCellValueOppTwoEmail)
        
                if self.WL_Selection == "W" {
            self.Selection_Opposite = "L"
            //increment winning side
            User_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])
            
            User_ref.updateData([
                "Doubles_Rank": FieldValue.increment(self.CurrentUser_PercentDiff_Increment)])
            
            
            Partner_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])
            
            Partner_ref.updateData([
                "Doubles_Rank": FieldValue.increment(self.Partner_PercentDiff_Increment)])
            
            //decrement losing side
            OppOne_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])
            
            OppTwo_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])
            
                    if self.OppOneDoublesRank == 8.5 {
                //do not decrement
            }
            else
            {
                OppOne_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
            
                    if self.OppTwoDoublesRank == 8.5 {
                //do not decrement
            }
            else
            {
                OppTwo_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
            
            
            
        }
        
                else if self.WL_Selection == "L"{
            
            self.Selection_Opposite = "W"
            //increment winning side
            OppOne_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])
            
            OppOne_ref.updateData([
                "Doubles_Rank": FieldValue.increment(self.OppOne_PercentDiff_Increment)])
            
            OppTwo_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])
            
            OppTwo_ref.updateData([
                "Doubles_Rank": FieldValue.increment(self.OppTwo_PercentDiff_Increment)])
            
            //decrement losing side
            User_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])
            
            Partner_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])
            
            //if Doubles Rank is 8.5 do not decrement
                    if self.CurrentUserDoublesRank == 8.5 {
                //do not decrement
            }
            else
            {
                User_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
                    if self.PartnerDoublesRank == 8.5 {
                //do not decrement
            }
            else
            {
                Partner_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
        }
        
        User_ref.updateData([
            "Doubles_Games_Played": FieldValue.increment(Int64(1))])
        
        Partner_ref.updateData([
            "Doubles_Games_Played": FieldValue.increment(Int64(1))])
        
        OppOne_ref.updateData([
            "Doubles_Games_Played": FieldValue.increment(Int64(1))])
        
        OppTwo_ref.updateData([
            "Doubles_Games_Played": FieldValue.increment(Int64(1))])
        
        
                Game_ref.setData(["Game_Result" : self.WL_Selection, "Game_Date" : self.Today, "Game_Creator": uid!, "Game_Type": "Doubles", "Game_Partner": self.selectedCellValueEmail, "Game_Opponent_One": self.selectedCellValueOppOneEmail, "Game_Opponent_Two": self.selectedCellValueOppTwoEmail, "Game_Partner_Username": self.PartnerCellValue_NoRank, "Game_Opponent_One_Username": self.OppOneCellValue_NoRank, "Game_Opponent_Two_Username": self.OppTwoCellValue_NoRank, "Game_Creator_Username": self.CurrentUser_Username_NoRank, "Game_Result_Opposite_For_UserView": self.Selection_Opposite])
        
        
                self.GetCurrentUserRankAfter{
                    
                    print("HIGH SCORE DOUBLES")
                    print(self.Highest_Score_Doubles)
                    print("HIGH SCORE SINGLES")
                    print(self.Highest_Score_Singles)
                    
                    print("CURRENT USER PREVIOUS RANK")
                    print(self.CurrentUserDoublesRank)
                    print("CURRENT USER AFTER LOG RANK")
                    print(self.current_user_after_log_doubles_rank)

                    print("PARTNER USER PREVIOUS RANK")
                    print(self.PartnerDoublesRank)
                    print("PARTNER USER AFTER LOG RANK")
                    print(self.partner_user_after_log_doubles_rank)
                    print("PARTNER SINGLES RANK")
                    print(self.PartnerSinglesRank)
                    
                    print("OPP ONE USER PREVIOUS RANK")
                    print(self.OppOneDoublesRank)
                    print("OPP ONE USER AFTER LOG RANK")
                    print(self.oppone_user_after_log_doubles_rank)
                    print("OPP ONE SINGLES RANK")
                    print(self.OppOneSinglesRank)
                    
                    print("OPP TWO USER PREVIOUS RANK")
                    print(self.OppTwoDoublesRank)
                    print("OPP TWO USER AFTER LOG RANK")
                    print(self.opptwo_user_after_log_doubles_rank)
                    print("OPP TWO SINGLES RANK")
                    print(self.OppTwoSinglesRank)
                    
                    
                        
                        //Badge logic
                    
                    if !self.CurrentISHighestDoubles // REPLACE WITH if !CurrentUserHasHighestScore
                            
                        {
                            
                            if self.current_user_after_log_doubles_rank > 8.5
                            {
                                if self.current_user_after_log_doubles_rank >= self.Highest_Score_Doubles
                                {
                                    print("INCREMENT 1 FOR BLUE RIBBON")
                                    User_Badges_ref.updateData([
                                        "Blue_Ribbon_Doubles": FieldValue.increment(Int64(1))])
                                    
                                    if self.CurrentUserSinglesRank > 8.5
                                    {
                                        if self.CurrentUserSinglesRank == self.Highest_Score_Singles
                                        {
                                            print("INCREMENT 1 FOR GOLD RIBBON")
                                            User_Badges_ref.updateData([
                                                "Gold_Ribbon": FieldValue.increment(Int64(1))])
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    if !self.PartnerISHighestDoubles
                        {
                            if self.partner_user_after_log_doubles_rank > 8.5
                            {
                                if self.partner_user_after_log_doubles_rank >= self.Highest_Score_Doubles
                                {
                                    print("PARTNER - INCREMENT 1 FOR BLUE RIBBON")
                                    Partner_Badges_ref.updateData([
                                        "Blue_Ribbon_Doubles": FieldValue.increment(Int64(1))])
                                    
                                    if self.PartnerSinglesRank > 8.5
                                    {
                                        if self.PartnerSinglesRank == self.Highest_Score_Singles
                                        {
                                            print("PARTNER - INCREMENT 1 FOR GOLD RIBBON")
                                            Partner_Badges_ref.updateData([
                                                "Gold_Ribbon": FieldValue.increment(Int64(1))])
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                    if !self.OppTwoISHighestDoubles
                        {
                            if self.oppone_user_after_log_doubles_rank > 8.5
                            {
                                if self.oppone_user_after_log_doubles_rank >= self.Highest_Score_Doubles
                                {
                                    print("OPP ONE - INCREMENT 1 FOR BLUE RIBBON")
                                    OppOne_Badges_ref.updateData([
                                        "Blue_Ribbon_Doubles": FieldValue.increment(Int64(1))])
                                    
                                    if self.OppOneSinglesRank > 8.5
                                    {
                                        if self.OppOneSinglesRank == self.Highest_Score_Singles
                                        {
                                            print("OPP ONE - INCREMENT 1 FOR GOLD RIBBON")
                                            OppOne_Badges_ref.updateData([
                                                "Gold_Ribbon": FieldValue.increment(Int64(1))])
                                        }
                                    }
                                }
                            }
                        }
                        
                    if !self.OppTwoISHighestDoubles
                        {
                            if self.opptwo_user_after_log_doubles_rank > 8.5
                            {
                                if self.opptwo_user_after_log_doubles_rank >= self.Highest_Score_Doubles
                                {
                                    print("OPP TWO - INCREMENT 1 FOR BLUE RIBBON")
                                    OppTwo_Badgres_ref.updateData([
                                        "Blue_Ribbon_Doubles": FieldValue.increment(Int64(1))])
                                    
                                    if self.OppTwoSinglesRank > 8.5
                                    {
                                        if self.OppTwoSinglesRank == self.Highest_Score_Singles
                                        {
                                            print("OPP TWO - INCREMENT 1 FOR GOLD RIBBON")
                                            OppTwo_Badgres_ref.updateData([
                                                "Gold_Ribbon": FieldValue.increment(Int64(1))])
                                            
                                        }
                                    }
                                }
                            }
                        }
                    
                            //end Badge logic
                            
                            
                            
                            
                            let dialogMessage = UIAlertController(title: "Success!", message: "Your game has been logged.", preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                print("Ok button tapped")
                                
                                self.performSegue(withIdentifier: "LogGameGoHome", sender: self)
                            })
                            
                            
                            
                            
                            //let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            
                            
                            //Add OK button to a dialog message
                            dialogMessage.addAction(ok)
                            // Present Alert to
                            self.present(dialogMessage, animated: true, completion: nil)
                            
                            
                            
                            
                        }
                    }
                    
                }
            }
        
        
    
    
    

    
    
    
    
    }//end of class



// Extension to round a Double to a specified number of decimal places
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
