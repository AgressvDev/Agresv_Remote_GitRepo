import UIKit
import Firebase
import FirebaseFirestore
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class GroupDetailViewController: UIViewController,
                                   UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate {

    
    
    
    

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

    var currentGroupImageRef: DocumentReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setupBackgroundImage()
        loadProfileImage()
        setupUI()
        
    }

    func setupUI() {
        view.addSubview(GroupImageView)

        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0
        let heightScalingFactor = screenHeight / 932.0
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)

        NSLayoutConstraint.activate([
            GroupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GroupImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5 * scalingFactor),
            GroupImageView.widthAnchor.constraint(equalToConstant: 150 * scalingFactor),
            GroupImageView.heightAnchor.constraint(equalToConstant: 150 * scalingFactor)
        ])

        GroupImageView.layer.cornerRadius = (150 * scalingFactor) / 2
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

    // MARK: - UIImagePickerControllerDelegate

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
            .whereField("Group_Creator_Email", isEqualTo: currentUserEmail)
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

