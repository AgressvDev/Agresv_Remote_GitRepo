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
    
    
    var dataSourceArrayOppTwo = [String]()
    var filtereddataSourceArrayOppTwo = [String]()
    var opptwosearching = false
    
    
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
                    if let username = document["Username"] as? String {
                        self.dataSourceArrayOppTwo.append(username)
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
         }
         else
         {
             let selectedValue = dataSourceArrayOppTwo[indexPath.row]
             
             SharedData.shared.OppTwoSelection = selectedValue
         }
            
         //prep for sending partner variable
         let LogGameVC = storyboard?.instantiateViewController(withIdentifier: "AddGameID") as! AddGameViewController
         
            // Set the selected cell's value as the public variable in SecondViewController
        
            
            // Push to the SecondViewController
            navigationController?.pushViewController(LogGameVC, animated: true)
         
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let customColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
        cell.contentView.backgroundColor = customColor
        
        
        if opptwosearching {
            cell.textLabel?.text = filtereddataSourceArrayOppTwo[indexPath.row]
            
        }
        else {
            cell.textLabel?.text = dataSourceArrayOppTwo[indexPath.row]
          
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
