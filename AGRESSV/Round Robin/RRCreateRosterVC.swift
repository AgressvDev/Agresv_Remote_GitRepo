//
//  RRCreateRosterVC.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 11/28/23.
//

import UIKit

class RRCreateRosterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Sample data for RR_players array
    var RR_Players_Roster = SharedDataRR.shared.RR_Players

    // Declare tableView as an optional property
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a table view
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.translatesAutoresizingMaskIntoConstraints = false

        // Create a label
        let label = UILabel()
        label.text = "Round Robin"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false

        // Create an "Add Players" button
        let addButton = UIButton()
        addButton.setTitle("Add Players", for: .normal)
        addButton.setTitleColor(.blue, for: .normal)
        addButton.addTarget(self, action: #selector(addPlayersTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        // Create a "Start Tournament" button
        let startButton = UIButton()
        startButton.setTitle("Start Tournament", for: .normal)
        startButton.setTitleColor(.blue, for: .normal)
        startButton.addTarget(self, action: #selector(startTournamentTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false

        // Add label, "Add Players" button, "Start Tournament" button, and table view to the view
        view.addSubview(label)
        view.addSubview(addButton)
        view.addSubview(startButton)
        view.addSubview(tableView!)

        // Set constraints for the label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        // Set constraints for the "Add Players" button
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])

        // Set constraints for the "Start Tournament" button
        NSLayoutConstraint.activate([
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])

        // Set constraints for the table view
        NSLayoutConstraint.activate([
            tableView!.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            tableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Register the cell for the table view
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RR_Players_Roster.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = RR_Players_Roster[indexPath.row]
        return cell
    }

    // Function to remove player from the array and update the table view
    func removePlayer(at indexPath: IndexPath) {
        RR_Players_Roster.remove(at: indexPath.row)
        SharedDataRR.shared.RR_Players.remove(at: indexPath.row)
        
        tableView?.deleteRows(at: [indexPath], with: .automatic)
    }

    // MARK: - UITableViewDelegate Method

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlayer = RR_Players_Roster[indexPath.row]

        // Create an alert controller
        let alertController = UIAlertController(title: "Remove Player", message: "Do you want to remove \(selectedPlayer)?", preferredStyle: .alert)

        // Add action to remove the player
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            self.removePlayer(at: indexPath)
            
        
        }

        // Add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    // Button Actions

    @objc func addPlayersTapped() {
        // Navigate to the RRChoosePlayersID view controller
        if let choosePlayersVC = storyboard?.instantiateViewController(withIdentifier: "RRChoosePlayersID") {
            navigationController?.pushViewController(choosePlayersVC, animated: true)
        }
    }

    @objc func startTournamentTapped() {
        // Navigate to the RoundRobinID view controller
        if let roundRobinVC = storyboard?.instantiateViewController(withIdentifier: "RoundRobinID") {
            navigationController?.pushViewController(roundRobinVC, animated: true)
        }
    }
}
