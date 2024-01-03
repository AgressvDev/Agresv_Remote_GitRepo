//
//  RoundRobinVC.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 11/28/23.
//

import UIKit

class RoundRobinVC: UIViewController {
    private var players = SharedDataRR.shared.RR_Players
    //var RR_Players_Roster = SharedDataRR.shared.RR_Players
    private var matches: [([String], [String])] = []
    private var currentMatchIndex = 0
    
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var nextMatchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextMatchButton.setTitle("Next Match", for: .normal)
        createRoundRobinSchedule()
        updateRoundsLabel()
        updateNextMatch()
    }
    
    



    func createRoundRobinSchedule() {
        let numberOfPlayers = players.count

        print("NUMBER OF PLAYERS::::::::")
        print(numberOfPlayers)

        // Ensure even number of players
        guard numberOfPlayers % 2 == 0 else {
            // Show a pop-up notification instead of triggering a fatal error
            showNotification(message: "The number of players must be even.")
            return
        }

        var shuffledPlayers = players

        print("SHUFFLED PLAYERS:::::::")
        print(shuffledPlayers)

        var usedPairings: [[String]] = []

       
            var roundMatches: [([String], [String])] = []

            // Iterate through all possible combinations for team1 and team2
      
                let playerIndex = 0
                let team1 = [shuffledPlayers[playerIndex], shuffledPlayers[playerIndex + 1]]
                let team2 = [shuffledPlayers[playerIndex + 2], shuffledPlayers[playerIndex + 3]]
                

                // Check if the current pairings are not present in the usedPairings array
                if !usedPairings.contains(where: { $0 == team1 }) ||
                   !usedPairings.contains(where: { $0 == team2 })
                {
              
                    roundMatches.append((team1, team2))
                    usedPairings.append(team1)
                    usedPairings.append(team2)
            

                    print("USED PAIRINGS::::::::")
                    print(usedPairings)
                }
            

            matches.append(contentsOf: roundMatches)

            // Rotate players for the next iteration
            shuffledPlayers.append(shuffledPlayers.removeFirst())
        
    }


    
    













    





    func showNotification(message: String) {
        let alertController = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

    
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }






    
    
    func updateRoundsLabel() {
        let totalMatches = matches.count
        roundsLabel.text = "Number of Rounds: \(totalMatches)"
    }
    
    func updateNextMatch() {
        if currentMatchIndex < matches.count {
            let (team1, team2) = matches[currentMatchIndex]
            matchLabel.text = "\(team1[0]) & \(team1[1]) vs. \(team2[0]) & \(team2[1])"
            currentMatchIndex += 1
        } else {
            matchLabel.text = "Round Robin matches completed."
            nextMatchButton.isEnabled = false
        }
    }
   

    @IBAction func nextMatchButtonTapped(_ sender: UIButton) {
        updateNextMatch()
    }
}
