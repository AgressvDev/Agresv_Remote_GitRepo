//
//  DoublesSearchVCNew.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/24/23.
//

import UIKit

class DoublesSearchVCNew: UIViewController {
    
    
    
    
    
    

    
    @IBOutlet weak var lbl_PickPartner: UILabel!
    
    @IBOutlet weak var SB_PartnerSearchBar: UISearchBar!
    
    @IBOutlet weak var Table_PartnerUsernames: UITableView!
    
    
    var dataSourceArrayPartner = ["guyfromservicerd","BigDumbPickle","AnnePickle","69erFuckboyPickle", "sonofBitch", "crazyAlWaters", "sucky", "AndyDick", "dumbguy", "BenJohns", "Riley2D3", "luckDragon", "Alf", "cronos", "Marty", "CarlWeathers", "TheRollingStones"]
    
//    var dataSourceArrayOpponentOne = ["player1","player2","player3","player4"]
//    var dataSourceArrayOpponentTwo = ["player1","player2","player3","player4"]
//
    var filteredDataSourceArrayPartner = [String]()
    
//    var filteredDataSourceArrayOpponentOne = [String]()
//    var filteredDataSourceArrayOpponentTwo = [String]()
    
    var searching = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
           return filteredDataSourceArrayPartner.count
        }
        else
        {
            return dataSourceArrayPartner.count
        }
            

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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

