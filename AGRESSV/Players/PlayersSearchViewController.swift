//
//  DoublesSearchVCNew.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/24/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class PlayersSearchViewController: UIViewController {
    
    


    
    

    @IBOutlet weak var SearchBar_Players: UISearchBar!
    

    
    @IBOutlet weak var lbl_SearchPlayers: UILabel!
    @IBOutlet weak var TableView_Players: UITableView!
    
    
    var dataSourceArrayPartner = [String]()
    var filteredDataSourceArrayPartner = [String]()
    

    var searching = false
    
    
    var Highest_Score_Doubles: Double = 0.0
   
    var isCurrentUserHighest: Bool = false
    
    var RedFang_Username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_SearchPlayers.textColor = UIColor.black
        
        // Set the background color
       
        SearchBar_Players.backgroundImage = UIImage()
        SearchBar_Players.barTintColor = UIColor.white
        SearchBar_Players.layer.borderColor = UIColor.clear.cgColor
       
        // Set the default placeholder text
        SearchBar_Players.placeholder = "Search Username"
        
        func GetHighScores() {
            
            let db = Firestore.firestore()
          
            let agressvUsersRef = db.collection("Agressv_Users")
            
            // Query to get the documents with max Doubles_Rank and max Singles_Rank
            agressvUsersRef
                .order(by: "Doubles_Rank", descending: true)
                .limit(to: 1)
                .getDocuments { (doublesRankQuerySnapshot, error) in
                    if let err = error {
                        print("Error getting documents: \(err)")
                    } else {
                        let maxDoublesRank = doublesRankQuerySnapshot?.documents.first?["Doubles_Rank"] as? Double
                        let roundedValue = round(maxDoublesRank! * 10) / 10.0
                        
                        
                        self.Highest_Score_Doubles = roundedValue
                        print(self.Highest_Score_Doubles)
                    }
                    
                }
        }
        print(GetHighScores())
        
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
       
        
        
        

        
   

        func fetchUsernames(completion: @escaping (Error?) -> Void) {
            // Get the current user's email
            guard let currentUserEmail = Auth.auth().currentUser?.email else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user email is nil"])
                completion(error)
                return
            }

            let db = Firestore.firestore()
            

            

                // Fetch data from "Agressv_Users" collection and remove Plaintiff_Usernames from dataSourceArrayPartner
                let usersCollection = db.collection("Agressv_Users").whereField("Email", isNotEqualTo: currentUserEmail)

                usersCollection.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        completion(error)
                        return
                    }

                    for document in querySnapshot!.documents {
                        if let username = document["Username"] as? String,
                           let doublesRank = document["Doubles_Rank"] as? Double {
                            let formattedRank = String(format: "%.1f", doublesRank)
                            let userWithFormattedRank = "\(username) - \(formattedRank)"

                            
                           
                                self.dataSourceArrayPartner.append(userWithFormattedRank)
                            
                        }
                    }

                    completion(nil)
                }
            }
        

        
        // Call the function to fetch and populate usernames
        fetchUsernames { error in
            if let error = error {
                print("Error fetching usernames: \(error.localizedDescription)")
                return
            }

            self.TableView_Players.reloadData()
        }


        
        // Call this method initially to display the data in alphabetical order.
                alphabetizeDataAndReloadTableView()
            

            func alphabetizeDataAndReloadTableView() {
                // Sort the dataArray in alphabetical order.
                dataSourceArrayPartner.sort()

                
                // Reload the table view to display the sorted data.
                TableView_Players.reloadData()
            }
        
    } //end of loading
    

    
   

    
} //end of class
    
    
extension PlayersSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0 // Adjust this value to your desired cell height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
           return filteredDataSourceArrayPartner.count
        }
        else
        {
            return dataSourceArrayPartner.count
        }
            

    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
         if searching {
                     let selectedValue = filteredDataSourceArrayPartner[indexPath.row]
             SharedPlayerData.shared.PlayerSelectedUsername_NoRank = selectedValue

                     // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                     if let username = selectedValue.components(separatedBy: " - ").first {
                         SharedPlayerData.shared.PlayerSelectedUsername_NoRank  = username
                     }
                 } else {
                     let selectedValue = dataSourceArrayPartner[indexPath.row]
                     SharedPlayerData.shared.PlayerSelectedUsername_NoRank  = selectedValue

                     // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                     if let username = selectedValue.components(separatedBy: " - ").first {
                         SharedPlayerData.shared.PlayerSelectedUsername_NoRank  = username
                     }
                 }
            // Create an instance of SecondViewController
            let PlayerProfileVC = storyboard?.instantiateViewController(withIdentifier: "PlayerProfileID") as! PlayerProfileViewController
            
         //prep for sending partner variable
         //let LogGameVC = storyboard?.instantiateViewController(withIdentifier: "AddGameID") as! AddGameViewController
         
            // Set the selected cell's value as the public variable in SecondViewController
         
        //LogGameVC.selectedCellValue = selectedValue
         
         
            
            // Push to the SecondViewController
            navigationController?.pushViewController(PlayerProfileVC, animated: true)
         
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
               let customColor = UIColor(red: 0/255, green: 0/255, blue: 30/255, alpha: 1.0)
               cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
                cell.textLabel?.textColor = UIColor.white
               cell.contentView.backgroundColor = customColor

        // Reset the cell's content view to remove any previously added image views
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }

            var text = dataSourceArrayPartner[indexPath.row] // By default, set the cell's text

            if searching {
                text = filteredDataSourceArrayPartner[indexPath.row]
            }

            cell.textLabel?.text = text
        
       
            if let _ = text.components(separatedBy: " - ").first,
               let doublesRankString = text.components(separatedBy: " - ").last,
               let doublesRank = Double(doublesRankString) {
                
                if doublesRank > 8.5
                {
                    if doublesRank == Highest_Score_Doubles
                    {
                        let imageView = UIImageView(image: UIImage(named: "BlueRibbon.png"))
                        imageView.frame = CGRect(x: cell.contentView.frame.width - 40, y: 10, width: 30, height: 30)
                        cell.contentView.addSubview(imageView)
                    }
                }
            }
        
        
        
                   return cell
    }
}


    
extension PlayersSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filteredDataSourceArrayPartner = dataSourceArrayPartner.filter({$0.prefix(searchText.count)==searchText})
        if searchText.isEmpty {
                // If the search text is empty, show all items
            filteredDataSourceArrayPartner = dataSourceArrayPartner
            } else {
                // Filter the data source array based on the search text
                filteredDataSourceArrayPartner = dataSourceArrayPartner.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        searching = true
        TableView_Players.reloadData()
    }
}



