//
//  SinglesAddGameViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/1/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class SinglesAddGameViewController: UIViewController {
    
    var loadingView: UIView?
    var loadingLabel: UILabel?
    var selectedCellValueOppOneEmail: String = SharedDataEmails.sharedemails.OppOneEmail
    
    
    let CurrentUserImg: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let OppOneImg: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //Variables for Evaluating skill increases
    var Team_A_CurrentUser_Skill: Double = 0.0 //"Doubles_Rank"
    var Team_B_OppOne_Skill: Double = 0.0
    
    
    var CurrentUser_Email: String = ""
    
    
   
    
    
    
    
    
    
    
    var CurrentUserSinglesRank: Double = 0.0
    var OppOneSinglesRank: Double = 0.0
  
    
    var CurrentUser_Username_NoRank: String = ""
    var currentuser: String = ""
    var OppOneCellValue_NoRank: String = SharedData.shared.OppOneSelection//Opp One
    var selectedCellValueOppOne: String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingView()
        PullAllImages()
        
        
        func PullAllImages() {
            
            loadProfileImage()
            loadProfileImageOppOne()
           
           
        }
        
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
        
        
        
        
        
        
        
        
        
       
        
        
    
     
        
        
      
        
        
        
  
        
        let fontsize: CGFloat = 45
        
        // Calculate the adjusted font size based on the scalingFactor
        let adjustedFontSize_lbl_Singles = fontsize * scalingFactor
        
        // Create a label
        let lbl_Singles = UILabel()
        lbl_Singles.textAlignment = .center
        lbl_Singles.text = "Singles"
        lbl_Singles.textColor = .white
        lbl_Singles.font = UIFont(name: "Impact", size: adjustedFontSize_lbl_Singles) // Set the font with the adjusted size
        lbl_Singles.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lbl_Singles)
        view.bringSubviewToFront(lbl_Singles)
        
        NSLayoutConstraint.activate([
            lbl_Singles.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * marginPercentage),
            lbl_Singles.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * marginPercentage),
            lbl_Singles.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10), // 20 points down from the top safe area
            lbl_Singles.heightAnchor.constraint(equalToConstant: 50 * heightScalingFactor) // Adjust the height as needed
        ])
        
        
        
        // Add profile image view to the view
        view.addSubview(CurrentUserImg)
        
        NSLayoutConstraint.activate([
            CurrentUserImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            CurrentUserImg.topAnchor.constraint(equalTo: lbl_Singles.bottomAnchor, constant: 40 * scalingFactor),
            CurrentUserImg.widthAnchor.constraint(equalToConstant: 100 * scalingFactor),
            CurrentUserImg.heightAnchor.constraint(equalToConstant: 100 * scalingFactor)
        ])
        
        // Create UIImageView and set image from asset
                let lbl_Vs = UIImageView(image: UIImage(named: "VsIconWhite"))
        lbl_Vs.translatesAutoresizingMaskIntoConstraints = false

      
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_CurrentUser: CGFloat = 13.0 // Set your base font size
        let adjustedFontSize_lbl_CurrentUser = baseFontSize_lbl_CurrentUser * scalingFactor

        // Create a label
        let lbl_CurrentUser = UILabel()
        lbl_CurrentUser.textAlignment = .center
        lbl_CurrentUser.textColor = .white
        lbl_CurrentUser.translatesAutoresizingMaskIntoConstraints = false
        lbl_CurrentUser.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_CurrentUser)

        view.addSubview(lbl_CurrentUser)
        view.bringSubviewToFront(lbl_CurrentUser)

        // Define constraints for lbl_OppTwo
        NSLayoutConstraint.activate([
            lbl_CurrentUser.leadingAnchor.constraint(equalTo: CurrentUserImg.leadingAnchor, constant: 2),
            lbl_CurrentUser.topAnchor.constraint(equalTo: CurrentUserImg.bottomAnchor, constant: 5 * scalingFactor), // Place it above the button with spacing
            lbl_CurrentUser.heightAnchor.constraint(equalToConstant: 25 * heightScalingFactor), // Adjust the height as needed
            lbl_CurrentUser.widthAnchor.constraint(equalTo: CurrentUserImg.widthAnchor)

        ])
        
        // Add the image view to the view hierarchy
            self.view.addSubview(lbl_Vs)

        // Create constraints to center the image view
        NSLayoutConstraint.activate([
            lbl_Vs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            lbl_Vs.topAnchor.constraint(equalTo: lbl_CurrentUser.bottomAnchor, constant: 15 * scalingFactor),
            lbl_Vs.widthAnchor.constraint(equalToConstant: 70),
            lbl_Vs.heightAnchor.constraint(equalToConstant: 70)
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
        let seg_WLOutlet = UISegmentedControl(items: ["Won", "Lost"])
        seg_WLOutlet.selectedSegmentIndex = 0
        seg_WLOutlet.tintColor = .systemGreen
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
                       let doublesRank = document?["Singles_Rank"] as? Double {
                        let formattedRank = String(format: "%.2f", doublesRank)
                        let userWithFormattedRank = "\(username) - \(formattedRank)"
                        let norank = "\(username)"
                        self.currentuser = userWithFormattedRank
                        lbl_CurrentUser.text = self.currentuser
                        self.CurrentUser_Username_NoRank = norank
                        self.CurrentUser_Email = uid!
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
                        if let doublesRank = document.data()["Singles_Rank"] as? Double {
                            let OppOneUserRank = (doublesRank * 100.0).rounded() / 100.0
                            
                            // Update the label here
                            DispatchQueue.main.async {
                                self.OppOneSinglesRank = OppOneUserRank
                            }
                        } else {
                            print("Doubles_Rank is not a valid number in document with ID: \(document.documentID)")
                        }
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
                       
                        if let username = document["Username"] as? String,
                           let doublesRank = document["Singles_Rank"] as? Double {
                            let formattedRank = String(format: "%.2f", doublesRank)
                            let userWithFormattedRank = "\(username) - \(formattedRank)"
                            self.selectedCellValueOppOne = userWithFormattedRank
                            
                            // Add profile image view to the view
                            self.view.addSubview(self.OppOneImg)
                            
                            NSLayoutConstraint.activate([
                                self.OppOneImg.leadingAnchor.constraint(equalTo: self.CurrentUserImg.leadingAnchor),
                                self.OppOneImg.topAnchor.constraint(equalTo: lbl_Vs.bottomAnchor, constant: 15 * scalingFactor),
                                self.OppOneImg.widthAnchor.constraint(equalToConstant: 100 * scalingFactor),
                                self.OppOneImg.heightAnchor.constraint(equalToConstant: 100 * scalingFactor)
                            ])
                            
                            // Calculate the adjusted font size based on the scalingFactor
                            let baseFontSize_lbl_Partner: CGFloat = 13.0 // Set your base font size
                            let adjustedFontSize_lbl_Partner = baseFontSize_lbl_Partner * scalingFactor
                            
                            
                            // Create a label
                            let lbl_OppOne = UILabel()
                            lbl_OppOne.textAlignment = .center
                            lbl_OppOne.textColor = .white
                            lbl_OppOne.translatesAutoresizingMaskIntoConstraints = false
                            lbl_OppOne.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_Partner)
                            self.view.addSubview(lbl_OppOne)
                            self.view.bringSubviewToFront(lbl_OppOne)

                            // Define constraints for lbl_OppTwo
                            NSLayoutConstraint.activate([
                                lbl_OppOne.leadingAnchor.constraint(equalTo: self.OppOneImg.leadingAnchor, constant: 2),
                                lbl_OppOne.topAnchor.constraint(equalTo: self.OppOneImg.bottomAnchor, constant: 5 * scalingFactor), // Place it above the button with spacing
                                lbl_OppOne.heightAnchor.constraint(equalToConstant: 25 * heightScalingFactor), // Adjust the height as needed
                                lbl_OppOne.widthAnchor.constraint(equalTo: self.OppOneImg.widthAnchor)

                            ])
                            
                            
                            
                            lbl_OppOne.text = self.selectedCellValueOppOne

                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        
        
        
        print(getcurrentuser())
        print(GetOppOneEmail())
        print(GetOppOneRank())
        
        

               
                    
              
        print(GetTeamA_Skill())
                    

                    
                    
                
                
            
        
    
  
        
     
        
        
        
        // Simulate loading for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Call a function to hide the loading view
            self.hideLoadingView()
        }
        
    } //end of load
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()

           // Set corner radius to half of the image view's width
           CurrentUserImg.layer.cornerRadius = 0.5 * CurrentUserImg.bounds.width
           OppOneImg.layer.cornerRadius = 0.5 * OppOneImg.bounds.width
        
       }
    
    
    func showLoadingView() {
        // Create a UIView that covers the entire screen
        loadingView = UIView(frame: view.bounds)

        // Create UIImageView for the background image
        let backgroundImage = UIImageView(frame: loadingView!.bounds)
        
        // Set the image to "BackgroundCoolGreen" from your asset catalog
        backgroundImage.image = UIImage(named: "BackgroundCoolGreen")
        
        // Make sure the image doesn't stretch or distort
        backgroundImage.contentMode = .scaleAspectFill
        
        // Add the UIImageView as a subview to the loading view
        loadingView?.addSubview(backgroundImage)
        
        // Set the loading view's zPosition to bring it to the front
            loadingView?.layer.zPosition = 10
        
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
    
    
    

    
   
    func GetTeamA_Skill()
    {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.email
        let query = db.collection("Agressv_Users").whereField("Email", isEqualTo: uid!)
        
        query.getDocuments { (querySnapshot, error) in
            if error != nil {
                print("error")
            } else {
                for document in querySnapshot!.documents {
                    
                    if let skill = document["Singles_Rank"] as? Double {
                        self.Team_A_CurrentUser_Skill = skill
                        print("Current User Skill is:")
                        print(self.Team_A_CurrentUser_Skill)
                        self.GetTeamB_Skill_OppOne()
                    }
                }}}}
    
    
    func GetTeamB_Skill_OppOne()
    {
        let db = Firestore.firestore()
        let uid = self.OppOneCellValue_NoRank
        let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
        query.getDocuments { (querySnapshot, error) in
            if error != nil {
                print("error")
            } else {
                for document in querySnapshot!.documents {
                    
                    if let skill = document["Singles_Rank"] as? Double {
                        self.Team_B_OppOne_Skill = skill
                        print("Opp One Skill is:")
                        print(self.Team_B_OppOne_Skill)
                     
                    }
                }}}}
    
    
   
        
        
       
        
  
    
    func performCalculations() {
        
        
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
        

        let db = Firestore.firestore()
        let CurrentUser_Ref = db.collection("Agressv_Users").whereField("Username", isEqualTo: CurrentUser_Username_NoRank)
        let Opp1_Ref = db.collection("Agressv_Users").whereField("Username", isEqualTo: OppOneCellValue_NoRank)
        let Game_Ref = db.collection("Agressv_Games")
        
        let CurrentUser_Games_Ref = db.collection("Agressv_Users").document(CurrentUser_Email)
        let Opp1_Games_Ref = db.collection("Agressv_Users").document(selectedCellValueOppOneEmail)
        
                if self.WL_Selection == "W"
        {
                    self.Selection_Opposite = "L"
                    
                    CurrentUser_Games_Ref.updateData([
                       "Singles_Games_Wins": FieldValue.increment(Int64(1))])
                        Opp1_Games_Ref.updateData([
                              "Singles_Games_Losses": FieldValue.increment(Int64(1))])
                    
                    //do new stuff
                    if Team_A_CurrentUser_Skill < Team_B_OppOne_Skill
                            {
                        let result = percentDifference(valueA: Team_A_CurrentUser_Skill, valueB: Team_B_OppOne_Skill)
                        
                        
                                        // Execute the query
                                        CurrentUser_Ref.getDocuments { (querySnapshot, error) in
                                            if let error = error {
                                                print("Error getting documents: \(error)")
                                            } else {
                                                for document in querySnapshot!.documents {
                                                    // Update the "Doubles_Rank" field to "replace"
                                                    db.collection("Agressv_Users").document(document.documentID).updateData(["Singles_Rank": result + self.Team_A_CurrentUser_Skill]) { error in
                                                        if let error = error {
                                                            print("Error updating document: \(error)")
                                                        } else {
                                                            print("Document \(document.documentID) successfully updated")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                        
                            }
                    
                     
                    
        }
                   
                
                
                else if self.WL_Selection == "L"
        {
                    
                    self.Selection_Opposite = "W"
                    
                    Opp1_Games_Ref.updateData([
                       "Singles_Games_Wins": FieldValue.increment(Int64(1))])
                   
                       CurrentUser_Games_Ref.updateData([
                          "Singles_Games_Losses": FieldValue.increment(Int64(1))])
                    
                    //do new stuff
                    if Team_B_OppOne_Skill < Team_A_CurrentUser_Skill
                            {
                        let result = percentDifference(valueA: Team_B_OppOne_Skill, valueB: Team_A_CurrentUser_Skill)
                        
                        
                                        // Execute the query
                                        Opp1_Ref.getDocuments { (querySnapshot, error) in
                                            if let error = error {
                                                print("Error getting documents: \(error)")
                                            } else {
                                                for document in querySnapshot!.documents {
                                                    // Update the "Doubles_Rank" field to "replace"
                                                    db.collection("Agressv_Users").document(document.documentID).updateData(["Singles_Rank": result + self.Team_B_OppOne_Skill]) { error in
                                                        if let error = error {
                                                            print("Error updating document: \(error)")
                                                        } else {
                                                            print("Document \(document.documentID) successfully updated")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                        
                            }
                   
        }
                
        
        CurrentUser_Games_Ref.updateData([
        "Singles_Games_Played": FieldValue.increment(Int64(1))])
                    Opp1_Games_Ref.updateData([
                    "Singles_Games_Played": FieldValue.increment(Int64(1))])
        
        // Insert data directly into Firestore
        Game_Ref.addDocument(data: [
            "Game_Creator":  self.CurrentUser_Email,
            "Game_Creator_Username": self.CurrentUser_Username_NoRank,
            "Game_Date": Date(),
            "Game_Opponent_One": self.selectedCellValueOppOneEmail,
            "Game_Opponent_One_Username": self.OppOneCellValue_NoRank,
            "Game_Result": self.WL_Selection,
            "Game_Result_Opposite_For_UserView": self.Selection_Opposite,
            "Game_Type": "Singles"
        ])

                            
                            let dialogMessage = UIAlertController(title: "Success!", message: "Your game has been logged.", preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                print("Ok button tapped")
                                
                                self.performSegue(withIdentifier: "LogGameGoHomeSingles", sender: self)
                            })
                            

                            
                            //Add OK button to a dialog message
                            dialogMessage.addAction(ok)
                            // Present Alert to
                            self.present(dialogMessage, animated: true, completion: nil)
                            
                            // Perform the segue to the target view controller
                            
                            
                        }
                    
                    
                
                
            
        
        
    
    
    func loadProfileImage() {
        // Load the user's profile image from Firestore
        
        guard let uid = Auth.auth().currentUser?.email else {
            // Handle the case where the user's email is not available
            return
        }
        let db = Firestore.firestore()
        let docRef = db.collection("Agressv_ProfileImages").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, retrieve and set the profile image
                if let imageData = document.data()?["User_Img"] as? Data {
                    self.CurrentUserImg.image = UIImage(data: imageData)
                
                    
                } else {
                    // Handle the case where the "User_Img" field does not contain valid image data
                    self.CurrentUserImg.image = UIImage(named: "DefaultPlayerImage")
                }
            } else {
                // Handle the case where the document does not exist (user does not have a profile image)
                self.CurrentUserImg.image = UIImage(named: "DefaultPlayerImage")
            }
        }
    }
    
    func loadProfileImageOppOne() {
        // Load the user's profile image from Firestore
        
         let uid = selectedCellValueOppOneEmail
        let db = Firestore.firestore()
        let docRef = db.collection("Agressv_ProfileImages").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, retrieve and set the profile image
                if let imageData = document.data()?["User_Img"] as? Data {
                    self.OppOneImg.image = UIImage(data: imageData)
                } else {
                    // Handle the case where the "User_Img" field does not contain valid image data
                    self.OppOneImg.image = UIImage(named: "DefaultPlayerImage")
                }
            } else {
                // Handle the case where the document does not exist (user does not have a profile image)
                self.OppOneImg.image = UIImage(named: "DefaultPlayerImage")
            }
        }
    }
    
    
    func percentDifference(valueA: Double, valueB: Double) -> Double {
        let difference = abs(valueA - valueB)
        let average = (valueA + valueB) / 2
        let percentDifference = (difference / average) * 100
        
        // Return the result as a decimal
           return (percentDifference / 100).rounded(toPlaces: 2)
        
    }
    
   
    
} //end of class

