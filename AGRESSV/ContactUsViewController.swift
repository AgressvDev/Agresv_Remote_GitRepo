//
//  ContactUsVC.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/14/23.
//

import Firebase
import FirebaseAuth
import MessageUI

class ContactUsViewController: UIViewController {
    // Declare a text view and a button
    let yourTextView = UITextView()
    let sendButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)

        // Create a UILabel for the message
        let messageLabel = UILabel()
        messageLabel.text = "Please write a brief message and we'll respond asap."
        messageLabel.textColor = .white // Adjust the text color as needed
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0 // Allow text to wrap to multiple lines
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize: CGFloat = 25.0 // Set your base font size
        let adjustedFontSize = baseFontSize * scalingFactor
        messageLabel.font = UIFont.systemFont(ofSize: adjustedFontSize)

       
        

        // Create UIImageView for the background image
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "BackgroundCoolGreen")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)

        // Set constraints to cover the full screen using the scaling factor
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Add a large text box for user input
      
        yourTextView.layer.borderWidth = 1.0
        yourTextView.translatesAutoresizingMaskIntoConstraints = false
        yourTextView.font = UIFont.systemFont(ofSize: adjustedFontSize) // Set the font size for the text view
        yourTextView.delegate = self // Conform to UITextViewDelegate for hiding the keyboard

        view.addSubview(yourTextView)

        // Add a "Send" button
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        // Calculate the initial font size based on the scalingFactor
        let baseButtonFontSize: CGFloat = 25.0
        let initialButtonFontSize = baseButtonFontSize * scalingFactor
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: initialButtonFontSize)

        // Set the button title
        sendButton.setTitle("Send", for: .normal)

        // Enable adjusting font size to fit the button's width
        sendButton.titleLabel?.adjustsFontSizeToFitWidth = true
        sendButton.titleLabel?.minimumScaleFactor = 0.5 // Adjust as needed
        
    
        sendButton.addTarget(self, action: #selector(SendButtonTapped), for: .touchUpInside) // Call SendButtonTapped when tapped

        view.addSubview(sendButton)

        // Add the label as a subview to the view
        view.addSubview(messageLabel)
        view.bringSubviewToFront(messageLabel)

        // Define Auto Layout constraints for the label, text view, and send button
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                messageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250 * scalingFactor),
                messageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8), // Adjust the width as needed,
            
            yourTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yourTextView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 50 * scalingFactor),
            yourTextView.widthAnchor.constraint(equalToConstant: 300 * scalingFactor), // Set width
            yourTextView.heightAnchor.constraint(equalToConstant: 200 * scalingFactor), // Set height
            
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                sendButton.topAnchor.constraint(equalTo: yourTextView.bottomAnchor, constant: 50 * scalingFactor),
                sendButton.widthAnchor.constraint(equalToConstant: 100 * scalingFactor), // Set width
                sendButton.heightAnchor.constraint(equalToConstant: 40 * scalingFactor) // Set height
        ])

        // Determine text color based on the user interface style
        if self.traitCollection.userInterfaceStyle == .dark {
            sendButton.setTitleColor(.white, for: .normal) // Dark mode
            yourTextView.textColor = .white // Light mode // Dark mode
        } else {
            sendButton.setTitleColor(.white, for: .normal) // Light mode
            yourTextView.textColor = .black // Light mode
        }

    

      
        // Add a UITapGestureRecognizer to hide the keyboard when the screen is tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

     
        
        
    } //end load
    
    // Implement the handleTap method to hide the keyboard
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        yourTextView.resignFirstResponder()
    }
    
    
    
    @objc func SendButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["agressvdev@gmail.com"])
            
            // Set the subject to include the user's email
            if let user = Auth.auth().currentUser, let email = user.email, let message = yourTextView.text {
                let subject = "USER MESSAGE! from \(email)"
                mailComposeViewController.setSubject(subject)
                mailComposeViewController.setMessageBody(message, isHTML: false)
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                // Handle the case where the user is not authenticated or text is empty
                let alert = UIAlertController(title: "Error", message: "Please provide a message before sending an email.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            // Handle the case where the device cannot send email
            let alert = UIAlertController(title: "Error", message: "Your phone is not currently configured to send an email from this application.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    
} //end class

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            // This code will be executed after the email view controller is dismissed.
            // You can navigate back to the Contact page or perform any other action here.
            // For example:
            // self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ContactUsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder() // Hide the keyboard when the user taps "Return"
            return false
        }
        return true
    }
}
