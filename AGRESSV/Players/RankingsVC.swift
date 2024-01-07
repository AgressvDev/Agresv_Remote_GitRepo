//
//  RankingsVC.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 1/5/24.
//

import UIKit
import Firebase
import FirebaseFirestore


class RankingsVC: UIViewController {

    @IBOutlet weak var segController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var Weighted_Score: Double = 0.60
    var Weighted_GamesPlayed: Double = 0.25
    var Weighted_WinPercentage: Double = 0.15

    //var UserDataDictionary: [String: Any] = [:]
    var userDataDictionary: [String: [String: Double]] = [:]
    var sortedUsernames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    } //end of load

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        fetchData()
    }

    func fetchData() {
        fetchScores()
      
    }


    


    
    func fetchScores() {
        let db = Firestore.firestore()
        let isDoublesSegmentSelected = segController.selectedSegmentIndex == 0

        self.userDataDictionary.removeAll()

        db.collection("Agressv_Users")
            .order(by: isDoublesSegmentSelected ? "Doubles_Rank" : "Singles_Rank", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let username = data["Username"] as! String

                        if let score = isDoublesSegmentSelected ? (data["Doubles_Rank"] as? Double) : (data["Singles_Rank"] as? Double) {
                            let roundedScore = (score * 10).rounded() / 10
                            let weightedScore = roundedScore * self.Weighted_Score
                            self.userDataDictionary[username, default: [:]]["weightedScore"] = (self.userDataDictionary[username]?["weightedScore"] ?? 0.0) + weightedScore
                        }

                        if let games = isDoublesSegmentSelected ? (data["Doubles_Games_Played"] as? Double) : (data["Singles_Games_Played"] as? Double) {
                            let weightedGames = games * self.Weighted_GamesPlayed
                            self.userDataDictionary[username, default: [:]]["weightedGames"] = (self.userDataDictionary[username]?["weightedGames"] ?? 0.0) + weightedGames
                        }

                        if let gamesPlayed = isDoublesSegmentSelected ? (data["Doubles_Games_Played"] as? Double) : (data["Singles_Games_Played"] as? Double),
                           gamesPlayed > 0 {
                            let gamesWon = isDoublesSegmentSelected ? (data["Doubles_Games_Wins"] as? Double) : (data["Singles_Games_Wins"] as? Double) ?? 0.0
                            let winPercentage = ((gamesWon ?? 0) / gamesPlayed * 100).rounded()
                            let weightedWinPercentage = winPercentage * self.Weighted_WinPercentage / 100
                            self.userDataDictionary[username, default: [:]]["weightedWinPercentage"] = (self.userDataDictionary[username]?["weightedWinPercentage"] ?? 0.0) + weightedWinPercentage
                        }
                    }

                    // Calculate the Sum_Of_Weights for each username
                    for (username, values) in self.userDataDictionary {
                        let sumOfWeights = (values["weightedScore"] ?? 0.0) + (values["weightedGames"] ?? 0.0) + (values["weightedWinPercentage"] ?? 0.0)
                        
                        // Round the sumOfWeights to 2 decimal places
                        let roundedSumOfWeights = (sumOfWeights * 100).rounded() / 100
                        
                        self.userDataDictionary[username]?["Sum_Of_Weights"] = roundedSumOfWeights
                    }
                    // Sort the usernames based on Sum_Of_Weights in descending order
                        self.sortedUsernames = self.userDataDictionary.keys.sorted(by: { (username1, username2) -> Bool in
                            return (self.userDataDictionary[username1]?["Sum_Of_Weights"] ?? 0.0) > (self.userDataDictionary[username2]?["Sum_Of_Weights"] ?? 0.0)
                        })

                        // Now userDataDictionary contains the accumulated values and Sum_Of_Weights for each username
                        print(self.userDataDictionary)

                        // Reload the table view with sorted usernames
                        self.tableView.reloadData()
                 
                }
            }
    }





   
} //end of class

extension RankingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedUsernames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath)

        let username = self.sortedUsernames[indexPath.row]
        let sumOfWeights = self.userDataDictionary[username]?["Sum_Of_Weights"] ?? 0.0

        // Configure your cell with username and sumOfWeights
          cell.textLabel?.text = "\(username) - Weighted Value: \(sumOfWeights)"
                 
       
   
        cell.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 30/255, alpha: 1.0)
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        return cell
    }
}
