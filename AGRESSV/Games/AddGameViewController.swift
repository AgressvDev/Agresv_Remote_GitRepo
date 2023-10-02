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
    
    
   
    
  
    
 
    

    

    
   
    

    

    
    //For calculating players' ranks
    var CurrentUserDoublesRank: String = ""
    var PartnerDoublesRank: String = ""
    var OppOneDoublesRank: String = ""
    var OppTwoDoublesRank: String = ""
    
    //Displaying game players
    var currentuser: String = ""
    var selectedCellValue: String = SharedData.shared.PartnerSelection//Partner
    var selectedCellValueOppOne: String =  SharedData.shared.OppOneSelection//Opp One
    var selectedCellValueOppTwo: String = SharedData.shared.OppTwoSelection // Opp Two
    
    //Use for queries Usernames without the Rank string
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
        
        
        // Create a button
        let button = UIButton(type: .system)
        button.setTitle("Log Game", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
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
        
        
        if let dobermanleft = UIImage(named: "dobermanpsdleft.png") {
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
        
        if let dobermanleft2 = UIImage(named: "dobermanpsdleft.png") {
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
        
        if let dobermanright = UIImage(named: "dobermanpsd.png") {
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
        
        if let dobermanright2 = UIImage(named: "dobermanpsd.png") {
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
        
        
        // Create a label
        let lbl_OppTwo = UILabel()
        lbl_OppTwo.textAlignment = .center
        lbl_OppTwo.textColor = .black
        lbl_OppTwo.backgroundColor = UIColor(red: 100.0, green: 0.8, blue: 0.8, alpha: 2.0) // Light red background color
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
        lbl_OppOne.backgroundColor = UIColor(red: 100.0, green: 0.8, blue: 0.8, alpha: 2.0) // Light red background color
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
        lbl_Partner.backgroundColor = UIColor(red: 100.0, green: 0.8, blue: 0.8, alpha: 2.0) // Light red background color
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
        lbl_CurrentUser.backgroundColor = UIColor(red: 100.0, green: 0.8, blue: 0.8, alpha: 2.0) // Light red background color
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
        lbl_VS.textColor = .black
        
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
        lbl_Doubles.textColor = .black
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
        
        // Create a segmented control
        let seg_WLOutlet = UISegmentedControl(items: ["Won", "Lost"])
        seg_WLOutlet.selectedSegmentIndex = 0
        seg_WLOutlet.tintColor = .systemGreen
        seg_WLOutlet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(seg_WLOutlet)

        
        // Add a target action to handle segment value changes
            seg_WLOutlet.addTarget(self, action: #selector(seg_WL(_:)), for: .valueChanged)
        
        // Define constraints for the segmented control
        NSLayoutConstraint.activate([
            seg_WLOutlet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1), // Adjust the leading spacing
                seg_WLOutlet.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.1), // Adjust the trailing spacing
            seg_WLOutlet.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -70 * scalingFactor), // Place it above the button with spacing
            seg_WLOutlet.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
        ])

        
        
        
        // Create a label
        let testEmails = UILabel()
        testEmails.textAlignment = .center
        //testEmails.text = "VS."
        testEmails.textColor = .black
        
        testEmails.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testEmails)
        view.bringSubviewToFront(testEmails)
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_testEmails: CGFloat = 35.0 // Set your base font size
        let adjustedFontSize_testEmails = baseFontSize_testEmails * scalingFactor
        
        
        
        // Set the font size for lbl_Playometer
        lbl_VS.font = UIFont.systemFont(ofSize: adjustedFontSize_testEmails)

        // Define constraints for lbl_OppTwo
        NSLayoutConstraint.activate([
            testEmails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            testEmails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            testEmails.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -330 * scalingFactor), // Place it above the button with spacing
            testEmails.heightAnchor.constraint(equalToConstant: 40 * heightScalingFactor) // Adjust the height as needed
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
                    self.currentuser = userWithFormattedRank
                    lbl_CurrentUser.text = self.currentuser
                    
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
                            let doublesRankAsString = String(format: "%.1f", doublesRank)
                            self.CurrentUserDoublesRank = doublesRankAsString

                            // Update the label here (on the main thread)
                            DispatchQueue.main.async {
                                // Assuming you have a label called lbl_CurrentUserRank
                                self.CurrentUserDoublesRank = doublesRankAsString
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
                            // Convert the Double to a String
                            let doublesRankAsString = String(format: "%.1f", doublesRank)
                            self.PartnerDoublesRank = doublesRankAsString // Assign to OppOneDoublesRank

                            // Update the label here
                            DispatchQueue.main.async {
                                self.PartnerDoublesRank = doublesRankAsString
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
                            // Convert the Double to a String
                            let doublesRankAsString = String(format: "%.1f", doublesRank)
                            self.OppOneDoublesRank = doublesRankAsString // Assign to OppOneDoublesRank

                            // Update the label here
                            DispatchQueue.main.async {
                                self.OppOneDoublesRank = doublesRankAsString
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
                            // Convert the Double to a String
                            let doublesRankAsString = String(format: "%.1f", doublesRank)
                            self.OppTwoDoublesRank = doublesRankAsString // Assign to OppOneDoublesRank

                            // Update the label here
                            DispatchQueue.main.async {
                                self.OppTwoDoublesRank = doublesRankAsString
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
    
    
    
    var WL_Selection = "W"
    
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

        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.email
        let Partner_ref = db.collection("Agressv_Users").document(selectedCellValueEmail)
        let OppOne_ref = db.collection("Agressv_Users").document(selectedCellValueOppOneEmail)
        let OppTwo_ref = db.collection("Agressv_Users").document(selectedCellValueOppTwoEmail)
        let Game_ref = db.collection("Agressv_Games").document()
        let User_ref = db.collection("Agressv_Users").document(uid!)



        if WL_Selection == "W" {

            //increment winning side
            User_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])

            User_ref.updateData([
                "Doubles_Rank": FieldValue.increment(0.1)])

            Partner_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])

            Partner_ref.updateData([
                "Doubles_Rank": FieldValue.increment(0.1)])

            //decrement losing side
            OppOne_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])

            OppTwo_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])

            if OppOneDoublesRank == "8.5" {
                //do not decrement
            }
            else
            {
                OppOne_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }

            if OppTwoDoublesRank == "8.5" {
                //do not decrement
            }
            else
            {
                OppTwo_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }



        }

        else if WL_Selection == "L"{


            //increment winning side
            OppOne_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])

            OppOne_ref.updateData([
                "Doubles_Rank": FieldValue.increment(0.1)])

            OppTwo_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])

            OppTwo_ref.updateData([
                "Doubles_Rank": FieldValue.increment(0.1)])

            //decrement losing side
            User_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])

            Partner_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])

            //if Doubles Rank is 8.5 do not decrement
            if CurrentUserDoublesRank == "8.5" {
                //do not decrement
            }
            else
            {
                User_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
            if PartnerDoublesRank == "8.5" {
                //do not decrement
            }
            else
            {
                Partner_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
        }




        Game_ref.setData(["Game_Result" : WL_Selection, "Game_Date" : Today, "Game_Creator": uid!, "Game_Type": "Doubles", "Game_Partner": selectedCellValueEmail, "Game_Opponent_One": selectedCellValueOppOneEmail, "Game_Opponent_Two": selectedCellValueOppTwoEmail])

        User_ref.updateData([
            "Doubles_Games_Played": FieldValue.increment(Int64(1))])

        //Partner_ref
        //          Partner_ref.updateData([
        //            "Doubles_Games_Played": FieldValue.increment(Int64(1))])

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

            // Perform the segue to the target view controller


        }
        
    
        
        
    
    
    
    
    
    
    
    
    }//end of class

