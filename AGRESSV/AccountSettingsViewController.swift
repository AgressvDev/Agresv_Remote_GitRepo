//
//  AccountSettingsViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/9/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class AccountSettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)

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
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0 * scalingFactor), // Left side of the screen
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0 * scalingFactor), // A little higher than the bottom
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0 * scalingFactor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0 * scalingFactor)
        ])

        // Create and configure the "Contact Us" button
        let contactUsButton = UIButton(type: .system)
        contactUsButton.setTitle("Contact Us", for: .normal)
        contactUsButton.setTitleColor(.white, for: .normal)
        contactUsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contactUsButton)

        // Add action to the button
        contactUsButton.addTarget(self, action: #selector(moveToContactUsVC), for: .touchUpInside)

        // Calculate and set the adjusted font size
        let originalFontSizeContactUs: CGFloat = 25.0 // Set your desired original font size
        let adjustedFontSizeContactUs = originalFontSizeContactUs * scalingFactor
        contactUsButton.titleLabel?.font = UIFont.systemFont(ofSize: adjustedFontSizeContactUs)

        // Define constraints for the "Contact Us" button
        NSLayoutConstraint.activate([
            contactUsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 * scalingFactor),
            contactUsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 * scalingFactor),
            contactUsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150 * scalingFactor),
            contactUsButton.heightAnchor.constraint(equalToConstant: 50 * heightScalingFactor) // Set the desired height
        ])

        // Delete Account
        let btn_DeleteAccount = UIButton(type: .system)
        btn_DeleteAccount.setTitle("Delete My Account", for: .normal)
        btn_DeleteAccount.setTitleColor(.white, for: .normal)
        btn_DeleteAccount.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn_DeleteAccount)
        view.bringSubviewToFront(btn_DeleteAccount)

        // Calculate and set the adjusted font size
        let originalFontSizeDA: CGFloat = 25.0 // Set your desired original font size
        let adjustedFontSizeDA = originalFontSizeDA * scalingFactor
        btn_DeleteAccount.titleLabel?.font = UIFont.systemFont(ofSize: adjustedFontSizeDA)

        // Define constraints for the "Delete Account" button
        NSLayoutConstraint.activate([
            btn_DeleteAccount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 * scalingFactor),
            btn_DeleteAccount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20 * scalingFactor),
            btn_DeleteAccount.topAnchor.constraint(equalTo: contactUsButton.bottomAnchor, constant: 100 * scalingFactor),
            btn_DeleteAccount.heightAnchor.constraint(equalToConstant: 50 * heightScalingFactor) // Set the desired height
        ])

        // Add action to the button
        btn_DeleteAccount.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)

        //SIGN OUT BUTTON
        let signOutButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Sign Out", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: scalingFactor * 25)
            return button
        }()

        view.addSubview(signOutButton)

        signOutButton.isUserInteractionEnabled = true

        // Set constraints for the "Sign Out" button
      
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
            signOutButton.topAnchor.constraint(equalTo: btn_DeleteAccount.bottomAnchor, constant: 100 * scalingFactor) // Adjust the constant value
        ])

        // Add a target for the "Sign Out" button
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)

      
        
        
       
        
        
    } //end load
    
    @objc func deleteAccountButtonTapped() {
        let alertController = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            // Now, delete the user from Firestore collection "Agressv_Users"
            if let user = Auth.auth().currentUser {
                let userEmail = user.email
                
                
                let db = Firestore.firestore()
                db.collection("Agressv_Users")
                    .whereField("Email", isEqualTo: userEmail!)
                    .getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error deleting user from Firestore: \(error.localizedDescription)")
                        } else {
                            for document in snapshot!.documents {
                                document.reference.delete()
                                print("User deleted from Firestore successfully.")
                            }
                            
                            // After successfully deleting from Firestore, proceed to delete the Firebase Authentication account
                            user.delete { error in
                                if let error = error {
                                    // An error occurred while deleting the account.
                                    print("Error deleting account: \(error.localizedDescription)")
                                } else {
                                    // Account successfully deleted
                                    print("Account deleted successfully.")
                                    
                                    self.signOut()
                                }
                            }
                        }
                    }
            }
        }
    

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }


    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("User signed out successfully")
            
            // Navigate back to HomeScreenViewController
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController is LoginViewController {
                        self.navigationController?.popToViewController(viewController, animated: true)
                        return // Exit the loop
                    }
                }
            }
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    
   
    // Function to navigate to the ContactUsViewController
    @objc func moveToContactUsVC() {
        // Handle the button click and open the "AccountSettingsViewController" here
        let ContactVC = ContactUsViewController()
        // Present or push the view controller as needed
        // For example:
         navigationController?.pushViewController(ContactVC, animated: true)
        // or
        // present(accountSettingsVC, animated: true, completion: nil)
    }

    
   

} //end class
