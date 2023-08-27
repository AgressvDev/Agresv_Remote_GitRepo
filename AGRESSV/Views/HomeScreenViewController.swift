//
//  HomeScreenViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/19/23.
//

import UIKit
import Firebase
import FirebaseFirestore


class HomeScreenViewController: UIViewController {
    
    
    @IBOutlet weak var MainUNLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        let db = Firestore.firestore()
              //insert the UIlabel reference
                
                func GetUsername() {
                    let uid = Auth.auth().currentUser!.email
                    let docRef = db.collection("Agressv_Users").document(uid!)
                    
                    docRef.getDocument { (document, error) in
                        if let err = error {
                            print("Error getting documents: \(err)")
                        } else {
                            print("\(document!.documentID) => \(String(describing: document!.data()))")
                            
                            self.MainUNLabel.text = document!.data()!["Username"] as? String
                        }
                    }
                }
        
   //Calls the Username function
    print(GetUsername())
    
        //Font aspects for Username
    let CustomFont = UIFont(name: "Impact", size: 30)
    let usernamelabel = MainUNLabel
        
        usernamelabel!.center = CGPoint(x: 200, y: 285)
        usernamelabel!.textAlignment = .center
        usernamelabel!.font = CustomFont
        usernamelabel!.adjustsFontSizeToFitWidth = true
                
            
//            let CurrentUserEmail = Auth.auth().currentUser!.email
//            let CustomFont = UIFont(name: "Impact", size: 15)
//
//
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//
//            label.font = CustomFont
//            label.text = CurrentUserEmail
//            self.view.addSubview(label)
        }
        
 
  
    
  
        
        
        
        //    @IBAction func UserLogOut(_ sender: UIButton) {
        //
        //        try! Auth.auth().signOut()
        //        if let storyboard = self.storyboard {
        //            let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! UINavigationController
        //                self.present(vc, animated: false, completion: nil)
        //            }
        //    }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    
    
    

