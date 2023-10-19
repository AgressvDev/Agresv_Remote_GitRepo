//
//  OppOneViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/27/23.
//

import UIKit
import Firebase
import FirebaseFirestore


class OppOneViewController: UIViewController {

    
    
    @IBOutlet weak var lbl_PickOppOne: UILabel!
    
    
    @IBOutlet weak var SB_OppOne: UISearchBar!
    
    
    @IBOutlet weak var Table_OppOneUsernames: UITableView!
    
    var PartnerSelectionUsername: String = SharedData.shared.PartnerSelection
    
    
    var dataSourceArrayOppOne = [String]()
    var filtereddataSourceArrayOppOne = [String]()
    var oppsearching = false
    
    var Highest_Score_Doubles: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
                        
                        self.Highest_Score_Doubles = maxDoublesRank!
                        print(self.Highest_Score_Doubles)
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
//            let partner = PartnerSelectionUsername
//
//            usersCollection.getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    completion(error)
//                    return
//                }
//
//                for document in querySnapshot!.documents {
//                    if let username = document["Username"] as? String,
//                                   let doublesRank = document["Doubles_Rank"] as? Double {
//                                    let formattedRank = String(format: "%.1f", doublesRank)
//                                    let userWithFormattedRank = "\(username) - \(formattedRank)"
//                                    self.dataSourceArrayOppOne.append(userWithFormattedRank)
//
//
//                        self.dataSourceArrayOppOne.removeAll { $0 == partner }
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
            let partner = PartnerSelectionUsername
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
                           let doublesRank = document["Doubles_Rank"] as? Double {
                            let formattedRank = String(format: "%.1f", doublesRank)
                            let userWithFormattedRank = "\(username) - \(formattedRank)"

                            // Check if the username is not in plaintiffUsernames and add it to dataSourceArrayPartner
                            if !plaintiffUsernames.contains(username) {
                                self.dataSourceArrayOppOne.append(userWithFormattedRank)
                                self.dataSourceArrayOppOne.removeAll { $0 == partner }
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

            self.Table_OppOneUsernames.reloadData()
        }


        
        // Call this method initially to display the data in alphabetical order.
                alphabetizeDataAndReloadTableView()
            

            func alphabetizeDataAndReloadTableView() {
                // Sort the dataArray in alphabetical order.
                dataSourceArrayOppOne.sort()

                
                // Reload the table view to display the sorted data.
                Table_OppOneUsernames.reloadData()
            }
        
    } //end of load
    
    
    
   

} //end of class

extension OppOneViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0 // Adjust this value to your desired cell height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if oppsearching {
            return filtereddataSourceArrayOppOne.count
        }
        else
        {
            return dataSourceArrayOppOne.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if oppsearching {
                    let selectedValue = filtereddataSourceArrayOppOne[indexPath.row]
                    SharedData.shared.OppOneSelection = selectedValue

                    // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                    if let username = selectedValue.components(separatedBy: " - ").first {
                        SharedDataNoRank.sharednorank.OppOneSelection_NoRank = username
                    }
                } else {
                    let selectedValue = dataSourceArrayOppOne[indexPath.row]
                    SharedData.shared.OppOneSelection = selectedValue

                    // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                    if let username = selectedValue.components(separatedBy: " - ").first {
                        SharedDataNoRank.sharednorank.OppOneSelection_NoRank = username
                    }
                }
        // Create an instance of opp two VC
        let OppTwoVC = storyboard?.instantiateViewController(withIdentifier: "OppTwoID") as! OppTwoViewController
        
        //prep for sending partner variable
        //let LogGameVC = storyboard?.instantiateViewController(withIdentifier: "AddGameID") as! AddGameViewController
        
        // Set the selected cell's value as the public variable in SecondViewController
        ///LogGameVC.selectedCellValueOppOne = selectedValue
        
        
        // Push to the SecondViewController
        navigationController?.pushViewController(OppTwoVC, animated: true)
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let customColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
        cell.contentView.backgroundColor = customColor
        
        
        var text = dataSourceArrayOppOne[indexPath.row] // By default, set the cell's text

            if oppsearching {
                text = filtereddataSourceArrayOppOne[indexPath.row]
            }

            cell.textLabel?.text = text

        if let _ = text.components(separatedBy: " - ").first,
            let doublesRankString = text.components(separatedBy: " - ").last,
            let doublesRank = Double(doublesRankString) {
            
            if doublesRank > 8.5 {
                if doublesRank == Highest_Score_Doubles {
                    let imageView = UIImageView(image: UIImage(named: "BlackRibbonDoubles.png"))
                    imageView.frame = CGRect(x: cell.contentView.frame.width - 40, y: 10, width: 30, height: 30)
                    cell.contentView.addSubview(imageView)
                }
                
            }
        }

            return cell


    }
}


    
extension OppOneViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filteredDataSourceArrayPartner = dataSourceArrayPartner.filter({$0.prefix(searchText.count)==searchText})
        if searchText.isEmpty {
                // If the search text is empty, show all items
            filtereddataSourceArrayOppOne = dataSourceArrayOppOne
            } else {
                // Filter the data source array based on the search text
                filtereddataSourceArrayOppOne = dataSourceArrayOppOne.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        oppsearching = true
        Table_OppOneUsernames.reloadData()
    }
}
