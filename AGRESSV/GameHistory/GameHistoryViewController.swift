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
        var Game_Result_Opposite_For_UserView: String?
        var gameID: String
        var gameType: String?
    }

    var currentUserUsername: String = ""
    
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
        
        
        func getcurrentuser() {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email
            let docRef = db.collection("Agressv_Users").document(uid!)
            
            docRef.getDocument { (document, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    print("\(document!.documentID) => \(String(describing: document!.data()))")
                    
                    //                    let CurrentUser = document!.data()!["Username"]
                    //                    let Current_User_As_String = String(describing: CurrentUser!)
                     let username = document?["Username"] as? String
                       
                    let norank = "\(String(describing: username))"
                        
                        DispatchQueue.main.async {
                           
                            self.currentUserUsername = norank
                            
                        }
                       
                    
                }
            }
        }
        print(getcurrentuser())
        

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
                                                   gameResult: document["Game_Result"] as? String,
                                                   Game_Result_Opposite_For_UserView: document["Game_Result_Opposite_For_UserView"] as? String,
                                                   gameID: document.documentID,
                                                   gameType: document["Game_Type"] as? String
                                                   
                                               )
                                               return gameData
                                           }
                                           // Update Game_Result conditionally for games where Game_Creator is not the current user
                                                       for index in 0..<self.games.count {
                                                           if self.games[index].gameCreatorUsername != self.currentUserUsername {
                                                               if self.games[index].gameResult == "W" {
                                                                   self.games[index].gameResult = "L"
                                                               } else if self.games[index].gameResult == "L" {
                                                                   self.games[index].gameResult = "W"
                                                               }
                                                           }
                                                       }

                                                       // Reload the table view with the updated data
                                                       self.Table_GameHistory.reloadData()
                                                   }
                                               }
                                           }
           
        
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
                      attributedText.append(NSAttributedString(string: "Logged By: ", attributes: keyAttributes))
                      
                      // Always append the game creator's username, even if it's nil or empty
                      attributedText.append(NSAttributedString(string: "\(game.gameCreatorUsername ?? "N/A")\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Game Type: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(game.gameType ?? "")\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Date: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(dateFormatter.string(from: gameDate))\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Partner Username: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(game.gamePartnerUsername ?? "")\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Opponent One Username: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(game.gameOpponentOneUsername ?? "")\n", attributes: valueAttributes))
                      
                      attributedText.append(NSAttributedString(string: "Opponent Two Username: ", attributes: keyAttributes))
                      attributedText.append(NSAttributedString(string: "\(game.gameOpponentTwoUsername ?? "")\n", attributes: valueAttributes))
                      
                      // Use the swapped result for the current user's game result
                      var resultAttributes: [NSAttributedString.Key: Any] = [
                          .foregroundColor: UIColor.black, // Default text color for Game_Result
                      ]
                      if game.gameResult == "W" {
                          resultAttributes[.foregroundColor] = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
                      } else if game.gameResult == "L" {
                          resultAttributes[.foregroundColor] = UIColor.red
                      }
                      
                      attributedText.append(NSAttributedString(string: "Your Game Result: ", attributes: keyAttributes))
                      
                      // Always append the game result, even if it's nil or empty
                      attributedText.append(NSAttributedString(string: "\(game.gameResult ?? "N/A")\n", attributes: resultAttributes))
                      
                      cell.textLabel?.attributedText = attributedText
                  }
                  
                  return cell
              }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        
        // Get the Game_Creator email from the selected cell
        let gameCreatorEmail = game.gameCreatorUsername
        let gameid = game.gameID
        let gametype = game.gameType
        // Store the Game_Creator email in the shared variable
        SharedDataBlock.sharedblock.Game_Creator_forBlock = gameCreatorEmail
        SharedDataBlock.sharedblock.GameID = gameid
        SharedDataBlock.sharedblock.GameType = gametype
        // Create an instance of the destination view controller
        if let blockScreen = storyboard?.instantiateViewController(withIdentifier: "BlockScreenID") as? BlockScreenViewController {
            // Push to the destination view controller
            navigationController?.pushViewController(blockScreen, animated: true)
        }
    }
    
    
       } //end of class
