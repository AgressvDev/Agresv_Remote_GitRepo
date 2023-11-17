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
    
    
    var UserWithMostGames: String?
    var currentuseremail: String = ""
    
    var CurrentISRedFangs: Bool = false
    
    var OppOneISRedFangs: Bool = false
    
    
    //for Badge evaluations
    var current_user_after_log_singles_rank: Double = 0.0
    var oppone_user_after_log_singles_rank: Double = 0.0
    
    var CurrentUserDoublesRank: Double = 0.0
    var OppOneDoublesRank: Double = 0.0
    
    var Highest_Score_Doubles: Double = 0.0
    var Highest_Score_Singles: Double = 0.0
    
    
    var CurrentISHighestSingles: Bool = false
    var OppOneISHighestSingles: Bool = false
    
    
    
    
    var CurrentUserSinglesRank: Double = 0.0
    var OppOneSinglesRank: Double = 0.0
    var CurrentUser_PercentDiff_Increment: Double = 0.0
    var OppOne_PercentDiff_Increment: Double = 0.0
    
    var CurrentUser_Username_NoRank: String = ""
    var currentuser: String = ""
    var OppOneCellValue_NoRank: String = SharedDataNoRank.sharednorank.OppOneSelection_NoRank
    
    var selectedCellValueOppOne: String =  SharedData.shared.OppOneSelection//Opp One
    
    
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
    
        
        // Set the background color of the screen
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 30/255, alpha: 1.0)
        
        
        
        
        
        
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
                        if let doublesRank = document.data()?["Singles_Rank"] as? Double {
                            //                            // Convert the Double to a String
                            //                            let doublesRankAsString = String(format: "%.1f", doublesRank)
                            //                            self.CurrentUserSinglesRank = doublesRankAsString
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
                            let OppOneUserRank = (doublesRank * 10.0).rounded() / 10.0
                            
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
        
        
        
        print(getcurrentuser())
        print(GetCurrentUserRank())
        print(GetOppOneEmail())
        print(GetOppOneRank())
        
        
        
        
        
       
        
        

        func findUserWithMostGamesInitial(completion: @escaping (String?) -> Void) {
            let db = Firestore.firestore()
            let agressvGamesCollection = db.collection("Agressv_Games")
            
            var emailCounts = [String: Int]()
            let fieldsToCheck = ["Game_Creator", "Game_Partner", "Game_Opponent_One", "Game_Opponent_Two"]
            
            let group = DispatchGroup()
            
            // Calculate the date 30 days ago from the current date
            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
            
            for field in fieldsToCheck {
                group.enter()
                agressvGamesCollection
                    .whereField(field, isNotEqualTo: "")
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error fetching documents: \(error)")
                        } else {
                            for document in querySnapshot!.documents {
                                if let email = document.data()[field] as? String,
                                   let gameDateTimestamp = document.data()["Game_Date"] as? Timestamp {
                                    let gameDate = gameDateTimestamp.dateValue()
                                    if gameDate > thirtyDaysAgo {
                                        emailCounts[email, default: 0] += 1
                                    }
                                }
                            }
                        }
                        group.leave()
                    }
            }
            
            group.notify(queue: .main) {
                if let mostFrequentEmail = emailCounts.max(by: { $0.1 < $1.1 })?.key {
                    completion(mostFrequentEmail)
                } else {
                    completion(nil)
                }
            }
        }


        
        findUserWithMostGamesInitial { mostFrequentEmail in
            if let email = mostFrequentEmail {
                self.UserWithMostGames = email
                print("INITIAL USER WITH MOST GAMES RED FANG!!!!!!: \(email)")
                print(self.UserWithMostGames!)
                GetCurrentUserEmailInitial
                {
                    
                    print(self.currentuseremail)
                    print(self.selectedCellValueOppOneEmail)
                    
                    GetOppOneEmail()
                    
                    if email == self.currentuseremail {
                        self.CurrentISRedFangs = true
                        print("CURRENT IS RED FANGS SET TO TRUE?")
                        print(self.CurrentISRedFangs)
                    }
                    
                    if email == self.selectedCellValueOppOneEmail {
                        self.OppOneISRedFangs = true
                        print("OPP ONE IS RED FANGS SET TO TRUE?")
                        print(self.OppOneISRedFangs)
                    }
                    
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
                }
                }
            }
        
    
  
        
        func GetCurrentUserEmailInitial(completion: @escaping () -> Void) {
            let db = Firestore.firestore()
            let uid = CurrentUser_Username_NoRank
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    if let document = querySnapshot?.documents.first {
                        // Access the value of "Email" field from the document
                        let currentUserEmail = document.data()["Email"] as? String
                        self.currentuseremail = currentUserEmail!
                    } else {
                        print("User not found")
                    }
                }
                
                completion()
            }
        }
        
        
        
        // Simulate loading for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
            loadingView?.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 30/255, alpha: 1.0)
            
            // Create a UILabel with the desired text
            loadingLabel = UILabel()
            //loadingLabel?.text = "Loading game..."
            loadingLabel?.textColor = .white
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
    
    
    func GetCurrentUserEmail(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let uid = CurrentUser_Username_NoRank
        let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = querySnapshot?.documents.first {
                    // Access the value of "Email" field from the document
                    let currentUserEmail = document.data()["Email"] as? String
                    self.currentuseremail = currentUserEmail!
                } else {
                    print("User not found")
                }
            }
            
            completion()
        }
    }

    
    func findUserWithMostGames(completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let agressvGamesCollection = db.collection("Agressv_Games")
        
        var emailCounts = [String: Int]()
        let fieldsToCheck = ["Game_Creator", "Game_Partner", "Game_Opponent_One", "Game_Opponent_Two"]
        
        let group = DispatchGroup()
        
        // Calculate the date 30 days ago from the current date
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        
        for field in fieldsToCheck {
            group.enter()
            agressvGamesCollection
                .whereField(field, isNotEqualTo: "")
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            if let email = document.data()[field] as? String,
                               let gameDateTimestamp = document.data()["Game_Date"] as? Timestamp {
                                let gameDate = gameDateTimestamp.dateValue()
                                if gameDate > thirtyDaysAgo {
                                    emailCounts[email, default: 0] += 1
                                }
                            }
                        }
                    }
                    group.leave()
                }
        }
        
        group.notify(queue: .main) {
            if let mostFrequentEmail = emailCounts.max(by: { $0.1 < $1.1 })?.key {
                completion(mostFrequentEmail)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    
    func GetDoublesRanks(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        
        // Get the current user's email
        guard let uid = Auth.auth().currentUser?.email else {
            print("No current user")
            return
        }
        
        
        
        let OppOne_uid = selectedCellValueOppOneEmail
        let OppOne_ref = db.collection("Agressv_Users").document(OppOne_uid)
        
        
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
        
        
        OppOne_ref.getDocument { (documentSnapshot, error) in
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
                            self.OppOneDoublesRank = currentUserRank
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
                                
                                if self.CurrentUserSinglesRank == self.Highest_Score_Singles
                                {
                                    self.CurrentISHighestSingles = true
                                }
                                
                                if self.OppOneSinglesRank == self.Highest_Score_Singles
                                {
                                    self.OppOneISHighestSingles = true
                                }
                                
                                completion()
                            }
                            
                        }
                    
                }
                
            }
        
    }
    
    func GetCurrentUserRankAfter(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        var currentUserRank: Double?
        var oppOneRank: Double?
        
        
        let dispatchGroup = DispatchGroup()
        
        // Get the current user's email
        guard let uid = Auth.auth().currentUser?.email else {
            print("No current user")
            return
        }
        
        
        
        let OppOne_uid = selectedCellValueOppOneEmail
        let OppOne_ref = db.collection("Agressv_Users").document(OppOne_uid)
        
        let documentRef = db.collection("Agressv_Users").document(uid)
        
        dispatchGroup.enter()
        documentRef.getDocument { (documentSnapshot, error) in
            defer { dispatchGroup.leave() }
            if let error = error {
                print("Error: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    if let SinglesRank = document.data()?["Singles_Rank"] as? Double {
                        currentUserRank = (SinglesRank * 10.0).rounded() / 10.0
                    } else {
                        print("Singles_Rank is not a valid number in the document")
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
                    if let doublesRank = document.data()?["Singles_Rank"] as? Double {
                        oppOneRank = (doublesRank * 10.0).rounded() / 10.0
                    } else {
                        print("Singles_Rank is not a valid number in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        
        
        dispatchGroup.notify(queue: .main) {
            // All Firestore calls have completed here
            if let currentUserRank = currentUserRank, let oppOneRank = oppOneRank {
                self.current_user_after_log_singles_rank = currentUserRank
                self.oppone_user_after_log_singles_rank = oppOneRank
                
            }
            completion()
        }
    }
    
    func performCalculations() {
        
        
        let higherNumber = max(CurrentUserSinglesRank, OppOneSinglesRank)
        
        // Calculate the percent difference
        let percentDifference = abs((CurrentUserSinglesRank - OppOneSinglesRank) / higherNumber * 100.0) / 100 / 1.75 //divide by 1.75 because percent diff feels too high for one win
        
        if CurrentUserSinglesRank > OppOneSinglesRank {
            // Perform calculations based on your conditions
            OppOne_PercentDiff_Increment = OppOneSinglesRank * percentDifference
            CurrentUser_PercentDiff_Increment = 0.1
            
            if OppOne_PercentDiff_Increment <= 0.1 {
                OppOne_PercentDiff_Increment = 0.1
            }
            
        } else if OppOneSinglesRank > CurrentUserSinglesRank {
            // Perform calculations based on your conditions
            CurrentUser_PercentDiff_Increment = CurrentUserSinglesRank * percentDifference
            OppOne_PercentDiff_Increment = 0.1
            
            if CurrentUser_PercentDiff_Increment <= 0.1 {
                CurrentUser_PercentDiff_Increment = 0.1
            }
        }
        else if CurrentUserSinglesRank == OppOneSinglesRank
        {
            CurrentUser_PercentDiff_Increment = 0.1
            OppOne_PercentDiff_Increment = 0.1
            
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
        
        GetDoublesRanks {
            
            self.GetHighScoresInitial {
                
                let db = Firestore.firestore()
                let uid = Auth.auth().currentUser!.email
                
                let OppOne_ref = db.collection("Agressv_Users").document(self.selectedCellValueOppOneEmail)
                
                let Game_ref = db.collection("Agressv_Games").document()
                let User_ref = db.collection("Agressv_Users").document(uid!)
                
                let User_Badges_ref = db.collection("Agressv_Badges").document(uid!)
                let OppOne_Badges_ref = db.collection("Agressv_Badges").document(self.selectedCellValueOppOneEmail)
                
                if self.WL_Selection == "W" {
                    self.Selection_Opposite = "L"
                    //increment winning side
                    User_ref.updateData([
                        "Singles_Games_Wins": FieldValue.increment(Int64(1))])
                    
                    User_ref.updateData([
                        "Singles_Rank": FieldValue.increment(self.CurrentUser_PercentDiff_Increment)])
                    
                    //decrement losing side
                    OppOne_ref.updateData([
                        "Singles_Games_Losses": FieldValue.increment(Int64(1))])
                    
                    
                    if self.OppOneSinglesRank == 8.5 {
                        //do not decrement
                    }
                    else
                    {
                        OppOne_ref.updateData([
                            "Singles_Rank": FieldValue.increment(-0.1)])
                    }
                    
                }
                
                else if self.WL_Selection == "L"{
                    
                    self.Selection_Opposite = "W"
                    //increment winning side
                    OppOne_ref.updateData([
                        "Singles_Games_Wins": FieldValue.increment(Int64(1))])
                    
                    OppOne_ref.updateData([
                        "Singles_Rank": FieldValue.increment(self.OppOne_PercentDiff_Increment)])
                    
                    //decrement losing side
                    User_ref.updateData([
                        "Singles_Games_Losses": FieldValue.increment(Int64(1))])
                    
                    
                    if self.CurrentUserSinglesRank == 8.5 {
                        //do not decrement
                    }
                    else
                    {
                        User_ref.updateData([
                            "Singles_Rank": FieldValue.increment(-0.1)])
                    }
                }
                
                
                User_ref.updateData([
                    "Singles_Games_Played": FieldValue.increment(Int64(1))])
                
                OppOne_ref.updateData([
                    "Singles_Games_Played": FieldValue.increment(Int64(1))])
                
                
                Game_ref.setData(["Game_Result" : self.WL_Selection, "Game_Date" : self.Today, "Game_Creator": uid!, "Game_Type": "Singles", "Game_Partner": "", "Game_Opponent_One": self.selectedCellValueOppOneEmail, "Game_Opponent_Two": "", "Game_Creator_Username": self.CurrentUser_Username_NoRank, "Game_Opponent_One_Username": self.OppOneCellValue_NoRank, "Game_Result_Opposite_For_UserView": self.Selection_Opposite])
                
                
                
                
                
                
                self.GetCurrentUserRankAfter {
                    
                    self.GetCurrentUserEmail {
                        
                        self.findUserWithMostGames
                        { mostFrequentEmail in
                            self.UserWithMostGames = mostFrequentEmail
                            print(self.UserWithMostGames!)
                            print(self.CurrentISRedFangs)
                            print(self.currentuseremail)
                            
                            if !self.CurrentISRedFangs
                            {
                                if self.UserWithMostGames == self.currentuseremail
                                {
                                    print("CURRENT USER - INCREMENT 1 RED FANG")
                                    User_Badges_ref.updateData([
                                        "Red_Fangs": FieldValue.increment(Int64(1))])
                                }
                            }
                            
                            
                            
                            if !self.OppOneISRedFangs
                            {
                                if self.UserWithMostGames == self.selectedCellValueOppOneEmail
                                {
                                    print("OPP ONE - INCREMENT 1 RED FANG")
                                    OppOne_Badges_ref.updateData([
                                        "Red_Fangs": FieldValue.increment(Int64(1))])
                                }
                            }
                            
                            
                            print("HIGH SCORE DOUBLES")
                            print(self.Highest_Score_Doubles)
                            print("HIGH SCORE SINGLES")
                            print(self.Highest_Score_Singles)
                            
                            print("CURRENT USER PREVIOUS RANK")
                            print(self.CurrentUserSinglesRank)
                            print("CURRENT USER AFTER LOG RANK")
                            print(self.current_user_after_log_singles_rank)
                            
                            print("OPP ONE USER PREVIOUS RANK")
                            print(self.OppOneSinglesRank)
                            print("OPP ONE USER AFTER LOG RANK")
                            print(self.oppone_user_after_log_singles_rank)
                            
                            //Badge logic
                            
                            if !self.CurrentISHighestSingles
                                
                            {
                                
                                if self.current_user_after_log_singles_rank > 8.5
                                {
                                    if self.current_user_after_log_singles_rank >= self.Highest_Score_Singles
                                    {
                                        print("INCREMENT 1 FOR BLUE RIBBON")
                                        User_Badges_ref.updateData([
                                            "Blue_Ribbon_Singles": FieldValue.increment(Int64(1))])
                                        
                                        if self.CurrentUserDoublesRank > 8.5
                                        {
                                            if self.CurrentUserDoublesRank == self.Highest_Score_Doubles
                                            {
                                                print("INCREMENT 1 FOR GOLD RIBBON")
                                                User_Badges_ref.updateData([
                                                    "Gold_Ribbon": FieldValue.increment(Int64(1))])
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if !self.OppOneISHighestSingles
                                
                            {
                                
                                if self.oppone_user_after_log_singles_rank > 8.5
                                {
                                    if self.oppone_user_after_log_singles_rank >= self.Highest_Score_Singles
                                    {
                                        print("INCREMENT 1 FOR BLUE RIBBON")
                                        OppOne_Badges_ref.updateData([
                                            "Blue_Ribbon_Singles": FieldValue.increment(Int64(1))])
                                        
                                        if self.OppOneDoublesRank > 8.5
                                        {
                                            if self.OppOneDoublesRank == self.Highest_Score_Doubles
                                            {
                                                print("INCREMENT 1 FOR GOLD RIBBON")
                                                OppOne_Badges_ref.updateData([
                                                    "Gold_Ribbon": FieldValue.increment(Int64(1))])
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            
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
                    }
                    
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
    
} //end of class



