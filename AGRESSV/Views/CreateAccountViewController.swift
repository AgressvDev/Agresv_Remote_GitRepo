//
//  CreateAccountViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/18/23.
//

import UIKit
import Firebase
import FirebaseFirestore


class CreateAccountViewController: UIViewController {

    @IBOutlet weak var CreateEmailTextField: UITextField!
    @IBOutlet weak var CreatePasswordTextField: UITextField!
    @IBOutlet weak var CreateUsernameTextField: UITextField!
    
    
            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.traitCollection.userInterfaceStyle == .light {
            // User is in light mode
            CreateEmailTextField.attributedPlaceholder = NSAttributedString(string: CreateEmailTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            CreatePasswordTextField.attributedPlaceholder = NSAttributedString(string: CreatePasswordTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            CreateUsernameTextField.attributedPlaceholder = NSAttributedString(string: CreateUsernameTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            CreateEmailTextField.textColor = .white
            CreatePasswordTextField.textColor = .white
            CreateUsernameTextField.textColor = .white
            // You can perform actions specific to light mode here
        } else {
            // User is in dark mode
            CreateEmailTextField.attributedPlaceholder = NSAttributedString(string: CreateEmailTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            CreatePasswordTextField.attributedPlaceholder = NSAttributedString(string: CreatePasswordTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            CreateUsernameTextField.attributedPlaceholder = NSAttributedString(string: CreateUsernameTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            CreateEmailTextField.textColor = .white
            CreatePasswordTextField.textColor = .white
            CreateUsernameTextField.textColor = .white
        }
        
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

        // Do any additional setup after loading the view.
    }
    
    //force lowercase text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Check if the text field being edited is your CreateEmailTextField
            if textField == CreateEmailTextField {
                // Convert the replacementString to lowercase and update the text field
                textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string.lowercased())
                return false // Return false to prevent default behavior
            }
            return true
        }
    
    
    
    
    func addUser(Username: String, Email: String){
        let db = Firestore.firestore()
        let ref = db.collection("Agressv_Users").document(Email)
        let ref_badges = db.collection("Agressv_Badges").document(Email)
        
        ref.setData(["Username" : Username, "Doubles_Rank" : 3.0, "Singles_Rank": 3.0, "Email": Email,
                     "Doubles_Games_Played": 0, "Singles_Games_Played": 0,
                     "Doubles_Games_Wins": 0, "Doubles_Games_Losses": 0, "Singles_Games_Wins": 0, "Singles_Games_Losses": 0])
        
        ref_badges.setData(["Username" : Username, "Blue_Ribbon_Doubles" : 0, "Blue_Ribbon_Singles" : 0, "Gold_Ribbon" : 0, "Red_Fangs" : 0])
    }
    
    
    
  
   


    
    @IBAction func CreateMyAccountClicked(_ sender: UIButton) {
        guard let Email = CreateEmailTextField.text?.lowercased() else {return}
        guard let password = CreatePasswordTextField.text else {return}
        guard let Username = CreateUsernameTextField.text else {return}
        
        Auth.auth().createUser(withEmail: Email, password: password) { Result, error in
            if error != nil {
               //print(error!.localizedDescription)
                // Create new Alert
                let dialogMessage = UIAlertController(title: "Error.", message: "Email may already exist or format may be incorrect. Please try again.", preferredStyle: .alert)

                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })

                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
            }
            else if Username == ""
            {
                let dialogMessageUsername = UIAlertController(title: "Error.", message: "Please enter a Username.", preferredStyle: .alert)

                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })

                //Add OK button to a dialog message
                dialogMessageUsername.addAction(ok)
                // Present Alert to
                self.present(dialogMessageUsername, animated: true, completion: nil)
            }
            
            else {
                
                //add code to prevent duplicate Usernames
                //if exists query wherefield "Username" isequalto: Username then raise dialogMessage
                func checkUsernameExists(usernameinner: String, completion: @escaping (Bool, Error?) -> Void) {
                    let db = Firestore.firestore()
                    let usernameref = db.collection("Agressv_Users")
                    
                    // Query the "users" collection to check if the username exists
                    usernameref.whereField("Username", isEqualTo: usernameinner).getDocuments { (querySnapshot, error) in
                        if let error = error {
                            // Handle any errors
                            completion(false, error)
                        } else {
                            // Check if there are any documents in the query result
                            if let documents = querySnapshot?.documents, !documents.isEmpty {
                                // Username exists
                                completion(true, nil)
                            } else {
                                // Username doesn't exist
                                completion(false, nil)
                            }
                        }
                    }
                }
                
                checkUsernameExists(usernameinner: Username) { (usernameExists, error) in
                    if let error = error {
                        print("Error checking username existence: \(error.localizedDescription)")
                    } else {
                        if usernameExists {
                            
                            let dialogMessageUsername = UIAlertController(title: "Error.", message: "That Username already exists.", preferredStyle: .alert)

                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                print("Ok button tapped")
                             })

                            //Add OK button to a dialog message
                            dialogMessageUsername.addAction(ok)
                            // Present Alert to
                            self.present(dialogMessageUsername, animated: true, completion: nil)
                            
                           //DELETE THE USER EMAIL FROM AUTHENTICATION DB 
                            let auth = Auth.auth()

                            // Get the current user
                            if let currentUser = auth.currentUser {
                                currentUser.delete { error in
                                    if let error = error {
                                        print("Error deleting user: \(error.localizedDescription)")
                                    } else {
                                        print("User deleted successfully.")
                                    }
                                }
                            } else {
                                print("No user is currently signed in.")
                            }
                            
                        } else {
                            
                            //add user to Agressv_Users collection
                            self.addUser(Username: Username, Email: Email)
                            //go to User's Homescreen
                            
                            //self.performSegue(withIdentifier: "CreateAccountGoToHome", sender: self)
                            
                            // Create an instance of opp two VC
                            let UserProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileID") as! UserProfileHomeVC
                            
                            // Push to the SecondViewController
                            self.navigationController?.pushViewController(UserProfileVC, animated: true)
                        
                           
                        }
                    }
                }
                
                
                
            }
        }
    } //end of load
    
    
    
    

} //end of class
