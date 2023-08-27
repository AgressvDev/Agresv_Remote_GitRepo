//
//  LoginViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/18/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

  
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func LoginClicked(_ sender: UIButton) {
        guard let email = EmailTextField.text else {return}
        guard let password = PasswordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { Result, error in
            if error != nil {
                // Create new Alert
                let dialogMessage = UIAlertController(title: "Error.", message: "Invalid Login. Please try again", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
            }
            else {
                //go to User's Homescreen
                self.performSegue(withIdentifier: "LoginGoToHome", sender: self)
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
