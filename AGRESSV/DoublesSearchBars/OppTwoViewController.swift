import UIKit
import Firebase
import FirebaseFirestore

class CircularImageCell4: UITableViewCell {

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




class OppTwoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    //carry over variable
    var Selected_Partner: String = SharedData.shared.PartnerSelection
    var Selected_OppOne: String = SharedData.shared.OppOneSelection
    
    // UI Components
        let PlayerSearch_label = UILabel()
        let searchBar_Players = UISearchBar()
        let tableView = UITableView()

        // Data source
        var dataSourceProfileImages: [String: String] = [:]
//        var dataSourceArrayPartner: [String: String] = [:]
//        var filteredDataSourceArray: [(username: String, imageData: String)] = []
//        var mergedArray: [(username: String, imageData: String)] = []
    
    var dataSourceArrayPartner: [String: (email: String, doublesRank: Double)] = [:] // Updated structure
    var filteredDataSourceArray: [(username: String, imageData: String, username_plus_skill: String)] = []
    var mergedArray: [(username: String, imageData: String, username_plus_skill: String)] = []
    
        var searching = false

        override func viewDidLoad() {
            super.viewDidLoad()
            
         

            // Register the custom cell class
                tableView.register(CircularImageCell4.self, forCellReuseIdentifier: "CircularImageCell4")
            
            // Clear the filtered data when the view loads
            filteredDataSourceArray.removeAll()
            searching = false

            searchBar_Players.delegate = self

            // Set up the search bar appearance
            setupSearchBarAppearance()

            // Set table view properties
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorColor = .lightGray

            // Fetch data
            fetchData()

            // Set up the background image
            setupBackgroundImage()

            // Set up UI components
            setupLabel()
            setupSearchBar()
            setupTableView()
            setupConstraints()
            
        } //end of load

        private func setupSearchBarAppearance() {
            searchBar_Players.backgroundImage = UIImage()
            searchBar_Players.barTintColor = UIColor.white
            searchBar_Players.layer.borderColor = UIColor.white.cgColor
            searchBar_Players.placeholder = "Search Username"
            
            

            // Change the placeholder color
            if let textField = searchBar_Players.value(forKey: "searchField") as? UITextField {
                textField.attributedPlaceholder = NSAttributedString(
                    string: "Search Username",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                )
            }
        }

