//
//  LoginViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/18/23.
//

import UIKit
import Firebase
import SwiftUI
import Foundation
import FirebaseMessaging

class LoginViewController: UIViewController {

  

    
    // Add this property
        var tapGesture: UITapGestureRecognizer!
    
    
   
    
    // Create UIImageView for the profile picture
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIconCoolGreen")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2.0 // Make it a circle
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    

    
    // Add EmailTextField
    let EmailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .clear
        textfield.layer.borderColor = UIColor.white.cgColor  // Set border color to white
        textfield.layer.borderWidth = 0.5  // Set border width
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    // Add EmailTextField
    let PasswordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .clear
        textfield.layer.borderColor = UIColor.white.cgColor  // Set border color to white
        textfield.layer.borderWidth = 0.5  // Set border width
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addGroupChat()
        
      
//        
//        let badgeCount: Int = 0
//                let application = UIApplication.shared
//                let center = UNUserNotificationCenter.current()
//                center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
//                    // Enable or disable features based on authorization.
//                }
//                application.registerForRemoteNotifications()
//                application.applicationIconBadgeNumber = badgeCount
            
        
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
       
        // Initialize tap gesture recognizer
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))

            // Add tap gesture recognizer to the view
            view.addGestureRecognizer(tapGesture)

        
        
        
        
        // Add the appIconImageView to your view hierarchy (assuming self.view is the parent view)
        self.view.addSubview(appIconImageView)

      
        // Add constraints to position the appIconImageView at the top center of the screen
        NSLayoutConstraint.activate([
            appIconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            appIconImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20), // Adjust the constant as needed
            appIconImageView.widthAnchor.constraint(equalToConstant: 200), // Adjust the width as needed
            appIconImageView.heightAnchor.constraint(equalTo: appIconImageView.widthAnchor)
        ])

        
        
       
      
            view.addSubview(EmailTextField)

            NSLayoutConstraint.activate([
                EmailTextField.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 40),
                EmailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                EmailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                EmailTextField.heightAnchor.constraint(equalToConstant: 40)
            ])

            
            view.addSubview(PasswordTextField)

            NSLayoutConstraint.activate([
                PasswordTextField.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor, constant: 10),
                PasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                PasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                PasswordTextField.heightAnchor.constraint(equalToConstant: 40)
            ])

        // Add Login Button
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("L  o  g  i  n", for: .normal)
        loginButton.addTarget(self, action: #selector(LoginClicked(_:)), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .white  // Set background color to white
        loginButton.setTitleColor(.black, for: .normal)  // Set text color to black
        loginButton.layer.cornerRadius = 5.0  // Optional: Set corner radius for a rounded appearance
        view.addSubview(loginButton)

        // Use the height constraint of either emailTextField or passwordTextField for loginButton
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: PasswordTextField.bottomAnchor, constant: 10),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalTo: EmailTextField.heightAnchor)  // Use the height of emailTextField
        ])

    
        // Retrieve and populate the text fields with saved credentials
                if let savedEmail = UserDefaults.standard.string(forKey: "userEmail"),
                   let savedPassword = UserDefaults.standard.string(forKey: "userPassword") {
                    EmailTextField.text = savedEmail
                    PasswordTextField.text = savedPassword
                }
        
        
            
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
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0 * scalingFactor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0 * scalingFactor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0 * scalingFactor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0 * scalingFactor)
            
        ])

    
        
       
        // Create and configure the "Contact Us" button
        let createAccountButton = UIButton(type: .system)
        createAccountButton.setTitle("C r e a t e   A c c o u n t", for: .normal)
        createAccountButton.setTitleColor(.white, for: .normal)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createAccountButton)

        // Add action to the button
        createAccountButton.addTarget(self, action: #selector(movetoCreateAccount), for: .touchUpInside)

        // Calculate and set the adjusted font size
        let originalFontSizecreateAccount: CGFloat = 20.0 // Set your desired original font size
        let adjustedFontSizecreateAccount = originalFontSizecreateAccount * scalingFactor
        
        createAccountButton.titleLabel?.font = UIFont(name: "Angel wish", size: adjustedFontSizecreateAccount)
        // Define constraints for the "Contact Us" button
        NSLayoutConstraint.activate([
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 * scalingFactor),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 * scalingFactor),
            createAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 75 * scalingFactor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50 * heightScalingFactor) // Set the desired height
        ])

                
                
        // Create a button
                let btn_ForgotPassword = UIButton(type: .system)
                btn_ForgotPassword.setTitle("F o r g o t   P a s s w o r d", for: .normal)
                btn_ForgotPassword.setTitleColor(.white, for: .normal)
                btn_ForgotPassword.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(btn_ForgotPassword)
                view.bringSubviewToFront(btn_ForgotPassword)
                
                // Calculate and set the adjusted font size
                let originalFontSize: CGFloat = 20.0 // Set your desired original font size
                let adjustedFontSize = originalFontSize * scalingFactor
                
                btn_ForgotPassword.titleLabel?.font = UIFont(name: "Angel wish", size: adjustedFontSize)
                
        // Add constraints to position the button -20 points from the bottom of the screen
        NSLayoutConstraint.activate([
            btn_ForgotPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 * scalingFactor),
            btn_ForgotPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 * scalingFactor),
            btn_ForgotPassword.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 20 * scalingFactor),
            btn_ForgotPassword.heightAnchor.constraint(equalToConstant: 50 * heightScalingFactor) // Set the desired height
        ])
        
        
            // Add action to the button
            btn_ForgotPassword.addTarget(self, action: #selector(btn_ForgotPasswordAction(_:)), for: .touchUpInside)
                
                
       
//
//        // To call the function, simply use:
//        addUser()
        PasswordTextField.isSecureTextEntry = true
        
       
       
    } //end of load
    
  
   
    
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()

           // Set corner radius to half of the image view's width
        appIconImageView.layer.cornerRadius = 0.5 * appIconImageView.bounds.width
       }
    
    
    // Function to navigate to the ContactUsViewController
    @objc func movetoCreateAccount() {
   
        let CreateAccountVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountVCID") as! CreateAccountViewController

        navigationController?.pushViewController(CreateAccountVC, animated: true)
    }
    
    
    
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
        
        // Save the user's credentials in UserDefaults
                if let email = EmailTextField.text, let password = PasswordTextField.text {
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    UserDefaults.standard.set(password, forKey: "userPassword")
                }
            
        
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
                // Create an instance of opp two VC
                let UserProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileID") as! UserProfileHomeVC
                
                // Push to the SecondViewController
                self.navigationController?.pushViewController(UserProfileVC, animated: true)
            
                
                //self.performSegue(withIdentifier: "LoginGoToHome", sender: self)
            }
        }
    }
    
    
    
    func addGroupChat() {
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        
        // Create a dictionary with the data you want to add
        let groupChatData: [String: Any] = [
            "GroupChat_Sender": "player3@gmail.com",
            "GroupChat_MessageText": "I have to baptize my cock but after that I'm free!",
            "GroupChat_TimeStamp": Date(),
            "GroupChat_GroupName": "LA Pickleball",
            "GroupChat_Group_Creator_Email": "player1@gmail.com",
            "GroupChat_Members": [
                "player1@gmail.com",
                "ryanmaxomelia@gmail.com",
                "jackmunro@something.com",
                "player3@gmail.com"
            ]
        ]
        
        // Add the data to the "Agressv_GroupChat" collection
        db.collection("Agressv_GroupChat").addDocument(data: groupChatData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
            }
        }
    }
    
    
    func fetchFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error)")
                return
            }
            guard let token = token else { return }
            print("FCM token: \(token)")
            
            // Now store this token in Firestore
            self.storeFCMToken(token)
        }
    }
    
    func storeFCMToken(_ token: String) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("Agressv_Users").document(userEmail) // Use email as document ID

        userRef.setData(["fcmToken": token], merge: true) { error in
            if let error = error {
                print("Error storing FCM token: \(error)")
            } else {
                print("FCM token stored successfully!")
            }
        }
    }

} //end of class

extension LoginViewController {
    @objc func handleTap() {
        view.endEditing(true)
    }
}
