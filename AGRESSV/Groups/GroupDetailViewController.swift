//
//  GroupDetailViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/11/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class GroupDetailViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    var currentUserEmail = Auth.auth().currentUser?.email
    var groupName: String = ""
    
    // Create UIImageView for the profile picture
        let GroupImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 2.0
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
    
    // Reference to the current user's profile image document in Firestore
    var currentGroupImageRef: DocumentReference?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
        
        view.addSubview(GroupImageView)
        // Set constraints for the profile image view
        NSLayoutConstraint.activate([
            GroupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GroupImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5 * scalingFactor),
            GroupImageView.widthAnchor.constraint(equalToConstant: 150 * scalingFactor), // Width
            GroupImageView.heightAnchor.constraint(equalToConstant: 150 * scalingFactor) // Height
        ])
        
        GroupImageView.layer.cornerRadius = (150 * scalingFactor) / 2
        GroupImageView.clipsToBounds = true
        
      
        
        // Add tap gesture recognizer to the profile image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        GroupImageView.addGestureRecognizer(tapGestureRecognizer)
        GroupImageView.isUserInteractionEnabled = true
        
        setupBackgroundImage()
        loadProfileImage()
        
    } //end of load
    
    

    private func setupBackgroundImage() {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "BackgroundCoolGreen")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)

        // Disable autoresizing mask constraints
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints to cover the full screen
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    
    @objc func handleProfileImageTap() {
        // Show image picker when profile image is tapped
        showImagePicker()
    }
    
    func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
            alertController.addAction(choosePhotoAction)
        }

        // Add delete photo option
        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .destructive) { _ in
            self.deletePhoto()
        }
        alertController.addAction(deletePhotoAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    func deletePhoto() {
        // Check if there's an existing document reference
        if let currentUserProfileImageRef = currentGroupImageRef {
            // Delete the document from Firestore
            currentUserProfileImageRef.delete { error in
                if let error = error {
                    print("Error deleting image from Firestore: \(error.localizedDescription)")
                } else {
                    print("Image deleted from Firestore successfully!")
                    // Reset the profile image view to a default image or nil
                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                }
            }
        } else {
            // Handle the case where there's no existing document reference
            print("Error: No existing document reference to delete.")
        }
    }
        
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            // Update the profile image view with the selected image
            GroupImageView.image = pickedImage
            
            // Ensure currentUserEmail is available and groupName is used directly
            if let currentUserEmail = self.currentUserEmail { // Assuming this is an optional String
                uploadImageToFirestore(image: pickedImage, currentUserEmail: currentUserEmail, groupName: groupName) // Use groupName directly if it's a String
            } else {
                print("Current user email is not available.")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }


    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageToFirestore(image: UIImage, currentUserEmail: String, groupName: String) {
        // Convert the UIImage to Data
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            // Check if there's an existing document reference
            if let currentUserProfileImageRef = currentGroupImageRef {
                // Update the existing document with the new image data
                currentUserProfileImageRef.updateData(["Group_Img": imageData]) { error in
                    if let error = error {
                        print("Error updating image in Firestore: \(error.localizedDescription)")
                    } else {
                        print("Image updated in Firestore successfully!")
                    }
                }
            } else {
                let collectionRef = Firestore.firestore().collection("Agressv_Groups")
                
                // Query the collection to find documents where Group_Creator_Email matches currentUserEmail and Group_Name matches groupName
                collectionRef
                    .whereField("Group_Creator_Email", isEqualTo: currentUserEmail)
                    .whereField("Group_Name", isEqualTo: groupName)
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error querying Firestore: \(error.localizedDescription)")
                            return
                        }
                        
                        // Check if any documents were found
                        if let documents = querySnapshot?.documents, !documents.isEmpty {
                            // Use the first matching document's ID
                            let documentRef = collectionRef.document(documents[0].documentID)
                            
                            // Save the reference for future updates
                            self.currentGroupImageRef = documentRef
                            
                            // Upload the image data to Firestore
                            documentRef.updateData(["Group_Img": imageData]) { error in
                                if let error = error {
                                    print("Error uploading image to Firestore: \(error.localizedDescription)")
                                } else {
                                    print("Image uploaded to Firestore successfully!")
                                }
                            }
                        } else {
                            // Handle the case where no matching document was found
                            print("No document found for the current user email and group name.")
                        }
                    }
            }
        }
    }

    
    
//    func uploadImageToFirestore(image: UIImage, currentUserEmail: String) {
//
//        // Convert the UIImage to Data
//        if let imageData = image.jpegData(compressionQuality: 0.5) {
//            // Check if there's an existing document reference
//            if let currentUserProfileImageRef = currentGroupImageRef {
//                // Update the existing document with the new image data
//                currentUserProfileImageRef.updateData(["Group_Img": imageData]) { error in
//                    if let error = error {
//                        print("Error updating image in Firestore: \(error.localizedDescription)")
//                    } else {
//                        print("Image updated in Firestore successfully!")
//                    }
//                }
//            } else {
//                let collectionRef = Firestore.firestore().collection("Agressv_Groups")
//
//                // Query the collection to find documents where Group_Creator_Email matches currentUserEmail
//                collectionRef.whereField("Group_Creator_Email", isEqualTo: self.currentUserEmail!).getDocuments { (querySnapshot, error) in
//                    if let error = error {
//                        print("Error querying Firestore: \(error.localizedDescription)")
//                        return
//                    }
//
//                    // Check if any documents were found
//                    if let documents = querySnapshot?.documents, !documents.isEmpty {
//                        // Use the first matching document's ID
//                        let documentRef = collectionRef.document(documents[0].documentID)
//
//                        // Save the reference for future updates
//                        self.currentGroupImageRef = documentRef
//
//                        // Upload the image data to Firestore
//                        documentRef.updateData(["Group_Img": imageData]) { error in
//                            if let error = error {
//                                print("Error uploading image to Firestore: \(error.localizedDescription)")
//                            } else {
//                                print("Image uploaded to Firestore successfully!")
//                            }
//                        }
//                    } else {
//                        // Handle the case where no matching document was found
//                        print("No document found for the current user email.")
//                    }
//                }
//            }
//        }
//    }


    
    

    
    func loadProfileImage() {
        let currentUserEmail = self.currentUserEmail // Replace with actual user email if it's dynamic
        let db = Firestore.firestore()
        
        db.collection("Agressv_Groups")
            .whereField("Group_Creator_Email", isEqualTo: currentUserEmail!)
            .whereField("Group_Name", isEqualTo: self.groupName) // Assuming you want to filter by group name as well
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                    return
                }

                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    // No documents found, set default image
                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                    return
                }

                // Get the first document
                let document = documents.first

                // Check for image data or URL
                if let imageData = document?.get("Group_Img") as? Data {
                    // If it's Data, convert to UIImage
                    self.GroupImageView.image = UIImage(data: imageData)
                } else if let imageString = document?.get("Group_Img") as? String, !imageString.isEmpty {
                    // If it's a non-empty string, load from URL
                    if let url = URL(string: imageString) {
                        // Fetch image from URL
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.GroupImageView.image = image
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                                }
                            }
                        }.resume()
                    } else {
                        // If the string is not a valid URL, set the default image
                        self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                    }
                } else {
                    // Set default image if Group_Img is nil or invalid
                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                }
            }
    }





} //end of class
