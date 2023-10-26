//
//  BadgesViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/23/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class BadgesViewController: UIViewController {
    
    

    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
               backgroundImage.image = UIImage(named: "ChampBackgroundBlur")

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
        
        
        
        let goldRibbon = UIImageView()
        goldRibbon.image = UIImage(named: "GoldRibbon") // Replace with the actual image name
        goldRibbon.translatesAutoresizingMaskIntoConstraints = false
        goldRibbon.contentMode = .scaleAspectFit // Adjust the content mode as needed
        view.addSubview(goldRibbon)
        
        
        
        //Define Auto Layout constraints to position and scale the label
       NSLayoutConstraint.activate([
          
        goldRibbon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45 * scalingFactor),
        goldRibbon.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 55 * scalingFactor),
        goldRibbon.widthAnchor.constraint(equalToConstant: 95 * scalingFactor), // Adjust the reference size as needed
        goldRibbon.heightAnchor.constraint(equalToConstant: 95 * scalingFactor) // Adjust the reference size as needed
       ])
        
        // Create the label
        let lbl_goldRibbon = UILabel()
        lbl_goldRibbon.text = "The Golden Ribbon. Player achieved top rank in both Doubles and Singles."
        lbl_goldRibbon.textColor = .black
        lbl_goldRibbon.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_goldRibbon.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_goldRibbon)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize: CGFloat = 16.0 // Set your base font size
        let adjustedFontSize = baseFontSize * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_goldRibbon.font = UIFont.systemFont(ofSize: adjustedFontSize)
        

        
        // Existing constraints for lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_goldRibbon.leadingAnchor.constraint(equalTo: goldRibbon.trailingAnchor, constant: 25 * scalingFactor),
            lbl_goldRibbon.topAnchor.constraint(equalTo: goldRibbon.topAnchor)
        ])

        // Add new constraints for limiting the width of lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_goldRibbon.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20 * scalingFactor), // Limit the trailing edge to some margin from the right of the view.
            lbl_goldRibbon.bottomAnchor.constraint(lessThanOrEqualTo: goldRibbon.bottomAnchor), // Allow the label to wrap based on content up to the goldRibbon's bottom anchor.
            lbl_goldRibbon.widthAnchor.constraint(lessThanOrEqualToConstant: 170) // Set a maximum width (adjust the constant as needed).
        ])
        
        
        
        
        let blueRibbon = UIImageView()
        blueRibbon.image = UIImage(named: "BlueRibbon") // Replace with the actual image name
        blueRibbon.translatesAutoresizingMaskIntoConstraints = false
        blueRibbon.contentMode = .scaleAspectFit // Adjust the content mode as needed
        view.addSubview(blueRibbon)
        
        
        
        //Define Auto Layout constraints to position and scale the label
       NSLayoutConstraint.activate([
          
        blueRibbon.topAnchor.constraint(equalTo: goldRibbon.bottomAnchor, constant: 40 * scalingFactor),
        blueRibbon.leadingAnchor.constraint(equalTo: goldRibbon.leadingAnchor),
        blueRibbon.widthAnchor.constraint(equalToConstant: 95 * scalingFactor), // Adjust the reference size as needed
        blueRibbon.heightAnchor.constraint(equalToConstant: 95 * scalingFactor) // Adjust the reference size as needed
       ])
        
        // Create the label
        let lbl_blueRibbon = UILabel()
        lbl_blueRibbon.text = "The Blue Ribbon. Player achieved top rank in either Doubles or Singles."
        lbl_blueRibbon.textColor = .black
        lbl_blueRibbon.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_blueRibbon.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_blueRibbon)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_lbl_blueRibbon: CGFloat = 16.0 // Set your base font size
        let adjustedFontSize_lbl_blueRibbon = baseFontSize_lbl_blueRibbon * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_blueRibbon.font = UIFont.systemFont(ofSize: adjustedFontSize_lbl_blueRibbon)
        

        
        // Existing constraints for lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_blueRibbon.leadingAnchor.constraint(equalTo: blueRibbon.trailingAnchor, constant: 25 * scalingFactor),
            lbl_blueRibbon.topAnchor.constraint(equalTo: blueRibbon.topAnchor)
        ])

        // Add new constraints for limiting the width of lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_blueRibbon.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20 * scalingFactor), // Limit the trailing edge to some margin from the right of the view.
            lbl_blueRibbon.bottomAnchor.constraint(lessThanOrEqualTo: blueRibbon.bottomAnchor), // Allow the label to wrap based on content up to the goldRibbon's bottom anchor.
            lbl_blueRibbon.widthAnchor.constraint(lessThanOrEqualToConstant: 170) // Set a maximum width (adjust the constant as needed).
        ])
        
        
        
        
        
        
        
        let RedFangs = UIImageView()
        RedFangs.image = UIImage(named: "RedFangs") // Replace with the actual image name
        RedFangs.translatesAutoresizingMaskIntoConstraints = false
        RedFangs.contentMode = .scaleAspectFit // Adjust the content mode as needed
        view.addSubview(RedFangs)
        
        
        
        //Define Auto Layout constraints to position and scale the label
       NSLayoutConstraint.activate([
          
        RedFangs.topAnchor.constraint(equalTo: blueRibbon.bottomAnchor, constant: 40 * scalingFactor),
        RedFangs.leadingAnchor.constraint(equalTo: goldRibbon.leadingAnchor),
        RedFangs.widthAnchor.constraint(equalToConstant: 95 * scalingFactor), // Adjust the reference size as needed
        RedFangs.heightAnchor.constraint(equalToConstant: 95 * scalingFactor) // Adjust the reference size as needed
       ])
        
        
        
        // Create the label
        let lbl_RedFangs = UILabel()
        lbl_RedFangs.text = "The Red Fangs. Player achieved most agressive, logged the highest number of games in rolling 30 days."
        lbl_RedFangs.textColor = .black
        lbl_RedFangs.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        lbl_RedFangs.numberOfLines = 0 // Allow multiple lines
        // Add the label to the view hierarchy
        view.addSubview(lbl_RedFangs)
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_RedFangs: CGFloat = 16.0 // Set your base font size
        let adjustedFontSize_RedFangs = baseFontSize_RedFangs * scalingFactor

        // Set the font size for lbl_Playometer
        lbl_RedFangs.font = UIFont.systemFont(ofSize: adjustedFontSize_RedFangs)
        

        
        // Existing constraints for lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_RedFangs.leadingAnchor.constraint(equalTo: RedFangs.trailingAnchor, constant: 25 * scalingFactor),
            lbl_RedFangs.topAnchor.constraint(equalTo: RedFangs.topAnchor)
        ])

        // Add new constraints for limiting the width of lbl_goldRibbon
        NSLayoutConstraint.activate([
            lbl_RedFangs.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20 * scalingFactor), // Limit the trailing edge to some margin from the right of the view.
            lbl_RedFangs.bottomAnchor.constraint(lessThanOrEqualTo: RedFangs.bottomAnchor), // Allow the label to wrap based on content up to the goldRibbon's bottom anchor.
            lbl_RedFangs.widthAnchor.constraint(lessThanOrEqualToConstant: 200) // Set a maximum width (adjust the constant as needed).
        ])
        
        
        // Set corner radius for all buttons and add a square border
        let cornerRadius: CGFloat = 15
        goldRibbon.layer.cornerRadius = cornerRadius
        goldRibbon.layer.borderWidth = 1
        goldRibbon.layer.borderColor = UIColor.white.cgColor

        blueRibbon.layer.cornerRadius = cornerRadius
        blueRibbon.layer.borderWidth = 1
        blueRibbon.layer.borderColor = UIColor.white.cgColor

        RedFangs.layer.cornerRadius = cornerRadius
        RedFangs.layer.borderWidth = 1
        RedFangs.layer.borderColor = UIColor.white.cgColor


        // Set the background color to teal blue
        goldRibbon.backgroundColor = .white
        blueRibbon.backgroundColor = .white
        RedFangs.backgroundColor = .white
       
        
        // Create the "BadgeStats" label
               let badgeStatsLabel = UILabel()
               badgeStatsLabel.text = "Your Badge Stats:"
               badgeStatsLabel.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask constraints
               badgeStatsLabel.textColor = .black
        
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_badgeStatsLabel: CGFloat = 25.0 // Set your base font size
        let adjustedFontSize_badgeStatsLabel = baseFontSize_badgeStatsLabel * scalingFactor

        // Set the font size for lbl_Playometer
        badgeStatsLabel.font = UIFont.systemFont(ofSize: adjustedFontSize_badgeStatsLabel)
               // Add the label to the view
               view.addSubview(badgeStatsLabel)
        
        
        
        NSLayoutConstraint.activate([
            badgeStatsLabel.topAnchor.constraint(equalTo: RedFangs.bottomAnchor, constant: 65 * scalingFactor),
            badgeStatsLabel.leadingAnchor.constraint(equalTo: goldRibbon.leadingAnchor)
            
        ])
        
        
      
               let GoldRibbonStatLabel = UILabel()
        GoldRibbonStatLabel.text = "Gold Ribbon:"
        GoldRibbonStatLabel.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask constraints
        GoldRibbonStatLabel.textColor = .black
        
        
        // Calculate the adjusted font size based on the scalingFactor
        let baseFontSize_GoldRibbonStatLabel: CGFloat = 20.0 // Set your base font size
        let adjustedFontSize_GoldRibbonStatLabel = baseFontSize_GoldRibbonStatLabel * scalingFactor

        // Set the font size for lbl_Playometer
        GoldRibbonStatLabel.font = UIFont.systemFont(ofSize: adjustedFontSize_GoldRibbonStatLabel)
               // Add the label to the view
               view.addSubview(GoldRibbonStatLabel)
        
        
        
        NSLayoutConstraint.activate([
            GoldRibbonStatLabel.topAnchor.constraint(equalTo: badgeStatsLabel.bottomAnchor, constant: 25 * scalingFactor),
            GoldRibbonStatLabel.leadingAnchor.constraint(equalTo: badgeStatsLabel.leadingAnchor)
            
        ])
        
        
        let BlueRibbonDoublesStatLabel = UILabel()
        BlueRibbonDoublesStatLabel.text = "Blue Ribbon (Doubles):"
        BlueRibbonDoublesStatLabel.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask constraints
        BlueRibbonDoublesStatLabel.textColor = .black
 
 
 // Calculate the adjusted font size based on the scalingFactor
 let baseFontSize_BlueRibbonDoublesStatLabel: CGFloat = 20.0 // Set your base font size
 let adjustedFontSize_BlueRibbonDoublesStatLabel = baseFontSize_BlueRibbonDoublesStatLabel * scalingFactor

 // Set the font size for lbl_Playometer
        BlueRibbonDoublesStatLabel.font = UIFont.systemFont(ofSize: adjustedFontSize_BlueRibbonDoublesStatLabel)
        // Add the label to the view
        view.addSubview(BlueRibbonDoublesStatLabel)
 
 
 
 NSLayoutConstraint.activate([
    BlueRibbonDoublesStatLabel.topAnchor.constraint(equalTo: GoldRibbonStatLabel.bottomAnchor, constant: 25 * scalingFactor),
    BlueRibbonDoublesStatLabel.leadingAnchor.constraint(equalTo: GoldRibbonStatLabel.leadingAnchor)
     
 ])
        
        
        let BlueRibbonSinglesStatLabel = UILabel()
        BlueRibbonSinglesStatLabel.text = "Blue Ribbon (Singles):"
        BlueRibbonSinglesStatLabel.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask constraints
        BlueRibbonSinglesStatLabel.textColor = .black
 
 
 // Calculate the adjusted font size based on the scalingFactor
 let baseFontSize_BlueRibbonSinglesStatLabel: CGFloat = 20.0 // Set your base font size
 let adjustedFontSize_BlueRibbonSinglesStatLabel = baseFontSize_BlueRibbonSinglesStatLabel * scalingFactor

 // Set the font size for lbl_Playometer
        BlueRibbonSinglesStatLabel.font = UIFont.systemFont(ofSize: adjustedFontSize_BlueRibbonSinglesStatLabel)
        // Add the label to the view
        view.addSubview(BlueRibbonSinglesStatLabel)
 
 
 
 NSLayoutConstraint.activate([
    BlueRibbonSinglesStatLabel.topAnchor.constraint(equalTo: BlueRibbonDoublesStatLabel.bottomAnchor, constant: 25 * scalingFactor),
    BlueRibbonSinglesStatLabel.leadingAnchor.constraint(equalTo: BlueRibbonDoublesStatLabel.leadingAnchor)
     
 ])
        
        
        let RedFangsStatLabel = UILabel()
        RedFangsStatLabel.text = "Red Fangs:"
        RedFangsStatLabel.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask constraints
        RedFangsStatLabel.textColor = .black
 
 
 // Calculate the adjusted font size based on the scalingFactor
 let baseFontSize_RedFangsStatLabel: CGFloat = 20.0 // Set your base font size
 let adjustedFontSize_RedFangsStatLabel = baseFontSize_RedFangsStatLabel * scalingFactor

 // Set the font size for lbl_Playometer
        RedFangsStatLabel.font = UIFont.systemFont(ofSize: adjustedFontSize_RedFangsStatLabel)
        // Add the label to the view
        view.addSubview(RedFangsStatLabel)
 
 
 
 NSLayoutConstraint.activate([
    RedFangsStatLabel.topAnchor.constraint(equalTo: BlueRibbonSinglesStatLabel.bottomAnchor, constant: 25 * scalingFactor),
    RedFangsStatLabel.leadingAnchor.constraint(equalTo: BlueRibbonSinglesStatLabel.leadingAnchor)
     
 ])
        
        
        let lbl_badgeinfo = UILabel()
        lbl_badgeinfo.text = "If you achieve a badge it will stay on your home screen"
        lbl_badgeinfo.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask constraints
        lbl_badgeinfo.textColor = .black
        
 
 // Calculate the adjusted font size based on the scalingFactor
 let baseFontSize_lbl_badgeinfo: CGFloat = 13.0 // Set your base font size
 let adjustedFontSize_lbl_badgeinfo = baseFontSize_lbl_badgeinfo * scalingFactor

       
        // Create an italic variant of the system font
        let italicFont = UIFont.italicSystemFont(ofSize: adjustedFontSize_lbl_badgeinfo)

        lbl_badgeinfo.font = italicFont // Set the italic font
        // Add the label to the view
        view.addSubview(lbl_badgeinfo)
 
 
 
        NSLayoutConstraint.activate([
            lbl_badgeinfo.topAnchor.constraint(equalTo: RedFangsStatLabel.bottomAnchor, constant: 30 * scalingFactor),
            lbl_badgeinfo.centerXAnchor.constraint(equalTo: view.centerXAnchor) // Center horizontally
        ])
        
        let lbl_GoldRibbon_Value: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont(name: "Impact", size: 20)
            label.textColor = .black // Set your desired text color
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let lbl_BlueRibbonDoubles_Value: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont(name: "Impact", size: 20)
            label.textColor = .black // Set your desired text color
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let lbl_BlueRibbonSingles_Value: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont(name: "Impact", size: 20)
            label.textColor = .black // Set your desired text color
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        let lbl_RedFangs_Value: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont(name: "Impact", size: 20)
            label.textColor = .black // Set your desired text color
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        view.addSubview(lbl_GoldRibbon_Value)
        
        NSLayoutConstraint.activate([
           lbl_GoldRibbon_Value.topAnchor.constraint(equalTo: GoldRibbonStatLabel.topAnchor),
           lbl_GoldRibbon_Value.leadingAnchor.constraint(equalTo: GoldRibbonStatLabel.trailingAnchor, constant: 20 * scalingFactor)
            
        ])
        
        view.addSubview(lbl_BlueRibbonDoubles_Value)
        
        NSLayoutConstraint.activate([
            lbl_BlueRibbonDoubles_Value.topAnchor.constraint(equalTo: BlueRibbonDoublesStatLabel.topAnchor),
            lbl_BlueRibbonDoubles_Value.leadingAnchor.constraint(equalTo: BlueRibbonDoublesStatLabel.trailingAnchor, constant: 20 * scalingFactor)
            
        ])
        
        view.addSubview(lbl_BlueRibbonSingles_Value)
        
        NSLayoutConstraint.activate([
            lbl_BlueRibbonSingles_Value.topAnchor.constraint(equalTo: BlueRibbonSinglesStatLabel.topAnchor),
            lbl_BlueRibbonSingles_Value.leadingAnchor.constraint(equalTo: BlueRibbonSinglesStatLabel.trailingAnchor, constant: 20 * scalingFactor)
            
        ])
        
        view.addSubview(lbl_RedFangs_Value)
        
        NSLayoutConstraint.activate([
            lbl_RedFangs_Value.topAnchor.constraint(equalTo: RedFangsStatLabel.topAnchor),
            lbl_RedFangs_Value.leadingAnchor.constraint(equalTo: RedFangsStatLabel.trailingAnchor, constant: 20 * scalingFactor)
            
        ])
        
 
        lbl_GoldRibbon_Value.textColor = UIColor.black
        lbl_BlueRibbonDoubles_Value.textColor = UIColor.black
        lbl_BlueRibbonSingles_Value.textColor = UIColor.black
        lbl_RedFangs_Value.textColor = UIColor.black
        
        func GetBadgeData() {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email
            let docRef = db.collection("Agressv_Badges").document(uid!)
            
            docRef.getDocument { (document, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    print("\(document!.documentID) => \(String(describing: document!.data()))")
                    
                    //Doubles Wins number to string conversion
                    let GoldRibbonValue = document!.data()!["Gold_Ribbon"]
                    let GoldRibbonValue_As_String = String(describing: GoldRibbonValue!)
                    lbl_GoldRibbon_Value.text = GoldRibbonValue_As_String
                    
                    let BlueRibbonDoubles_Value = document!.data()!["Blue_Ribbon_Doubles"]
                    let BlueRibbonDoubles_Value_As_String = String(describing: BlueRibbonDoubles_Value!)
                    lbl_BlueRibbonDoubles_Value.text = BlueRibbonDoubles_Value_As_String
                    
                    let BlueRibbonSingles_Value = document!.data()!["Blue_Ribbon_Singles"]
                    let BlueRibbonSingles_Value_As_String = String(describing: BlueRibbonSingles_Value!)
                    lbl_BlueRibbonSingles_Value.text = BlueRibbonSingles_Value_As_String
                    
                    let RedFangsValue = document!.data()!["Red_Fangs"]
                    let RedFangsValue_As_String = String(describing: RedFangsValue!)
                    lbl_RedFangs_Value.text = RedFangsValue_As_String
                }
                
            }
            
        }
        print(GetBadgeData())
   
        
    } //end of load
    

    
    
    
    

}//end of class
