//
//  BlockScreenViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/5/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class BlockScreenViewController: UIViewController {

    var currentUserUsername: String = ""
    var currentUserEmail: String = ""
    var BlockedUser: String = SharedDataBlock.sharedblock.Game_Creator_forBlock
    var BlockedUserEmail: String = ""
    
    var GameID: String = SharedDataBlock.sharedblock.GameID
    var GameType: String = SharedDataBlock.sharedblock.GameType
    
    override func viewDidLoad() {
        super.viewDidLoad()

        func getcurrentusername() {
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
                     let username = document!["Username"] as? String
                      
                   
                        
                        DispatchQueue.main.async {
                           
                            self.currentUserUsername = username!
                            
                            GetCurrentUserEmail()
                            
                        }
                       
                    
                }
            }
        }
        print(getcurrentusername())
    
        
        func GetBlockedUser() {
            let db = Firestore.firestore()
            let uid = BlockedUser
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let BlockedUserEmail = document.data()["Email"] as? String
                        if let BlockedUserEmail = BlockedUserEmail {
                            DispatchQueue.main.async {
                                self.BlockedUserEmail = BlockedUserEmail
                            }
                           
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        print(GetBlockedUser())
        
        func GetCurrentUserEmail() {
            let db = Firestore.firestore()
            let uid = currentUserUsername
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let CurrentEmail = document.data()["Email"] as? String
                        if let CurrentEmail = CurrentEmail {
                            DispatchQueue.main.async {
                                self.currentUserEmail = CurrentEmail
                            }
                           
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        print(GetCurrentUserEmail())
        
        // Create a UIColor with the desired light blueish gray color
        let lightBlueishGrayColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)
        
        
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
        // Define Auto Layout constraints to position and allow the label to expand its width based on content
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0 * scalingFactor), // Left side of the screen
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0 * scalingFactor), // A little higher than the bottom
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0 * scalingFactor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0 * scalingFactor)
        ])

        //END BACKGROUND
        
        
        
        
        
        // Blocked User
                let lbl_BlockedUser = UILabel()
        lbl_BlockedUser.text = BlockedUser
        lbl_BlockedUser.textAlignment = .center
        lbl_BlockedUser.textColor = lightBlueishGrayColor

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_BlockedUser: CGFloat = 40 * scalingFactor // Set your base font size
        let adjustedFontSize_lbl_BlockedUser = baseFontSize_lbl_BlockedUser * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_BlockedUser.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_BlockedUser)
        
                // Add the label as a subview to the main view
                self.view.addSubview(lbl_BlockedUser)
        lbl_BlockedUser.translatesAutoresizingMaskIntoConstraints = false

                // Add constraints to center the label vertically and horizontally
                NSLayoutConstraint.activate([
                    lbl_BlockedUser.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    lbl_BlockedUser.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -25 * scalingFactor), // Adjust this constant to position the label higher or lower
                ])
        
        
        
        
        
        // Prompt
        let lbl_prompt = UILabel()
        lbl_prompt.text = "\(BlockedUser) created this game. If you dispute this game you can block the user and they will no longer be able to create games with your username. Additionally, the game will be deleted from your history. Do you wish to block this user?"
        
        
        lbl_prompt.textAlignment = .center
        lbl_prompt.numberOfLines = 0 // Allow multiple lines
        lbl_prompt.textColor = .white
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_prompt: CGFloat = 20 * scalingFactor// Set your base font size
        let adjustedFontSize_lbl_prompt = baseFontSize_lbl_prompt * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_prompt.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_prompt)
        
        
                // Add the label as a subview to the main view
                self.view.addSubview(lbl_prompt)
        lbl_prompt.translatesAutoresizingMaskIntoConstraints = false

        // Add constraints to center the label vertically and horizontally
                NSLayoutConstraint.activate([
                    lbl_prompt.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40 * scalingFactor),
                    lbl_prompt.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40 * scalingFactor),
                    lbl_prompt.centerYAnchor.constraint(equalTo: lbl_BlockedUser.centerYAnchor, constant: -125 * scalingFactor),
                    
                ])
        
        
        // Prompt
        let BlockInstruction = UILabel()
        BlockInstruction.text = "Click Red Button To Block User"
        
        
        BlockInstruction.textAlignment = .center
        BlockInstruction.numberOfLines = 1 // Allow multiple lines
        BlockInstruction.textColor = .white
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_BlockInstruction: CGFloat = 15 * scalingFactor// Set your base font size
        let adjustedFontSize_BlockInstruction = baseFontSize_BlockInstruction * scalingFactor

        // Set the font size for lbl_Playometer
        BlockInstruction.font = UIFont.systemFont(ofSize: adjustedFontSize_BlockInstruction)
        
        
                // Add the label as a subview to the main view
                self.view.addSubview(BlockInstruction)
        BlockInstruction.translatesAutoresizingMaskIntoConstraints = false

        // Add constraints to center the label vertically and horizontally
                NSLayoutConstraint.activate([
                    BlockInstruction.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40 * scalingFactor),
                    BlockInstruction.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40 * scalingFactor),
                    BlockInstruction.centerYAnchor.constraint(equalTo: lbl_BlockedUser.centerYAnchor, constant: 150 * scalingFactor),
                    
                ])
        
        
        
        
        
   
        // Create a UIButton with a custom type
        let BlockButton = UIButton(type: .custom)

        // Set the background image for the button
        let buttonImage = UIImage(named: "BlockUserIcon.png")
        BlockButton.setBackgroundImage(buttonImage, for: .normal)

        // Calculate the width and height of the button
        let buttonWidth: CGFloat = 70 * scalingFactor
        let buttonHeight: CGFloat = 70 * scalingFactor

        // Calculate the x position to center the button horizontally
  
        let xPosition = (screenWidth - buttonWidth) / 2

        // Calculate the y position to place the button slightly higher
    
        let yPosition = screenHeight - buttonHeight - 160 // Adjust 20 to your desired height

        // Set the frame of the button with the calculated values
        BlockButton.frame = CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight)

        // Add an action to the button (what happens when it's tapped)
        BlockButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Add the button to the view
        view.addSubview(BlockButton)


        
        
        
    } //end of load
    
    
        
 
       
        
       
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        
      
        
        
        // Do the update to the Block table
        let uid = Auth.auth().currentUser!.email
        let db = Firestore.firestore()
        let BlockRef = db.collection("Agressv_Blocked").document()
        
        BlockRef.setData(["Plaintiff_Email" : currentUserEmail, "Blocked_Email": BlockedUserEmail, "Plaintiff_Username": currentUserUsername, "Blocked_Username": BlockedUser])
        
        
      //DELETE SELECTED GAME
        let GameRef = Firestore.firestore().collection("Agressv_Games")
        let documentIDToDelete = GameID
        // Delete the document with the specified ID
        GameRef.document(documentIDToDelete).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document successfully deleted")
            }
        }
        
        //INCREMENT BACK USER'S .1 FOR THE LOSS
     
        let User_ref = db.collection("Agressv_Users").document(uid!)
     
            if self.GameType == "Singles"{
                User_ref.updateData([
                    "Singles_Rank": FieldValue.increment(0.1)])
                User_ref.updateData([
                    "Singles_Games_Played": FieldValue.increment(Int64(-1))])
                User_ref.updateData([
                    "Singles_Games_Losses": FieldValue.increment(Int64(-1))])
                
            } else if self.GameType == "Doubles"
            {
                User_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(0.1)])
                User_ref.updateData([
                    "Doubles_Games_Played": FieldValue.increment(Int64(-1))])
                User_ref.updateData([
                    "Doubles_Games_Losses": FieldValue.increment(Int64(-1))])
            }
        
    
        
        //let user know it's done
        
        let dialogMessage = UIAlertController(title: "Success!", message: "This user can no longer create games with your username.", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")

            self.performSegue(withIdentifier: "BlockToHome", sender: self)
        })




        //let okAction = UIAlertAction(title: "OK", style: .default) { (action) in


            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
        }
    

} //end of class
