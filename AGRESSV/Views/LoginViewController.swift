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
            
        if self.traitCollection.userInterfaceStyle == .light {
            // User is in light mode
            EmailTextField.attributedPlaceholder = NSAttributedString(string: EmailTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            PasswordTextField.attributedPlaceholder = NSAttributedString(string: PasswordTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            EmailTextField.textColor = .white
            PasswordTextField.textColor = .white
            // You can perform actions specific to light mode here
        } else {
            // User is in dark mode
            EmailTextField.attributedPlaceholder = NSAttributedString(string: EmailTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            PasswordTextField.attributedPlaceholder = NSAttributedString(string: PasswordTextField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            EmailTextField.textColor = .white
            PasswordTextField.textColor = .white
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
//        // Do any additional setup after loading the view.
//
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = view.bounds
//
//        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor] //UIColor.red.cgColor]
//
//        gradientLayer.shouldRasterize = true
//
//        backgroundGradView.layer.addSublayer(gradientLayer)
//
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
       
       
                
                
        // Create a button
                let btn_ForgotPassword = UIButton(type: .system)
                btn_ForgotPassword.setTitle("Forgot Password", for: .normal)
                btn_ForgotPassword.setTitleColor(.white, for: .normal)
                btn_ForgotPassword.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(btn_ForgotPassword)
                view.bringSubviewToFront(btn_ForgotPassword)
                
                // Calculate and set the adjusted font size
                let originalFontSize: CGFloat = 17.0 // Set your desired original font size
                let adjustedFontSize = originalFontSize * scalingFactor
                btn_ForgotPassword.titleLabel?.font = UIFont.systemFont(ofSize: adjustedFontSize)
                
        // Add constraints to position the button -20 points from the bottom of the screen
        NSLayoutConstraint.activate([
            btn_ForgotPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 * scalingFactor),
            btn_ForgotPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 * scalingFactor),
            btn_ForgotPassword.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50 * scalingFactor),
            btn_ForgotPassword.heightAnchor.constraint(equalToConstant: 50 * heightScalingFactor) // Set the desired height
        ])
        
        
            // Add action to the button
            btn_ForgotPassword.addTarget(self, action: #selector(btn_ForgotPasswordAction(_:)), for: .touchUpInside)
                
                
                
            
            
            
    } //end of load
    
   
    
    @IBAction func btn_ForgotPasswordAction(_ sender: UIButton) {
        
        
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
    
    

} //end of class
