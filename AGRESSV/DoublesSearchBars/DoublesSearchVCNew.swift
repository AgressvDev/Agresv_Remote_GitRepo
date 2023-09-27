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
                        self.dataSourceArrayPartner.append(username)
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
         }
         else
         {
             let selectedValue = dataSourceArrayPartner[indexPath.row]
             SharedData.shared.PartnerSelection = selectedValue
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
            
        }
        else {
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

