import UIKit

class PairViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var dataArray: [Int] = [1, 2, 3, 4, 5, 6, 7, 8] // Total count is 8
    var pairs: [((Int, Int), (Int, Int))] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create UITableView programmatically
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)

        // Register the cell class
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PairCell")

        // Set delegate and data source
        tableView.dataSource = self
        tableView.delegate = self

        generatePairs()
    }

    func generatePairs() {
        guard dataArray.count % 4 == 0 else {
            fatalError("Array count must be divisible by 4 for pairing.")
        }

        let totalCount = dataArray.count
        let pairCount = totalCount / 4

        for _ in 0..<pairCount {
            var pair1 = (0, 0)
            var pair2 = (0, 0)

            // Find unique values for pair1
            pair1.0 = dataArray.remove(at: Int.random(in: 0..<dataArray.count))
            pair1.1 = dataArray.remove(at: Int.random(in: 0..<dataArray.count))

            // Find unique values for pair2
            pair2.0 = dataArray.remove(at: Int.random(in: 0..<dataArray.count))
            pair2.1 = dataArray.remove(at: Int.random(in: 0..<dataArray.count))

            pairs.append((pair1, pair2))
        }
    }



    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PairCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let pairSet = pairs[indexPath.row]
        let pair1 = pairSet.0
        let pair2 = pairSet.1

        cell.textLabel?.text = "\(pair1.0)-\(pair1.1) vs. \(pair2.0)-\(pair2.1)"

        return cell
    }
}




