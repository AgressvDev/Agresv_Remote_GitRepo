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

        // Do any additional setup after loading the view.
    }
    
    func addUser(Username: String, Email: String){
        let db = Firestore.firestore()
        let ref = db.collection("Agressv_Users").document(Email)

        ref.setData(["Username" : Username, "Doubles_Rank" : 8.5, "Singles_Rank": 8.5, "Email": Email,
                     "Doubles_Games_Played": 0, "Singles_Games_Played": 0,
                     "Doubles_Games_Wins": 0, "Doubles_Games_Losses": 0, "Singles_Games_Wins": 0, "Singles_Games_Losses": 0])
       
    }
    
    //function to check if username already exists
    
  
   


    
    @IBAction func CreateMyAccountClicked(_ sender: UIButton) {
        guard let Email = CreateEmailTextField.text else {return}
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
                            
                            
                            
                        } else {
                            
                            //add user to Agressv_Users collection
                            self.addUser(Username: Username, Email: Email)
                            //go to User's Homescreen
                            self.performSegue(withIdentifier: "CreateAccountGoToHome", sender: self)
                           
                        }
                    }
                }
                
                
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
