import UIKit
import Firebase
import FirebaseFirestore

var dataSourceArrayPartner: [String: String] = [:]
var dataSourceProfileImages: [String: String] = [:]



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





class NewPlayerSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var mergedArray: [(username: String, imageData: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        // Sort the mergedArray by username
            mergedArray.sort { $0.username < $1.username }

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
           return mergedArray.count
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CircularImageCell", for: indexPath) as? CircularImageCell else {
            return UITableViewCell()
        }

        let data = mergedArray[indexPath.row]

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
