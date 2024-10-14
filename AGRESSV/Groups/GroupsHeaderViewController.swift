import UIKit
import Firebase
import FirebaseFirestore



class CircularImageCellGroups: UITableViewCell {
    let circularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let GroupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        contentView.addSubview(circularImageView)
        contentView.addSubview(GroupNameLabel)
        
      

        NSLayoutConstraint.activate([
            circularImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circularImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            circularImageView.widthAnchor.constraint(equalToConstant: 60.0),
            circularImageView.heightAnchor.constraint(equalTo: circularImageView.widthAnchor),
            
            GroupNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            GroupNameLabel.leadingAnchor.constraint(equalTo: circularImageView.trailingAnchor, constant: 16.0),
            GroupNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        ])
        
    }
    

    func configure(with imageUrl: String, groupName: String) {
        // Assuming imageUrl is a URL string to download the image
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.circularImageView.image = image
                        self.circularImageView.layer.cornerRadius = self.circularImageView.bounds.width / 2
                        self.circularImageView.layer.masksToBounds = true
                    }
                }
            }.resume()
        }
        GroupNameLabel.text = groupName
      
    }
}



class GroupsHeaderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let tableView = UITableView()
    var groups: [(name: String, imageUrl: String)] = [] // Array to hold group names and image URLs
    var currentUserEmail = Auth.auth().currentUser?.email
    
    
    // Data source
    var dataSourceProfileImages: [String: String] = [:]
    
    // Declare lbl_Groups as a property
        let lbl_Groups: UILabel = {
            let label = UILabel()
            label.text = "Groups"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 25) // Set the desired font size
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        // Add the label to the view
                view.addSubview(lbl_Groups)
        
        // Set constraints
        NSLayoutConstraint.activate([
            lbl_Groups.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16), // Adjust the constant as needed
            lbl_Groups.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16) // Adjust the constant as needed
        ])
        
        tableView.register(CircularImageCellGroups.self, forCellReuseIdentifier: "CircularImageCell6Groups")
        tableView.dataSource = self
        tableView.delegate = self

        // Set up the background image
        setupBackgroundImage()
        
        // Set up the table view
        setupTableView()
        fetchGroups()
        
    
        
       
    } //end of load
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGroups()
        //tableView.reloadData() // Reload data to refresh cell appearance
    }

   

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: lbl_Groups.bottomAnchor, constant: 25), // Constrain to lbl_Groups
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        tableView.rowHeight = 80.0
        
        
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CircularImageCell6Groups", for: indexPath) as? CircularImageCellGroups else {
            return UITableViewCell()
        }

        let group = groups[indexPath.row]
        cell.configure(with: group.imageUrl, groupName: group.name)

        // Set the text color for the GroupNameLabel
        cell.GroupNameLabel.textColor = UIColor.white
        
        // Configure the circular image view properties
        cell.circularImageView.layer.cornerRadius = cell.circularImageView.bounds.width / 2
        cell.circularImageView.layer.masksToBounds = true
       
        // Set the cell background color
        cell.backgroundColor = UIColor(red: 12/255, green: 89/255, blue: 78/255, alpha: 1.0)

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupDetailVC = GroupDetailViewController()
        // Pass data to GroupDetailViewController if needed
        groupDetailVC.groupName = groups[indexPath.row].name
        navigationController?.pushViewController(groupDetailVC, animated: true)
    }
    
    // Enable swipe actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Get the group to delete
            let group = self.groups[indexPath.row]

            // Delete from Firestore
            self.deleteGroup(groupName: group.name) {
                // Remove the group from the local array
                self.groups.remove(at: indexPath.row)
                // Reload the table view
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
        }

        // Customize the delete action (optional)
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    private func deleteGroup(groupName: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        // Query for the group to delete
        db.collection("Agressv_Groups")
            .whereField("Group_Name", isEqualTo: groupName)
            .whereField("Group_Creator_Email", isEqualTo: self.currentUserEmail!)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    completion() // Call completion even if there's an error
                    return
                }
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    completion() // No documents to delete
                    return
                }

                // Delete each document found
                for document in documents {
                    db.collection("Agressv_Groups").document(document.documentID).delete { error in
                        if let error = error {
                            print("Error deleting document: \(error)")
                        } else {
                            print("Document successfully deleted.")
                        }
                    }
                }
                completion()
            }
    }

    // Fetch groups from Firestore
    func fetchGroups() {
        let db = Firestore.firestore()
        
        db.collection("Agressv_Groups")
            .whereField("Group_Members", arrayContains: self.currentUserEmail!) // Adding the new condition
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else if let snapshot = snapshot {
                    self.groups = snapshot.documents.compactMap { doc in
                        let name = doc.get("Group_Name") as? String ?? ""
                        
                        // Assuming you want to store image URLs or placeholders
                        if let imageData = doc.get("Group_Img") as? Data {
                            // Convert Data to a base64 string
                            let imageUrl = "Data:image/png;base64,\(imageData.base64EncodedString())"
                            return (name, imageUrl)
                        } else if let imageString = doc.get("Group_Img") as? String, !imageString.isEmpty {
                            // If it's already a URL and not empty
                            return (name, imageString)
                        }
                        
                        // Set default image if Group_Img is nil or empty
                        let defaultImageUrl = UIImage(named: "DefaultPlayerImage")?.pngData()?.base64EncodedString()
                        let placeholderUrl = "Data:image/png;base64,\(defaultImageUrl ?? "")"
                        return (name, placeholderUrl)
                    }
                    self.tableView.reloadData()
                }
            }
    }



    
    
   
    


    
} //end of class
