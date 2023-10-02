//
//  LoginViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/18/23.
//

import UIKit
import Firebase
import SwiftUI

class LoginViewController: UIViewController {

    @IBOutlet var backgroundGradView: UIView!
  
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Do any additional setup after loading the view.
    
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor] //UIColor.red.cgColor]
        
        gradientLayer.shouldRasterize = true
        
        backgroundGradView.layer.addSublayer(gradientLayer)
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        
    }
    
    @IBAction func btn_ForgotPassword(_ sender: UIButton) {
        
        
        // Create an alert controller
        let alertController = UIAlertController(title: "Forgot Password", message: "Enter your email address to reset your password", preferredStyle: .alert)
        
        // Add a text field for the user to enter their email
        alertController.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        // Add a "Reset Password" action
        let resetPasswordAction = UIAlertAction(title: "Reset Password", style: .default) { _ in
            if let email = alertController.textFields?.first?.text {
                // Check if the email field is not empty
                if !email.isEmpty {
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if let error = error {
                            // Handle the error, such as displaying an alert to the user
                            print("Password reset error: \(error.localizedDescription)")
                        } else {
                            // Password reset email sent successfully
                            print("Password reset email sent")
                        }
                    }
                } else {
                    // Email field is empty, show an error message
                    print("Email field is empty")
                }
            }
        }
    
        
    
                
                // Add a "Cancel" action
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                // Add the actions to the alert controller
        alertController.addAction(resetPasswordAction)
        alertController.addAction(cancelAction)
                
                // Present the alert controller
                self.present(alertController, animated: true, completion: nil)
            }
        


    





    @IBAction func LoginClicked(_ sender: UIButton) {
        guard let email = EmailTextField.text else {return}
        guard let password = PasswordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { Result, error in
            if error != nil {
                // Create new Alert
                let dialogMessage = UIAlertController(title: "Error.", message: "Invalid Login. Please try again.", preferredStyle: .alert)
                
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
    
    

}
