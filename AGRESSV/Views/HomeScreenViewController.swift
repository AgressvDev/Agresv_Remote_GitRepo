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
    
    @IBOutlet weak var DoublesRankLabel: UILabel!
    
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
                            
                            let Doubles_Rank = document!.data()!["Doubles_Rank"]
                                
                            let Doubles_Rank_As_String = String(describing: Doubles_Rank!)
                            
                            self.DoublesRankLabel.text = Doubles_Rank_As_String
                            
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
        usernamelabel!.backgroundColor = UIColor.black
        usernamelabel!.layer.cornerRadius = 15
        usernamelabel!.clipsToBounds = true
        
        //Font aspects for Doubles Rank
    let DoublesRankFont = UIFont(name: "Impact", size: 30)
    let DoublesRankLabel = DoublesRankLabel
   
        DoublesRankLabel!.center = CGPoint(x: 80, y: 465)
        DoublesRankLabel!.textAlignment = .center
        DoublesRankLabel!.font = DoublesRankFont
        DoublesRankLabel!.adjustsFontSizeToFitWidth = true
        DoublesRankLabel!.backgroundColor = UIColor.gray
        DoublesRankLabel!.layer.cornerRadius = 5
        DoublesRankLabel!.clipsToBounds = true
        
            

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
    
    
    

