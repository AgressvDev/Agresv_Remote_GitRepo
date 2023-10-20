//
//  SinglesSearchOppVC.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/1/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class SinglesSearchOppVC: UIViewController {

    
    @IBOutlet weak var SB_SinglesSearchBar: UISearchBar!
    
    @IBOutlet weak var Table_SinglesUsernames: UITableView!
    
    var dataSourceArraySinglesOpp = [String]()
    var filteredDataSourceArraySinglesOpp = [String]()
    
    var searching = false
    
    var Highest_Score_Singles: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        func GetHighScores() {
            
            let db = Firestore.firestore()
          
            let agressvUsersRef = db.collection("Agressv_Users")
            
            // Query to get the documents with max Doubles_Rank and max Singles_Rank
            agressvUsersRef
                .order(by: "Singles_Rank", descending: true)
                .limit(to: 1)
                .getDocuments { (singlesRankQuerySnapshot, error) in
                    if let err = error {
                        print("Error getting documents: \(err)")
                    } else {
                        let maxSinglesRank = singlesRankQuerySnapshot?.documents.first?["Singles_Rank"] as? Double
                        let roundedValueSingles = round(maxSinglesRank! * 10) / 10.0
                        
                        self.Highest_Score_Singles = roundedValueSingles
                        print(self.Highest_Score_Singles)
                    }
                    
                }
        }
        print(GetHighScores())

        //Gradient background
         
         let gradientLayer = CAGradientLayer()
         
         gradientLayer.frame = view.bounds
         
         gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor] //UIColor.red.cgColor]
         
         gradientLayer.shouldRasterize = true
         
         //GradientPartnerbackground.layer.addSublayer(gradientLayer)
         
         self.view.layer.insertSublayer(gradientLayer, at: 0)
        //end gradient background view
        
        
//        func fetchUsernames(completion: @escaping (Error?) -> Void) {
//            let uid = Auth.auth().currentUser!.email
//            let db = Firestore.firestore()
//            let usersCollection = db.collection("Agressv_Users").whereField("Email", isNotEqualTo: uid!)
//
//            usersCollection.getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    completion(error)
//                    return
//                }
//
//                for document in querySnapshot!.documents {
//                    if let username = document["Username"] as? String,
//                                   let doublesRank = document["Singles_Rank"] as? Double {
//                                    let formattedRank = String(format: "%.1f", doublesRank)
//                                    let userWithFormattedRank = "\(username) - \(formattedRank)"
//                                    self.dataSourceArraySinglesOpp.append(userWithFormattedRank)
//                    }
//                }
//
//                completion(nil)
//            }
//        }
        
        func fetchUsernames(completion: @escaping (Error?) -> Void) {
            // Get the current user's email
            guard let currentUserEmail = Auth.auth().currentUser?.email else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user email is nil"])
                completion(error)
                return
            }

            let db = Firestore.firestore()
            let blockedCollection = db.collection("Agressv_Blocked").whereField("Blocked_Email", isEqualTo: currentUserEmail)

            // Create an array to store Plaintiff_Usernames
            var plaintiffUsernames: [String] = []

            blockedCollection.getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(error)
                    return
                }

                // Retrieve Plaintiff_Username values and populate the plaintiffUsernames array
                for document in querySnapshot!.documents {
                    if let plaintiffUsername = document["Plaintiff_Username"] as? String {
                        plaintiffUsernames.append(plaintiffUsername)
                    }
                }

                // Fetch data from "Agressv_Users" collection and remove Plaintiff_Usernames from dataSourceArrayPartner
                let usersCollection = db.collection("Agressv_Users").whereField("Email", isNotEqualTo: currentUserEmail)

                usersCollection.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        completion(error)
                        return
                    }

                    for document in querySnapshot!.documents {
                        if let username = document["Username"] as? String,
                           let singlesRank = document["Singles_Rank"] as? Double {
                            let formattedRank = String(format: "%.1f", singlesRank)
                            let userWithFormattedRank = "\(username) - \(formattedRank)"

                            // Check if the username is not in plaintiffUsernames and add it to dataSourceArrayPartner
                            if !plaintiffUsernames.contains(username) {
                                self.dataSourceArraySinglesOpp.append(userWithFormattedRank)
                            }
                        }
                    }

                    completion(nil)
                }
            }
        }
        
        // Call the function to fetch and populate usernames
        fetchUsernames { error in
            if let error = error {
                print("Error fetching usernames: \(error.localizedDescription)")
                return
            }

            self.Table_SinglesUsernames.reloadData()
        }


        
        // Call this method initially to display the data in alphabetical order.
                alphabetizeDataAndReloadTableView()
            

            func alphabetizeDataAndReloadTableView() {
                // Sort the dataArray in alphabetical order.
                dataSourceArraySinglesOpp.sort()

                
                // Reload the table view to display the sorted data.
                Table_SinglesUsernames.reloadData()
            }
        
    } //end of load
    

   

} //end of class
extension SinglesSearchOppVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0 // Adjust this value to your desired cell height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
           return filteredDataSourceArraySinglesOpp.count
        }
        else
        {
            return dataSourceArraySinglesOpp.count
        }
            

    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
         if searching {
                     let selectedValue = filteredDataSourceArraySinglesOpp[indexPath.row]
                     SharedData.shared.OppOneSelection = selectedValue

                     // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                     if let username = selectedValue.components(separatedBy: " - ").first {
                         SharedDataNoRank.sharednorank.OppOneSelection_NoRank = username
                     }
                 } else {
                     let selectedValue = dataSourceArraySinglesOpp[indexPath.row]
                     SharedData.shared.OppOneSelection = selectedValue

                     // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                     if let username = selectedValue.components(separatedBy: " - ").first {
                         SharedDataNoRank.sharednorank.OppOneSelection_NoRank = username
                     }
                 }
         //prep for sending partner variable
         let LogGameSinglesVC = storyboard?.instantiateViewController(withIdentifier: "SinglesAddGameID") as! SinglesAddGameViewController
         
            // Set the selected cell's value as the public variable in SecondViewController
        
            
            // Push to the SecondViewController
            navigationController?.pushViewController(LogGameSinglesVC, animated: true)
         
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let customColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
        cell.contentView.backgroundColor = customColor

        // Reset the cell's content view to remove any previously added image views
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
        
        var text = dataSourceArraySinglesOpp[indexPath.row] // By default, set the cell's text

            if searching {
                text = filteredDataSourceArraySinglesOpp[indexPath.row]
            }

            cell.textLabel?.text = text

        if let _ = text.components(separatedBy: " - ").first,
            let SinglesRankString = text.components(separatedBy: " - ").last,
            let singlesRank = Double(SinglesRankString) {
            
            if singlesRank > 8.5 {
                if singlesRank == Highest_Score_Singles {
                    let imageView = UIImageView(image: UIImage(named: "BlueRibbon.png"))
                    imageView.frame = CGRect(x: cell.contentView.frame.width - 40, y: 10, width: 30, height: 30)
                    cell.contentView.addSubview(imageView)
                }
                
            }
        }

            return cell
    }
}


    
extension SinglesSearchOppVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filteredDataSourceArrayPartner = dataSourceArrayPartner.filter({$0.prefix(searchText.count)==searchText})
        if searchText.isEmpty {
                // If the search text is empty, show all items
            filteredDataSourceArraySinglesOpp = dataSourceArraySinglesOpp
            } else {
                // Filter the data source array based on the search text
                filteredDataSourceArraySinglesOpp = dataSourceArraySinglesOpp.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        searching = true
        Table_SinglesUsernames.reloadData()
    }
}
