import UIKit
import Firebase
import FirebaseFirestore

var dataSourceArrayPartner: [String: String] = [:]



var dataSourceProfileImages: [String: String] = [:]
var filteredDataSourceArray: [(username: String, imageData: String)] = []

var searching = false

class CircularImageCell: UITableViewCell {

    let circularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    func setCornerRadius() {
        circularImageView.layer.cornerRadius = circularImageView.bounds.width / 2
        circularImageView.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Ensure the circular image view is a perfect circle
        circularImageView.layer.cornerRadius = circularImageView.bounds.width / 2
    }

    private func commonInit() {
        // Add circularImageView to the contentView
        contentView.addSubview(circularImageView)
        contentView.addSubview(usernameLabel)

        // Set up constraints for circularImageView
        NSLayoutConstraint.activate([
            circularImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circularImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            circularImageView.widthAnchor.constraint(equalToConstant: 60.0),
            circularImageView.heightAnchor.constraint(equalTo: circularImageView.widthAnchor)
        ])

        // Set up constraints for usernameLabel
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: circularImageView.trailingAnchor, constant: 16.0),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        ])
    }

    func configure(with imageData: String) {
        if let data = Data(base64Encoded: imageData), let image = UIImage(data: data) {
            circularImageView.image = image
        } else {
            circularImageView.image = nil  // Clear the image if loading fails
        }
    }
}





class NewPlayerSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar_Players: UISearchBar!
    
    var mergedArray: [(username: String, imageData: String)] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear the filtered data when cancel button is clicked
        filteredDataSourceArray.removeAll()

        // Update the searching flag
        searching = false
        
        searchBar_Players.delegate = self
        
        
        searchBar_Players.backgroundImage = UIImage()
        searchBar_Players.barTintColor = UIColor.white
        searchBar_Players.layer.borderColor = UIColor.clear.cgColor
       
        // Set the default placeholder text
        searchBar_Players.placeholder = "Search Username"
        
        
        tableView.dataSource = self
        tableView.delegate = self

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        fetchProfileImages {
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchAgressvUsers {
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            // Both fetches are complete, you can use the data
            self.mergeDataAndReloadTable()
        }
        
        
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width, e.g., iPhone 6/6s/7/8 width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height, e.g., iPhone 6/6s/7/8 height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
        let IconsPercentage: CGFloat = 2.10
        
        // Create buttons with actions and images
               let ScoresButton = createButton(withImageName: "ScoresWhite")
               ScoresButton.addTarget(self, action: #selector(ScoresButtonTapped), for: .touchUpInside)

               let WinPercentagesButton = createButton(withImageName: "WinPercentagesWhite")
               WinPercentagesButton.addTarget(self, action: #selector(WinPercentagesButtonTapped), for: .touchUpInside)

               let RankingsButton = createButton(withImageName: "RankingsWhite")
        RankingsButton.addTarget(self, action: #selector(RankingsButtonTapped), for: .touchUpInside)

             

               // Add buttons to the view
               view.addSubview(ScoresButton)
               view.addSubview(WinPercentagesButton)
               view.addSubview(RankingsButton)
            

        // Define layout guides for the leading and trailing edges
                let leadingGuide = UILayoutGuide()
                let trailingGuide = UILayoutGuide()
                view.addLayoutGuide(leadingGuide)
                view.addLayoutGuide(trailingGuide)
        
       


               // Set corner radius for all buttons and add a square border
               let cornerRadius: CGFloat = 15
               ScoresButton.layer.cornerRadius = cornerRadius
               //settingsButton.layer.borderWidth = 1
               //settingsButton.layer.borderColor = UIColor.white.cgColor

        WinPercentagesButton.layer.cornerRadius = cornerRadius
               //historyButton.layer.borderWidth = 1
               //historyButton.layer.borderColor = UIColor.white.cgColor

        RankingsButton.layer.cornerRadius = cornerRadius
        //PlayersButton.layer.borderWidth = 1
        //PlayersButton.layer.borderColor = UIColor.white.cgColor

          

//               // Set the background color to teal blue
//               ScoresButton.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)//UIColor(red: 0, green: 142/255, blue: 184/255, alpha: 1) // Teal blue
//        WinPercentagesButton.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)//UIColor(red: 0, green: 142/255, blue: 184/255, alpha: 1) // Teal blue
//        RankingsButton.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)//UIColor(red: 0, green: 142/255, blue: 184/255, alpha: 1) // Teal blue
          
        ScoresButton.backgroundColor = UIColor.systemRed
        WinPercentagesButton.backgroundColor = UIColor.systemRed
        RankingsButton.backgroundColor = UIColor.systemRed
        
        
        // Adjust the image size within the buttons
               ScoresButton.imageView?.contentMode = .scaleAspectFit
        WinPercentagesButton.imageView?.contentMode = .scaleAspectFit
        RankingsButton.imageView?.contentMode = .scaleAspectFit
           
        
        
       
        
    func createButton(withImageName imageName: String) -> UIButton {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let image = UIImage(named: imageName) // Load the image from the asset catalog
            button.setImage(image, for: .normal)
            return button
        }
            
        
        let buttons = [ScoresButton, WinPercentagesButton, RankingsButton]

        // Create a container stack view to hold the buttons
        let buttonsStackView = UIStackView(arrangedSubviews: buttons)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.spacing = 5 * IconsPercentage // Adjust spacing as needed
        view.addSubview(buttonsStackView)

        // Add constraints for the stack view
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10 * scalingFactor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40 * scalingFactor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40 * scalingFactor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 65 * scalingFactor),
        ])

        // Set equal width and height constraints for each button
        buttons.forEach { button in
            button.widthAnchor.constraint(equalToConstant: 65 * scalingFactor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 65 * scalingFactor).isActive = true
        }
        
        
        // Create labels for each button
        let lbl_Scores = createLabel(withText: "Scores")
        let lbl_WinPercentages = createLabel(withText: "Win Percentages")
        let lbl_Rankings = createLabel(withText: "Rankings")

        // Add buttons and labels to the view
     
        view.addSubview(lbl_Scores)
        view.addSubview(lbl_WinPercentages)
        view.addSubview(lbl_Rankings)
        
        
        func createLabel(withText text: String) -> UILabel {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = text
            label.textColor = UIColor.systemRed
            label.textAlignment = .center
            let baseFontSize: CGFloat = 12.0 // Set your base font size
            let adjustedFontSize = baseFontSize * scalingFactor
            label.font = UIFont.systemFont(ofSize: adjustedFontSize)
            return label
        }
        
        // Add constraints for the stack view
        NSLayoutConstraint.activate([
            lbl_Scores.topAnchor.constraint(equalTo: ScoresButton.bottomAnchor, constant: 5 * scalingFactor),
            lbl_Scores.leadingAnchor.constraint(equalTo: ScoresButton.leadingAnchor, constant: 10 * scalingFactor)
            
        ])
        
        // Add constraints for the stack view
        NSLayoutConstraint.activate([
            lbl_WinPercentages.topAnchor.constraint(equalTo: WinPercentagesButton.bottomAnchor, constant: 5 * scalingFactor),
            lbl_WinPercentages.leadingAnchor.constraint(equalTo: WinPercentagesButton.leadingAnchor, constant: -10 * scalingFactor)
            
        ])
        
        // Add constraints for the stack view
        NSLayoutConstraint.activate([
            lbl_Rankings.topAnchor.constraint(equalTo: RankingsButton.bottomAnchor, constant: 5 * scalingFactor),
            lbl_Rankings.leadingAnchor.constraint(equalTo: RankingsButton.leadingAnchor, constant: 10 * scalingFactor)
            
        ])
        
    } // end of load

    // Fetch data from "Agressv_Users" collection
    func fetchAgressvUsers(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        db.collection("Agressv_Users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching Agressv_Users: \(error.localizedDescription)")
                completion()
                return
            }

            for document in querySnapshot!.documents {
                if let username = document["Username"] as? String,
                   let email = document["Email"] as? String {
                    dataSourceArrayPartner[username] = email
                }
            }

            completion()
        }
    }
   

    

   



    func fetchProfileImages(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        db.collection("Agressv_ProfileImages").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching Agressv_ProfileImages: \(error.localizedDescription)")
                completion()
                return
            }

            for document in querySnapshot!.documents {
                let email = document.documentID
                if let userImageData = document["User_Img"] as? Data {
                    dataSourceProfileImages[email] = userImageData.base64EncodedString()
                } else {
                    print("Error retrieving User_Img field from document.")
                }
            }

            print("Fetched Profile Images: \(dataSourceProfileImages)")

            // After fetching images, reload the table view to apply the corner radius
            self.tableView.reloadData()
            completion()
        }
    }
    
    
   

    // Merge data and reload table view
    func mergeDataAndReloadTable() {
        for (username, email) in dataSourceArrayPartner {
            var imageData: String?

            // Check if there is User_Img data for the current email
            if let profileImageData = dataSourceProfileImages[email] {
                imageData = profileImageData
            } else {
                print("No User_Img data found for \(email). Using default image.")

                // Use default image for "testuser@gmail.com"
                if let defaultImageData = dataSourceProfileImages["testuser@gmail.com"] {
                    imageData = defaultImageData
                }
            }

            // Add tuple to mergedArray
            if let imageData = imageData {
                let tuple = (username: username, imageData: imageData)
                mergedArray.append(tuple)
            }
        }

        // Sort the mergedArray by username, case-insensitive
        mergedArray.sort { $0.username.caseInsensitiveCompare($1.username) == .orderedAscending }


        // Set corner radius for circular image view after reload
           DispatchQueue.main.async {
               self.setCornerRadiusForVisibleCells()
           }

        // Set a fixed row height for each table view cell
        tableView.rowHeight = 80.0  // Adjust the height to your preference

        // Reload the table view to reflect the updated data
        tableView.reloadData()
    }
 
   


    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if searching {
                return filteredDataSourceArray.count
            } else {
                return mergedArray.count
            }
        }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUsername: String

        if searching {
            selectedUsername = filteredDataSourceArray[indexPath.row].username
        } else {
            selectedUsername = mergedArray[indexPath.row].username
        }

        // Assign the selected username to SharedPlayerData.shared.PlayerSelectedUsername_NoRank
        SharedPlayerData.shared.PlayerSelectedUsername_NoRank = selectedUsername

        // Create an instance of PlayerProfileViewController
        if let playerProfileVC = storyboard?.instantiateViewController(withIdentifier: "PlayerProfileID") as? PlayerProfileViewController {
            // Push to the PlayerProfileViewController
            navigationController?.pushViewController(playerProfileVC, animated: true)
        }
    }

    
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CircularImageCell", for: indexPath) as? CircularImageCell else {
            return UITableViewCell()
        }




        let data: (username: String, imageData: String)

        if searching {
            data = filteredDataSourceArray[indexPath.row]
        } else {
            data = mergedArray[indexPath.row]
        }




        // Set username label
        cell.usernameLabel.text = data.username
        cell.usernameLabel.textColor = UIColor.white // Set text color to white

        // Set circular image
        if let imageData = Data(base64Encoded: data.imageData), let image = UIImage(data: imageData) {
            cell.circularImageView.image = image

             //Make the circular image view
            cell.circularImageView.contentMode = .scaleAspectFill
            cell.circularImageView.layer.cornerRadius = cell.circularImageView.bounds.width / 2
            cell.circularImageView.layer.masksToBounds = true


        }

        // Set background color of the cells
        cell.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 30/255, alpha: 1.0)

        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Ensure the array is sorted before filtering
        mergedArray.sort { $0.username.caseInsensitiveCompare($1.username) == .orderedAscending }

        // Filter the merged array based on the search text (case-insensitive)
        filteredDataSourceArray = mergedArray.filter { (username, _) in
            return username.lowercased().contains(searchText.lowercased())
        }

        // Update the searching flag
           searching = !searchText.isEmpty


        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // Clear the filtered data when cancel button is clicked
            filteredDataSourceArray.removeAll()

            // Update the searching flag
            searching = false

            // Reload the table view with the original data
            tableView.reloadData()
        }


    // Set corner radius for circular image view in visible cells
    func setCornerRadiusForVisibleCells() {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in visibleIndexPaths {
                if let cell = tableView.cellForRow(at: indexPath) as? CircularImageCell {
                    cell.setCornerRadius()
                }
            }
        }
    }
    

    
    @objc func WinPercentagesButtonTapped() {
        // Create an instance of opp two VC
        let WinPercentagesVC = storyboard?.instantiateViewController(withIdentifier: "WinPercentagesVCID") as! WinPercentagesVC
        
        // Push to the SecondViewController
        navigationController?.pushViewController(WinPercentagesVC, animated: true)
        }
    
    
    @objc func ScoresButtonTapped() {
        // Create an instance of opp two VC
        let ScoresVC = storyboard?.instantiateViewController(withIdentifier: "ScoresVCID") as! ScoresVC
        
        // Push to the SecondViewController
        navigationController?.pushViewController(ScoresVC, animated: true)
        }
    
    
    @objc func RankingsButtonTapped() {
        // Create an instance of opp two VC
//        let PlayersVC = storyboard?.instantiateViewController(withIdentifier: "PlayersID") as! PlayersSearchViewController
//
//        // Push to the SecondViewController
//        navigationController?.pushViewController(PlayersVC, animated: true)
        
        
        //for testing
        
        let RankingsVC = storyboard?.instantiateViewController(withIdentifier: "RankingsVCID") as! RankingsVC
        
        // Push to the SecondViewController
        navigationController?.pushViewController(RankingsVC, animated: true)
        
        
        }
    
}
