//
//  DoublesSearchVCNew.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/24/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class DoublesSearchVCNew: UIViewController {
    
    


    
    
    @IBOutlet weak var lbl_PickPartner: UILabel!
    
    @IBOutlet weak var SB_PartnerSearchBar: UISearchBar!
    
    @IBOutlet weak var Table_PartnerUsernames: UITableView!
    
    
    
    var dataSourceArrayPartner = [String]()
    var filteredDataSourceArrayPartner = [String]()
    

    var searching = false
    
    
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

        //END BACKGROUND
   

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
                           let doublesRank = document["Doubles_Rank"] as? Double {
                            let formattedRank = String(format: "%.1f", doublesRank)
                            let userWithFormattedRank = "\(username) - \(formattedRank)"

                            // Check if the username is not in plaintiffUsernames and add it to dataSourceArrayPartner
                            if !plaintiffUsernames.contains(username) {
                                self.dataSourceArrayPartner.append(userWithFormattedRank)
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

            self.Table_PartnerUsernames.reloadData()
        }


        
        // Call this method initially to display the data in alphabetical order.
                alphabetizeDataAndReloadTableView()
            

            func alphabetizeDataAndReloadTableView() {
                // Sort the dataArray in alphabetical order.
                dataSourceArrayPartner.sort()

                
                // Reload the table view to display the sorted data.
                Table_PartnerUsernames.reloadData()
            }
        
    } //end of loading
    
    
    
} //end of class
    
    
extension DoublesSearchVCNew: UITableViewDelegate, UITableViewDataSource {

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
                     SharedData.shared.PartnerSelection = selectedValue

                     // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                     if let username = selectedValue.components(separatedBy: " - ").first {
                         SharedDataNoRank.sharednorank.PartnerSelection_NoRank = username
                     }
                 } else {
                     let selectedValue = dataSourceArrayPartner[indexPath.row]
                     SharedData.shared.PartnerSelection = selectedValue

                     // Extract username without the rank and assign it to SharedDataNoRank.sharednorank.PartnerSelection_NoRank
                     if let username = selectedValue.components(separatedBy: " - ").first {
                         SharedDataNoRank.sharednorank.PartnerSelection_NoRank = username
                     }
                 }
            // Create an instance of SecondViewController
            let OppOneVC = storyboard?.instantiateViewController(withIdentifier: "OppOneID") as! OppOneViewController
            
         //prep for sending partner variable
         //let LogGameVC = storyboard?.instantiateViewController(withIdentifier: "AddGameID") as! AddGameViewController
         
            // Set the selected cell's value as the public variable in SecondViewController
         
        //LogGameVC.selectedCellValue = selectedValue
         
         
            
            // Push to the SecondViewController
            navigationController?.pushViewController(OppOneVC, animated: true)
         
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let customColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
        cell.contentView.backgroundColor = customColor

        if searching {
            cell.textLabel?.text = filteredDataSourceArrayPartner[indexPath.row]
        } else {
            cell.textLabel?.text = dataSourceArrayPartner[indexPath.row]
        }

        return cell
    }
}


    
extension DoublesSearchVCNew: UISearchBarDelegate {
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
        Table_PartnerUsernames.reloadData()
    }
}

