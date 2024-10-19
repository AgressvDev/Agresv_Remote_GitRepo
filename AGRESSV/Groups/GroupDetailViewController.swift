import UIKit
import Firebase
import FirebaseFirestore
import SwiftUI

import UIKit

import UIKit

class PaddedLabel: UILabel {
    var padding: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}





class GroupDetailViewController: UIViewController,
                                   UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate {
    

    var currentUserEmail = Auth.auth().currentUser?.email
    var currentUser_Username: String?
    var groupName: String = ""
    var group_members_array: [String] = []
    
    let scrollView = UIScrollView()
    var listener: ListenerRegistration?
    
    // Add properties for the MessageField and Send button
    let messageField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white // Set the background color to white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the placeholder text color to light gray
        let placeholderText = NSAttributedString(string: "Type a message...", attributes: [
            .foregroundColor: UIColor.lightGray // Light gray color for the placeholder
        ])
        textField.attributedPlaceholder = placeholderText
        
        return textField
    }()

    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "paperplane.fill") // Use the filled paper plane image
        button.setImage(image, for: .normal)
        button.tintColor = .white // Change the color as needed
        button.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit // Ensures the image fits well
        return button
    }()
    
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
    
    let groupNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16) // Customize font size as needed
        label.textColor = .white // Customize text color as needed
        return label
    }()

    var currentGroupImageRef: DocumentReference?

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //fetchMessages()
        setupBackgroundImage()
        loadProfileImage()
        setupGroupImage()
        
        fetchCurrentUserUsername { username in
            if let username = username {
                self.currentUser_Username = username
                print("Current user username: \(self.currentUser_Username ?? "")")
            } else {
                print("Username not found.")
            }
        }
        
        fetchGroupMembers(for: self.groupName, currentUserEmail: self.currentUserEmail!) { membersArray, error in
            if let error = error {
                print("Error fetching group members: \(error)")
            } else if let membersArray = membersArray {
                self.group_members_array = membersArray // Store the members in the variable
                print("Group Members: \(self.group_members_array)")
            }
        }
        
    } //end of load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopListeningForMessages()
    }
    
    func startListeningForMessages() {
        let db = Firestore.firestore()
        listener = db.collection("Agressv_GroupChat")
            .whereField("GroupChat_Members", arrayContains: self.currentUserEmail!)
            .whereField("GroupChat_GroupName", isEqualTo: self.groupName)
            .order(by: "GroupChat_TimeStamp")
            .addSnapshotListener { (snapshot, error) in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                print("LISTENER!!! New messages fetched: \(documents.count)")
                self.displayMessages(documents: documents)
            }
    }

    
    func stopListeningForMessages() {
        listener?.remove()
    }
    
    func fetchCurrentUserUsername(completion: @escaping (String?) -> Void) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        let usersCollection = db.collection("Agressv_Users")
        
        usersCollection.whereField("Email", isEqualTo: currentUserEmail).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No matching documents found.")
                completion(nil)
                return
            }
            
            // Assuming there is only one user document matching the email
            if let username = documents[0].get("Username") as? String {
                completion(username)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchGroupMembers(for groupName: String, currentUserEmail: String, completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let groupChatRef = db.collection("Agressv_GroupChat")
        
        // Query to find the document where GroupChat_GroupName matches groupName
        groupChatRef.whereField("GroupChat_GroupName", isEqualTo: groupName)
            .whereField("GroupChat_Members", arrayContains: currentUserEmail)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    // Handle the error
                    completion(nil, error)
                } else {
                    // Check if documents are returned
                    guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                        completion([], nil) // No members found
                        return
                    }
                    
                    // Retrieve GroupChat_Members array from the first document
                    if let membersArray = documents.first?.data()["GroupChat_Members"] as? [String] {
                        completion(membersArray, nil) // Pass the members array
                    } else {
                        completion(nil, NSError(domain: "FirestoreError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No members array found."]))
                    }
                }
            }
    }
    
    func setupGroupImage() {
        view.addSubview(GroupImageView)
        view.addSubview(groupNameLabel)
        view.addSubview(scrollView)
        
        self.groupNameLabel.text = self.groupName
        
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0
        let heightScalingFactor = screenHeight / 932.0
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)

        NSLayoutConstraint.activate([
            GroupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GroupImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            GroupImageView.widthAnchor.constraint(equalToConstant: 90 * scalingFactor),
            GroupImageView.heightAnchor.constraint(equalToConstant: 90 * scalingFactor),
            
            groupNameLabel.centerXAnchor.constraint(equalTo: GroupImageView.centerXAnchor),
            groupNameLabel.topAnchor.constraint(equalTo: GroupImageView.bottomAnchor, constant: 10)
        ])
        
        // Set up the scroll view
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layer.cornerRadius = 30
        scrollView.layer.masksToBounds = true

        
        
        // Add MessageField and Send button to the view
        view.addSubview(messageField)
        view.addSubview(sendButton)

        // Constraints for MessageField and Send button
        NSLayoutConstraint.activate([
            messageField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            messageField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30 * scalingFactor),
            messageField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            messageField.heightAnchor.constraint(equalToConstant: 50),
            
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30 * scalingFactor),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: messageField.heightAnchor)
        ])
        
        // Constraints for scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10 * scalingFactor),
            scrollView.bottomAnchor.constraint(equalTo: messageField.topAnchor, constant: -10), // Adjusted for MessageField
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        GroupImageView.layer.cornerRadius = (90 * scalingFactor) / 2
        GroupImageView.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        GroupImageView.addGestureRecognizer(tapGestureRecognizer)
        GroupImageView.isUserInteractionEnabled = true
    }
    

    private func setupBackgroundImage() {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "BackgroundCoolGreen")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)

        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // Function to handle sending the message
    @objc func sendMessage() {
        guard let messageText = messageField.text, !messageText.isEmpty else {
            return // Optionally show an alert to the user
        }

        let db = Firestore.firestore()
        
        // Create a dictionary with the data you want to add
        let groupChatData: [String: Any] = [
            "GroupChat_Sender": self.currentUserEmail!,
            "GroupChat_MessageText": messageText,
            "GroupChat_TimeStamp": Date(),
            "GroupChat_GroupName": self.groupName,
            //"GroupChat_Group_Creator_Email": "player1@gmail.com",
            "GroupChat_Members": self.group_members_array,
            "GroupChat_Sender_Username": self.currentUser_Username!
        ]
        
        // Add the data to the "Agressv_GroupChat" collection
        db.collection("Agressv_GroupChat").addDocument(data: groupChatData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
                self.messageField.text = "" //clear the field after update
               
                
            }
        }
    }
    
    func fetchMessages() {
        
        let db = Firestore.firestore()
            db.collection("Agressv_GroupChat")
            .whereField("GroupChat_Members", arrayContains: self.currentUserEmail!)
                .whereField("GroupChat_GroupName", isEqualTo: self.groupName)
                .getDocuments { (snapshot, error) in
                    guard let documents = snapshot?.documents, error == nil else {
                        print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    print("FETCH Document Data: \(documents)")
                    self.displayMessages(documents: documents)
                }
        }
        


    func displayMessages(documents: [QueryDocumentSnapshot]) {
        
        // Clear existing messages from scroll view
            scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        var previousMessageView: PaddedLabel?
        let padding: CGFloat = 10
        let maxWidth: CGFloat = 270
        let messageSpacing: CGFloat = 25 // Desired space between messages

        // Sort the documents by timestamp
        let sortedDocuments = documents.sorted { (doc1, doc2) in
            let timestamp1 = doc1.data()["GroupChat_TimeStamp"] as? Timestamp
            let timestamp2 = doc2.data()["GroupChat_TimeStamp"] as? Timestamp
            return timestamp1?.dateValue() ?? Date.distantPast < timestamp2?.dateValue() ?? Date.distantPast
        }

        // Iterate to display the most current message at the bottom
        for document in sortedDocuments {
            guard let message = document.data()["GroupChat_MessageText"] as? String,
                  let senderEmail = document.data()["GroupChat_Sender"] as? String,
                  let username_sender = document.data()["GroupChat_Sender_Username"] as? String
            else { continue }

            print("DISPLAY Document Data: \(document.data())")
            print("Message: \(message), Sender: \(senderEmail), Username_Sender: \(username_sender)")

         
                       let usernameLabel = UILabel()
                       usernameLabel.text = username_sender
                       usernameLabel.textColor = UIColor.lightGray // Light grey color
                       usernameLabel.font = UIFont.systemFont(ofSize: 10) // Set font size
                       usernameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let messageLabel = PaddedLabel()
            messageLabel.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) // Set desired padding
            messageLabel.text = message
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0 // Allow for multiple lines
            //messageLabel.lineBreakMode = .byWordWrapping


            // Determine background color and alignment
            if senderEmail == self.currentUserEmail {
                messageLabel.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)
                messageLabel.textColor = .white
            } else {
                messageLabel.backgroundColor = .lightGray
            }

            messageLabel.layer.cornerRadius = 15
            messageLabel.layer.masksToBounds = true
            messageLabel.translatesAutoresizingMaskIntoConstraints = false

            scrollView.addSubview(messageLabel)
            scrollView.addSubview(usernameLabel)

            NSLayoutConstraint.activate([
                // Set leading and trailing constraints based on sender
                senderEmail == self.currentUserEmail
                    ? messageLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding)
                    : messageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),

                // For current user's messages
                senderEmail == self.currentUserEmail
                    ? messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: scrollView.bounds.width - maxWidth - padding)
                    : messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor, constant: -padding),

                // Top constraint to previous message or scroll view
                messageLabel.topAnchor.constraint(equalTo: previousMessageView?.bottomAnchor ?? scrollView.topAnchor, constant: previousMessageView == nil ? padding : messageSpacing),

                // Limit label width to maxWidth
                messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
            ])

            // Set constraints for usernameLabel
                        NSLayoutConstraint.activate([
                            usernameLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
                            usernameLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -3)
                        ])

            previousMessageView = messageLabel
        }

        // Set the bottom constraint of the last message label to the bottom of the scroll view
        if let lastMessageView = previousMessageView {
            lastMessageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25).isActive = true
        }

        scrollView.layoutIfNeeded()
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height), animated: true)

    }

    

    
    @objc func handleProfileImageTap() {
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

        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .destructive) { _ in
            self.deletePhoto()
        }
        alertController.addAction(deletePhotoAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func deletePhoto() {
        if let currentUserProfileImageRef = currentGroupImageRef {
            currentUserProfileImageRef.delete { error in
                if let error = error {
                    print("Error deleting image from Firestore: \(error.localizedDescription)")
                } else {
                    print("Image deleted from Firestore successfully!")
                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                }
            }
        } else {
            print("Error: No existing document reference to delete.")
        }
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            GroupImageView.image = pickedImage

            if let currentUserEmail = Auth.auth().currentUser?.email {
                uploadImageToFirestore(image: pickedImage, currentUserEmail: currentUserEmail, groupName: groupName)
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
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            if let currentUserProfileImageRef = currentGroupImageRef {
                currentUserProfileImageRef.updateData(["Group_Img": imageData]) { error in
                    if let error = error {
                        print("Error updating image in Firestore: \(error.localizedDescription)")
                    } else {
                        print("Image updated in Firestore successfully!")
                    }
                }
            } else {
                let collectionRef = Firestore.firestore().collection("Agressv_Groups")
                collectionRef
                    .whereField("Group_Creator_Email", isEqualTo: currentUserEmail)
                    .whereField("Group_Name", isEqualTo: groupName)
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error querying Firestore: \(error.localizedDescription)")
                            return
                        }

                        if let documents = querySnapshot?.documents, !documents.isEmpty {
                            let documentRef = collectionRef.document(documents[0].documentID)
                            self.currentGroupImageRef = documentRef

                            documentRef.updateData(["Group_Img": imageData]) { error in
                                if let error = error {
                                    print("Error uploading image to Firestore: \(error.localizedDescription)")
                                } else {
                                    print("Image uploaded to Firestore successfully!")
                                }
                            }
                        } else {
                            print("No document found for the current user email and group name.")
                        }
                    }
            }
        }
    }

    func loadProfileImage() {
        let currentUserEmail = Auth.auth().currentUser?.email ?? ""
        let db = Firestore.firestore()

        db.collection("Agressv_Groups")
            .whereField("Group_Members", arrayContains: currentUserEmail)
            .whereField("Group_Name", isEqualTo: self.groupName)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                    return
                }

                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                    return
                }

                let document = documents.first

                if let imageData = document?.get("Group_Img") as? Data {
                    self.GroupImageView.image = UIImage(data: imageData)
                } else if let imageString = document?.get("Group_Img") as? String, !imageString.isEmpty {
                    if let url = URL(string: imageString) {
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
                        self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                    }
                } else {
                    self.GroupImageView.image = UIImage(named: "DefaultPlayerImage")
                }
            }
    }

    
    
  
   
} // end of class
