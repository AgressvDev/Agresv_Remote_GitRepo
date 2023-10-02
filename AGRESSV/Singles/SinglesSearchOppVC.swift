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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Gradient background
         
         let gradientLayer = CAGradientLayer()
         
         gradientLayer.frame = view.bounds
         
         gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor] //UIColor.red.cgColor]
         
         gradientLayer.shouldRasterize = true
         
         //GradientPartnerbackground.layer.addSublayer(gradientLayer)
         
         self.view.layer.insertSublayer(gradientLayer, at: 0)
        //end gradient background view
        
        
        func fetchUsernames(completion: @escaping (Error?) -> Void) {
            let uid = Auth.auth().currentUser!.email
            let db = Firestore.firestore()
            let usersCollection = db.collection("Agressv_Users").whereField("Email", isNotEqualTo: uid!)

            usersCollection.getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(error)
                    return
                }

                for document in querySnapshot!.documents {
                    if let username = document["Username"] as? String,
                                   let doublesRank = document["Singles_Rank"] as? Double {
                                    let formattedRank = String(format: "%.1f", doublesRank)
                                    let userWithFormattedRank = "\(username) - \(formattedRank)"
                                    self.dataSourceArraySinglesOpp.append(userWithFormattedRank)
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

        if searching {
            cell.textLabel?.text = filteredDataSourceArraySinglesOpp[indexPath.row]
        } else {
            cell.textLabel?.text = dataSourceArraySinglesOpp[indexPath.row]
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
