import UIKit
import Firebase
import FirebaseFirestore



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

    
    
    
    // UI Components
        let PlayerSearch_label = UILabel()
        let searchBar_Players = UISearchBar()
        let tableView = UITableView()

        // Data source
        var dataSourceProfileImages: [String: String] = [:]
        //var dataSourceArrayPartner: [String: String] = [:]
    var dataSourceArrayPartner: [String: (email: String, doublesRank: Double)] = [:] // Updated structure

        //var filteredDataSourceArray: [(username: String, imageData: String)] = []
    var filteredDataSourceArray: [(username: String, imageData: String, username_plus_skill: String)] = []

        //var mergedArray: [(username: String, imageData: String)] = []
    var mergedArray: [(username: String, imageData: String, username_plus_skill: String)] = []

        var searching = false
    
    

        override func viewDidLoad() {
            super.viewDidLoad()
            
           
            // Register the custom cell class
                tableView.register(CircularImageCell.self, forCellReuseIdentifier: "CircularImageCell")
            
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
            setupLabels()
            setupButtons()
            setupSearchBar()
            setupTableView()
            setupConstraints()
        }

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

    private let createGroupButton = UIButton()
    private let myGroups = UIButton()
    
    private let lbl_CreateGroup: UILabel = {
            let label = UILabel()
            label.text = "Create Group"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let lbl_MyGroups: UILabel = {
            let label = UILabel()
            label.text = "My Groups"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private func setupLabels()
    {
        
        // Add labels to the view
        view.addSubview(lbl_CreateGroup)
        view.addSubview(lbl_MyGroups)
        
    }
    
    private func setupButtons() {
        
        // Set the button images
        createGroupButton.setImage(UIImage(named: "Create_Group2"), for: .normal)
        myGroups.setImage(UIImage(named: "myGroups2"), for: .normal)
        
        // Enable Auto Layout
        createGroupButton.translatesAutoresizingMaskIntoConstraints = false
        createGroupButton.addTarget(self, action: #selector(createGroupTapped), for: .touchUpInside)
        
        myGroups.translatesAutoresizingMaskIntoConstraints = false
        myGroups.addTarget(self, action: #selector(myGroupsTapped), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(createGroupButton)
        view.addSubview(myGroups)
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
            
            // Calculate scaling factors based on screen width and height
            let screenWidth = view.bounds.size.width
            let screenHeight = view.bounds.size.height
            let widthScalingFactor = screenWidth / 430.0 // Use a reference width
            let heightScalingFactor = screenHeight / 932.0 // Use a reference height
            let scalingFactor = min(widthScalingFactor, heightScalingFactor)
            
            NSLayoutConstraint.activate([
                //button constraints
                createGroupButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1 * scalingFactor),
                createGroupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90 * scalingFactor),
                createGroupButton.widthAnchor.constraint(equalToConstant: 60 * scalingFactor),
                createGroupButton.heightAnchor.constraint(equalToConstant: 60 * scalingFactor),

                myGroups.topAnchor.constraint(equalTo: createGroupButton.topAnchor),
                myGroups.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90 * scalingFactor),
                myGroups.widthAnchor.constraint(equalToConstant: 60 * scalingFactor),
                myGroups.heightAnchor.constraint(equalToConstant: 60 * scalingFactor),
                
                lbl_CreateGroup.topAnchor.constraint(equalTo: createGroupButton.bottomAnchor, constant: 1 * scalingFactor),
                lbl_CreateGroup.leadingAnchor.constraint(equalTo: createGroupButton.leadingAnchor, constant: -10 * scalingFactor),
                lbl_MyGroups.topAnchor.constraint(equalTo: lbl_CreateGroup.topAnchor),
                lbl_MyGroups.leadingAnchor.constraint(equalTo: myGroups.leadingAnchor, constant: -10 * scalingFactor),
                
                // Center the buttons vertically
                createGroupButton.centerYAnchor.constraint(equalTo: myGroups.centerYAnchor),
                

                // Search Bar Constraints
                searchBar_Players.topAnchor.constraint(equalTo: lbl_CreateGroup.bottomAnchor, constant: 20),
                searchBar_Players.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                searchBar_Players.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                // Table View Constraints
                tableView.topAnchor.constraint(equalTo: searchBar_Players.bottomAnchor, constant: 16),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
   

    func fetchAgressvUsers(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

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
                    self.dataSourceArrayPartner[username] = (email, doublesrank)
                    print("Added user: \(username), Email: \(email), Doubles Rank: \(doublesrank)") // Debugging
                } else {
                    print("Missing data in document: \(document.documentID)") // Debugging
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


    @objc private func createGroupTapped() {
        // Create the alert controller
        let alert = UIAlertController(title: "Create Group Name", message: nil, preferredStyle: .alert)
        
        // Add a text field for the group name
        alert.addTextField { textField in
            textField.placeholder = "Enter group name"
        }
        
        // Add the "Create Group" action
        let createAction = UIAlertAction(title: "Create Group", style: .default) { _ in
            if let groupName = alert.textFields?.first?.text, !groupName.isEmpty {
                // Create a reference to the Firestore database
                let db = Firestore.firestore()
                // Assume CurrentUser_Email is defined outside this function
                guard let currentUserEmail = Auth.auth().currentUser?.email else {
                    print("Current user email not found.")
                    return
                }
                
                // Check if the group already exists
                let query = db.collection("Agressv_Groups")
                    .whereField("Group_Name", isEqualTo: groupName)
                    .whereField("Group_Creator_Email", isEqualTo: currentUserEmail)
                
                query.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error checking for existing group: \(error)")
                        return
                    }
                    
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        // Group already exists
                        let alert = UIAlertController(title: "Group Exists", message: "A group with this name already exists for your account.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        if let topController = UIApplication.shared.connectedScenes
                            .filter({ $0 is UIWindowScene })
                            .map({ $0 as! UIWindowScene })
                            .flatMap({ $0.windows })
                            .first(where: { $0.isKeyWindow })?
                            .rootViewController {
                            topController.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        // Group does not exist, proceed to create it
                        let groupData: [String: Any] = [
                            "Group_Name": groupName,
                            "Group_Creator_Email": currentUserEmail,
                            "Group_Members": [currentUserEmail] // Initial member is the creator
                        ]
                        
                        // Add the group data to Firestore
                        db.collection("Agressv_Groups").addDocument(data: groupData) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                            } else {
                                print("Group successfully created!")
                                
                                // Navigate to the next view controller after successfully creating the group
                                let yourViewController = GroupsHeaderViewController()
                                self.navigationController?.pushViewController(yourViewController, animated: true)
                            }
                        }
                    }
                }
            } else {
                // Optionally, handle the case where the text field is empty
                print("Group name cannot be empty")
            }
        }
        
        // Add the action to the alert
        alert.addAction(createAction)
        
        // Add a cancel action (optional)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // Present the alert using the current view controller
        if let topController = UIApplication.shared.connectedScenes
            .filter({ $0 is UIWindowScene })
            .map({ $0 as! UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }

    



    
    
    
    @objc private func myGroupsTapped() {
        // Action to perform when the button is tapped
        print("My Groups button tapped")
        
        // Navigate to the next view controller after successfully creating the group
        let yourViewController = GroupsHeaderViewController()
        self.navigationController?.pushViewController(yourViewController, animated: true)
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
    

    
  
        
       
}
