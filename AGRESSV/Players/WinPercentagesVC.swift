//
//  WinPercentagesVC.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 1/5/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class WinPercentagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var segController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var scoresData: [(username: String, rank: Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self

        
        fetchWinPercentages()
        
    } //end of load
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        // Call the function to fetch and update the data based on the selected segment value
        fetchWinPercentages()
    }
    
    func fetchWinPercentages() {
        let db = Firestore.firestore()

        // Use the segmented control value to determine which scores to fetch
        let isDoublesSegmentSelected = segController.selectedSegmentIndex == 0

        db.collection("Agressv_Users")
            .order(by: isDoublesSegmentSelected ? "Doubles_Games_Wins" : "Singles_Games_Wins", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.scoresData.removeAll()

                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let username = data["Username"] as? String {
                            // Calculate win percentage based on the segController value
                            var winPercentage: Double = 0.0
                            if let gamesPlayed = isDoublesSegmentSelected ? (data["Doubles_Games_Played"] as? Double) : (data["Singles_Games_Played"] as? Double),
                               gamesPlayed > 0 {
                                let gamesWon = isDoublesSegmentSelected ? (data["Doubles_Games_Wins"] as? Double) : (data["Singles_Games_Wins"] as? Double) ?? 0.0
                                winPercentage = ((gamesWon ?? 0) / gamesPlayed * 100).rounded() 
                            }

                            // Append the data to the scoresData array
                            self.scoresData.append((username: username, rank: winPercentage))
                        }
                    }

                    // Order the scoresData array based on winPercentage in descending order
                    self.scoresData.sort { $0.rank > $1.rank }

                    // Reload the table view data on the main thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoresData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinCell", for: indexPath)

        // Configure the cell with the data from scoresData
        let score = scoresData[indexPath.row]
        cell.textLabel?.text = "\(score.username)  \(score.rank)"
        cell.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 30/255, alpha: 1.0)
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        return cell
    }

    
    
} //end of class
