import UIKit
import FirebaseFirestore
import Firebase

class ScoresVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segController: UISegmentedControl!

    var scoresData: [(username: String, rank: Double)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self

        // Call the function to fetch and update the data based on the initial segment value
        fetchScores()
    } // end of load

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        // Call the function to fetch and update the data based on the selected segment value
        fetchScores()
    }

    func fetchScores() {
        let db = Firestore.firestore()

        // Use the segmented control value to determine which scores to fetch
        let isDoublesSegmentSelected = segController.selectedSegmentIndex == 0

        db.collection("Agressv_Users")
            .order(by: isDoublesSegmentSelected ? "Doubles_Rank" : "Singles_Rank", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.scoresData.removeAll()

                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let username = data["Username"] as? String,
                           let rank = isDoublesSegmentSelected ? (data["Doubles_Rank"] as? Double) : (data["Singles_Rank"] as? Double) {
                            // Round the rank to the first decimal place
                            let roundedRank = (rank * 10).rounded() / 10

                            // Append the data to the scoresData array
                            self.scoresData.append((username: username, rank: roundedRank))
                        }
                    }

                    // Reload the table view data on the main thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
        }
    }

    // MARK: - Table View Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoresData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)

        // Configure the cell with the data from scoresData
        let score = scoresData[indexPath.row]
        cell.textLabel?.text = "\(score.username)  \(score.rank)"
        cell.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 30/255, alpha: 1.0)
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        return cell
    }
}
