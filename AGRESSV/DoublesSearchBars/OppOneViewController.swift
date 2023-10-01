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
            let partner = PartnerSelectionUsername
            
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
                                    self.dataSourceArrayOppOne.append(userWithFormattedRank)
                        
                        
                        self.dataSourceArrayOppOne.removeAll { $0 == partner }
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
        if oppsearching{
            let selectedValue = filtereddataSourceArrayOppOne[indexPath.row]
            SharedData.shared.OppOneSelection = selectedValue
        }
        else
        {
            let selectedValue = dataSourceArrayOppOne[indexPath.row]
            SharedData.shared.OppOneSelection = selectedValue
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
        
        
        if oppsearching {
            cell.textLabel?.text = filtereddataSourceArrayOppOne[indexPath.row]
            
        }
        else {
            cell.textLabel?.text = dataSourceArrayOppOne[indexPath.row]
          
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
