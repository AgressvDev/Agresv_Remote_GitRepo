//
//  OppTwoViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/27/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class OppTwoViewController: UIViewController {

    
    @IBOutlet weak var lbl_PickOppTwo: UILabel!
    
    @IBOutlet weak var SB_OppTwo: UISearchBar!
    
    @IBOutlet weak var Table_OppTwoUsernames: UITableView!
    
    
    var PartnerSelectionUsername: String = SharedData.shared.PartnerSelection
    var OppOneSelectionUsername: String = SharedData.shared.OppOneSelection
    
    var dataSourceArrayOppTwo = [String]()
    var filtereddataSourceArrayOppTwo = [String]()
    var opptwosearching = false
    
    var Highest_Score_Doubles: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        SB_OppTwo.delegate = self
        
        
        SB_OppTwo.backgroundImage = UIImage()
        SB_OppTwo.barTintColor = UIColor.white
        SB_OppTwo.layer.borderColor = UIColor.clear.cgColor
       
        // Set the default placeholder text
        SB_OppTwo.placeholder = "Search Username"
        
        
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
        

//        //Gradient background
//         
//         let gradientLayer = CAGradientLayer()
//         
//         gradientLayer.frame = view.bounds
//         
//         gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor] //UIColor.red.cgColor]
//         
//         gradientLayer.shouldRasterize = true
//         
//         //GradientPartnerbackground.layer.addSublayer(gradientLayer)
//         
//         self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        //end gradient background view
        
//        func fetchUsernames(completion: @escaping (Error?) -> Void) {
//            let uid = Auth.auth().currentUser!.email
//            let db = Firestore.firestore()
//            let usersCollection = db.collection("Agressv_Users").whereField("Email", isNotEqualTo: uid!)
//            let partner = PartnerSelectionUsername
//            let oppone = OppOneSelectionUsername
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
//                                    self.dataSourceArrayOppTwo.append(userWithFormattedRank)
//
//                        self.dataSourceArrayOppTwo.removeAll { $0 == partner }
//                        self.dataSourceArrayOppTwo.removeAll { $0 == oppone }
//
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
            let oppone = OppOneSelectionUsername
            
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
                                self.dataSourceArrayOppTwo.append(userWithFormattedRank)
                                self.dataSourceArrayOppTwo.removeAll { $0 == partner }
                                self.dataSourceArrayOppTwo.removeAll { $0 == oppone }
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

            self.Table_OppTwoUsernames.reloadData()
        }


        
        // Call this method initially to display the data in alphabetical order.
                alphabetizeDataAndReloadTableView()
            

            func alphabetizeDataAndReloadTableView() {
                // Sort the dataArray in alphabetical order.
                dataSourceArrayOppTwo.sort()

                
                // Reload the table view to display the sorted data.
                Table_OppTwoUsernames.reloadData()
            }
        
        
    } // end of load
    

    func GetOppTwoEmail(usernameselection: String) {
        let db = Firestore.firestore()
        let uid = usernameselection
        let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)

        query.getDocuments { (querySnapshot, error) in
            if error != nil {
                print("error")
            } else {
                for document in querySnapshot!.documents {
                    // Access the value of field2 from the document
                    let OppTwoEmail = document.data()["Email"] as? String
                    SharedDataEmails.sharedemails.OppTwoEmail = OppTwoEmail!
                    
                    //prep for sending partner variable
                    let LogGameVC = self.storyboard?.instantiateViewController(withIdentifier: "AddGameID") as! AddGameViewController
                    
                       // Set the selected cell's value as the public variable in SecondViewController
                   
                       
                       // Push to the SecondViewController
                    self.navigationController?.pushViewController(LogGameVC, animated: true)
                }
            }
        }
    }

} //end of class

extension OppTwoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0 // Adjust this value to your desired cell height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if opptwosearching {
           return filtereddataSourceArrayOppTwo.count
        }
        else
        {
            return dataSourceArrayOppTwo.count
        }
            

    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if opptwosearching {
                     let selectedValue = filtereddataSourceArrayOppTwo[indexPath.row]
                     SharedData.shared.OppTwoSelection = selectedValue

                     // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                     if let username = selectedValue.components(separatedBy: " - ").first {
                         SharedDataNoRank.sharednorank.OppTwoSelection_NoRank = username
                         
                         GetOppTwoEmail(usernameselection: username)
                     }
                 } else {
                     let selectedValue = dataSourceArrayOppTwo[indexPath.row]
                     SharedData.shared.OppTwoSelection = selectedValue

                     // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                     if let username = selectedValue.components(separatedBy: " - ").first {
                         SharedDataNoRank.sharednorank.OppTwoSelection_NoRank = username
                         
                         GetOppTwoEmail(usernameselection: username)
                         
                     }
                 }
            
         
         
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
        
        var text = dataSourceArrayOppTwo[indexPath.row] // By default, set the cell's text

            if opptwosearching {
                text = filtereddataSourceArrayOppTwo[indexPath.row]
            }

            cell.textLabel?.text = text

        if let _ = text.components(separatedBy: " - ").first,
            let doublesRankString = text.components(separatedBy: " - ").last,
            let doublesRank = Double(doublesRankString) {
            
            if doublesRank > 8.5 {
                if doublesRank == Highest_Score_Doubles {
                    let imageView = UIImageView(image: UIImage(named: "BlueRibbon.png"))
                    imageView.frame = CGRect(x: cell.contentView.frame.width - 40, y: 10, width: 30, height: 30)
                    cell.contentView.addSubview(imageView)
                }
                
            }
        }

            return cell


    }
}


    
extension OppTwoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filteredDataSourceArrayPartner = dataSourceArrayPartner.filter({$0.prefix(searchText.count)==searchText})
        if searchText.isEmpty {
                // If the search text is empty, show all items
            filtereddataSourceArrayOppTwo = dataSourceArrayOppTwo
            } else {
                // Filter the data source array based on the search text
                filtereddataSourceArrayOppTwo = dataSourceArrayOppTwo.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        opptwosearching = true
        Table_OppTwoUsernames.reloadData()
    }
}
