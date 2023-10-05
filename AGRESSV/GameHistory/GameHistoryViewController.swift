//
//  GameHistoryViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/5/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class GameHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct GameData {
        var gameCreatorUsername: String?
        var gameDate: Timestamp?
        var gamePartnerUsername: String?
        var gameOpponentOneUsername: String?
        var gameOpponentTwoUsername: String?
        var gameResult: String?
    }

    
    
    // Firestore reference
        let db = Firestore.firestore()
        
        // Firebase Auth reference
        let auth = Auth.auth()
        
       
    
    // Date formatter to convert Firestore timestamps to human-readable dates
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()
    
    // Data source for the table view
        var games: [GameData] = []
        var originalDocuments: [QueryDocumentSnapshot] = []
    
    @IBOutlet weak var Table_GameHistory: UITableView!
    
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
        
        
        // Call a function to fetch data from Firestore
                fetchDataFromFirestore()
        
        
    } //end of load
    

    func fetchDataFromFirestore() {
            // Get the current user's email
            guard let userEmail = auth.currentUser?.email else {
                return
            }

        // Perform a Firestore query to fetch game data where any of the specified fields match the user's email
       
                
            let query1 = db.collection("Agressv_Games").whereFilter(
               
                Filter.orFilter([
                    Filter.whereField("Game_Creator", isEqualTo: userEmail),
                    Filter.whereField("Game_Opponent_One", isEqualTo: userEmail),
                    Filter.whereField("Game_Opponent_Two", isEqualTo: userEmail),
                    Filter.whereField("Game_Partner", isEqualTo: userEmail)

                ]))
                   query1.getDocuments { (querySnapshot, error) in
                       if let error = error {
                           print("Error fetching documents: \(error)")
                           return
                       }
                       // Store the original Firestore documents and transform data for display
                                       if let documents = querySnapshot?.documents {
                                           self.originalDocuments = documents
                                           self.games = documents.compactMap { document in
                                               let gameData = GameData(
                                                   gameCreatorUsername: document["Game_Creator_Username"] as? String,
                                                   gameDate: document["Game_Date"] as? Timestamp,
                                                   gamePartnerUsername: document["Game_Partner_Username"] as? String,
                                                   gameOpponentOneUsername: document["Game_Opponent_One_Username"] as? String,
                                                   gameOpponentTwoUsername: document["Game_Opponent_Two_Username"] as? String,
                                                   gameResult: document["Game_Result"] as? String
                                               )
                                               return gameData
                                           }
                                           self.Table_GameHistory.reloadData()
                       }
                   }
           }
           
           // MARK: - UITableViewDataSource methods
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return games.count
           }
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
               
               let game = games[indexPath.row] // Get the game data
               
               // Set the background color to a lighter grey
                  let lighterGreyColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
                  cell.backgroundColor = lighterGreyColor
                  
                  // Create a dictionary to define the text attributes (color) for keys and values
                  let keyAttributes: [NSAttributedString.Key: Any] = [
                      .foregroundColor: UIColor.black, // Key text color (black)
                  ]
                  let valueAttributes: [NSAttributedString.Key: Any] = [
                      .foregroundColor: UIColor.blue, // Value text color (blue)
                  ]
                  
                  // Customize the cell with the game data, including formatting the date
                  cell.textLabel?.numberOfLines = 0 // Allow multiline text
                  
                  if let gameDate = game.gameDate?.dateValue() {
                      // Create an attributed string with different text attributes for keys and values
                      let attributedText = NSMutableAttributedString()
                      attributedText.append(NSAttributedString(string: "Game Creator Username: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(game.gameCreatorUsername ?? "")\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Game Date: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(dateFormatter.string(from: gameDate))\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Game Partner Username: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(game.gamePartnerUsername ?? "")\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Game Opponent One Username: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(game.gameOpponentOneUsername ?? "")\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Game Opponent Two Username: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(game.gameOpponentTwoUsername ?? "")\n", attributes: valueAttributes))
                      
                      let gameResult = game.gameResult ?? ""
                      var resultAttributes: [NSAttributedString.Key: Any] = [
                          .foregroundColor: UIColor.black, // Default text color for Game_Result
                      ]
                      if gameResult == "W" {
                          resultAttributes[.foregroundColor] = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) 
                      } else if gameResult == "L" {
                          resultAttributes[.foregroundColor] = UIColor.red
                      }
                      
                      attributedText.append(NSAttributedString(string: "Game Result: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(gameResult)\n", attributes: resultAttributes))
                      
                      cell.textLabel?.attributedText = attributedText
                  }

                       
                       return cell
           }
       } //end of class