        private func fetchData() {
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
                self.mergeDataAndReloadTable()
            }
        }

        private func setupBackgroundImage() {
            let backgroundImage = UIImageView()
            backgroundImage.image = UIImage(named: "BackgroundCoolGreen")
            backgroundImage.contentMode = .scaleAspectFill
            view.addSubview(backgroundImage)
            view.sendSubviewToBack(backgroundImage)

            // Disable autoresizing mask constraints
            backgroundImage.translatesAutoresizingMaskIntoConstraints = false

            // Set constraints to cover the full screen
            NSLayoutConstraint.activate([
                backgroundImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                backgroundImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }

    private func setupLabel() {
        // Calculate scaling factors based on screen width and height
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        let widthScalingFactor = screenWidth / 430.0 // Use a reference width
        let heightScalingFactor = screenHeight / 932.0 // Use a reference height
        let scalingFactor = min(widthScalingFactor, heightScalingFactor)
        
        PlayerSearch_label.text = "Select Opponent 2"
        PlayerSearch_label.textAlignment = .center
        PlayerSearch_label.translatesAutoresizingMaskIntoConstraints = false
        PlayerSearch_label.textColor = UIColor.white
        
        // Set the font to Impact with size 25 * scalingFactor
        PlayerSearch_label.font = UIFont(name: "Angel Wish", size: 35 * scalingFactor)
        
        view.addSubview(PlayerSearch_label)
    }

        private func setupSearchBar() {
            searchBar_Players.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(searchBar_Players)
        }

        private func setupTableView() {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tableView)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.dataSource = self
            tableView.delegate = self
        }

        private func setupConstraints() {
            NSLayoutConstraint.activate([
                // Label Constraints
                PlayerSearch_label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                PlayerSearch_label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                PlayerSearch_label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                // Search Bar Constraints
                searchBar_Players.topAnchor.constraint(equalTo: PlayerSearch_label.bottomAnchor, constant: 16),
                searchBar_Players.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                searchBar_Players.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                // Table View Constraints
                tableView.topAnchor.constraint(equalTo: searchBar_Players.bottomAnchor, constant: 16),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
   
    func GetEmail(usernameselection: String, completion: @escaping (String?) -> Void) {
        // Simulate a network request or database call to retrieve the email
        DispatchQueue.global().async {
            let db = Firestore.firestore()
            let uid = usernameselection
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
            
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let TheEmail = document.data()["Email"] as? String
                        //Change for each VC
                        SharedDataEmails.sharedemails.OppTwoEmail = TheEmail!
                        
                        completion(TheEmail)
                    }
                }
            }
            
        }
        
    }


   
    func fetchAgressvUsers(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        // Retrieve the current user's email
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No user is signed in.")
            completion()
            return
        }
        
        

        db.collection("Agressv_Users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching Agressv_Users: \(error.localizedDescription)")
                completion()
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                completion()
                return
            }

            print("Fetched \(documents.count) documents.") // Debugging

            for document in documents {
                print("Document ID: \(document.documentID), Data: \(document.data())") // Debugging

                if let username = document["Username"] as? String,
                   let email = document["Email"] as? String,
                   let doublesrank = document["Doubles_Rank"] as? Double {
                    
                    // Check if the email matches the current user's email
                    if email != currentUserEmail {
                        self.dataSourceArrayPartner[username] = (email, doublesrank)
                        print("Added user: \(username), Email: \(email), Doubles Rank: \(doublesrank)") // Debugging
                    } else {
                        print("Skipping user: \(username), Email: \(email) (matches current user)") // Debugging
                    }
                } else {
                    print("Missing data in document: \(document.documentID)") // Debugging
                }
            }

            // Remove records based on Selected_Partner and Selected_OppOne
                    if !self.Selected_Partner.isEmpty {
                        if self.dataSourceArrayPartner[self.Selected_Partner] != nil {
                            self.dataSourceArrayPartner.removeValue(forKey: self.Selected_Partner)
                        }
                    }

                    if !self.Selected_OppOne.isEmpty {
                        if self.dataSourceArrayPartner[self.Selected_OppOne] != nil {
                            self.dataSourceArrayPartner.removeValue(forKey: self.Selected_OppOne)
                        }
                    }
            // Check if dataSourceArrayPartner has been populated
            print("Total users fetched: \(self.dataSourceArrayPartner.count)") // Debugging
            completion()
        }
    }



    
    func fetchProfileImages(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Agressv_ProfileImages").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching Agressv_ProfileImages: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("No documents found.")
                completion()
                return
            }
            
            // Create a dispatch group to handle async image fetching
            let dispatchGroup = DispatchGroup()
            
            for document in querySnapshot.documents {
                let email = document.documentID
                dispatchGroup.enter() // Enter the group for each document
                
                if let userImageData = document["User_Img"] as? Data {
                    DispatchQueue.global(qos: .background).async { [weak self] in
                        guard let self = self else { return }
                        
                        // Base64 encode the image data
                        let encodedImage = userImageData.base64EncodedString()
                        
                        // Ensure UI updates are performed on the main thread
                        DispatchQueue.main.async {
                            self.dataSourceProfileImages[email] = encodedImage
                            dispatchGroup.leave() // Leave the group after updating the data source
                        }
                    }
                } else {
                    print("Error retrieving User_Img field from document.")
                    dispatchGroup.leave() // Ensure to leave even if there’s an error
                }
            }
            
            // Notify when all image processing is complete
            dispatchGroup.notify(queue: .main) {
                print("Fetched Profile Images: \(self.dataSourceProfileImages)")
                self.tableView.reloadData() // Reload UI on main thread
                completion()
            }
        }
    }
   


    // Merge data and reload table view
    func mergeDataAndReloadTable() {
        for (username, (email, doublesRank)) in dataSourceArrayPartner {
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

            // Construct the username_plus_skill
            let username_plus_skill = "\(username) - \(doublesRank)"

            // Add tuple to mergedArray
            if let imageData = imageData {
                let tuple = (username: username, imageData: imageData, username_plus_skill: username_plus_skill) // Include the new field
                mergedArray.append(tuple)
            }
        }

        // Sort the mergedArray by username, case-insensitive
        mergedArray.sort { $0.username.caseInsensitiveCompare($1.username) == .orderedAscending }
        print(self.mergedArray)
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

        // Assign the shared variables data
        SharedData.shared.OppTwoSelection = selectedUsername
        // Call GetEmail with a completion handler
            GetEmail(usernameselection: selectedUsername) { email in
                // Now we can safely navigate to the AddGameViewController after GetEmail is complete
                DispatchQueue.main.async {
                    if let OppOneVC = self.storyboard?.instantiateViewController(withIdentifier: "AddGameID") as? AddGameViewController {
                        // Pass the email to the new view controller if needed
                        OppOneVC.selectedCellValueOppTwoEmail = email! // Assuming AddGameViewController has an email property
                        // Push to the AddGameViewController
                        self.navigationController?.pushViewController(OppOneVC, animated: true)
                    }
                }
            }
        }

    
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CircularImageCell4", for: indexPath) as? CircularImageCell4 else {
            return UITableViewCell()
        }

        let data: (username: String, imageData: String, username_plus_skill: String)

        if searching {
            data = filteredDataSourceArray[indexPath.row]
        } else {
            data = mergedArray[indexPath.row]
        }

        // Set username label to the combined username and skill
        cell.usernameLabel.text = data.username_plus_skill // Use the new field
        cell.usernameLabel.textColor = UIColor.white // Set text color to white

        // Set circular image
        if let imageData = Data(base64Encoded: data.imageData), let image = UIImage(data: imageData) {
            cell.circularImageView.image = image

            // Make the circular image view
            cell.circularImageView.contentMode = .scaleAspectFill
            cell.circularImageView.layer.cornerRadius = cell.circularImageView.bounds.width / 2
            cell.circularImageView.layer.masksToBounds = true
        }

        // Set background color of the cells
        cell.backgroundColor = UIColor(red: 12/255, green: 89.3/255, blue: 78.9/255, alpha: 1.0)

        return cell
    }

    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Ensure the array is sorted before filtering
        mergedArray.sort { $0.username.caseInsensitiveCompare($1.username) == .orderedAscending }

        // Filter the merged array based on the search text (case-insensitive)
        filteredDataSourceArray = mergedArray.filter { (username, imageData, username_plus_skill) in
            return username.lowercased().contains(searchText.lowercased()) ||
                   username_plus_skill.lowercased().contains(searchText.lowercased())
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
                if let cell = tableView.cellForRow(at: indexPath) as? CircularImageCell4 {
                    cell.setCornerRadius()
                }
            }
        }
    }
    

    
  
        
       
}

