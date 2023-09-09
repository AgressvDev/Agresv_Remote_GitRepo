//
//  HomeScreenViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/19/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import SwiftUI


class HomeScreenViewController: UIViewController {
    
   
    
   
    
    @IBOutlet weak var MainUNLabel: UILabel!
    
    @IBOutlet weak var DoublesRankLabel: UILabel!
    @IBOutlet weak var SinglesRankLabel: UILabel!
    @IBOutlet weak var DoublesWinsLabel: UILabel!
    @IBOutlet weak var DoublesLossesLabel: UILabel!
    @IBOutlet weak var SinglesWinsLabel: UILabel!
    @IBOutlet weak var SinglesLossesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
        let db = Firestore.firestore()
              //insert the UIlabel reference
                
                func GetHomeScreenData() {
                    let uid = Auth.auth().currentUser!.email
                    let docRef = db.collection("Agressv_Users").document(uid!)
                    
                    docRef.getDocument { (document, error) in
                        if let err = error {
                            print("Error getting documents: \(err)")
                        } else {
                            print("\(document!.documentID) => \(String(describing: document!.data()))")
                            
                            //Doubles Rank number to string conversion
                            let Doubles_Rank = document!.data()!["Doubles_Rank"]
                            let Doubles_Rank_As_String = String(describing: Doubles_Rank!)
                            self.DoublesRankLabel.text = Doubles_Rank_As_String
                            
                            //Singles Rank number to string conversion
                            let Singles_Rank = document!.data()!["Singles_Rank"]
                            let Singles_Rank_As_String = String(describing: Singles_Rank!)
                            self.SinglesRankLabel.text = Singles_Rank_As_String
                            
                            //Doubles Wins number to string conversion
                            let DoublesWins = document!.data()!["Doubles_Games_Wins"]
                            let DoublesWins_As_String = String(describing: DoublesWins!)
                            self.DoublesWinsLabel.text = DoublesWins_As_String
                            
                            //Doubles Losses number to string conversion
                            let DoublesLosses = document!.data()!["Doubles_Games_Losses"]
                            let DoublesLosses_As_String = String(describing: DoublesLosses!)
                            self.DoublesLossesLabel.text = DoublesLosses_As_String
                            
                            //Singles Wins number to string conversion
                            let SinglesWins = document!.data()!["Singles_Games_Wins"]
                            let SinglesWins_As_String = String(describing: SinglesWins!)
                            self.SinglesWinsLabel.text = SinglesWins_As_String
                            
                            //Singles Losses number to string conversion
                            let SinglesLosses = document!.data()!["Singles_Games_Losses"]
                            let SinglesLosses_As_String = String(describing: SinglesLosses!)
                            self.SinglesLossesLabel.text = SinglesLosses_As_String
                            
                            
                            
                            self.MainUNLabel.text = document!.data()!["Username"] as? String
                            
                            
                           
                        }
                    }
                }
        
        
   //Calls the Username function
    print(GetHomeScreenData())
    
 
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
   
        //DoublesRankLabel!.center = CGPoint(x: 130, y: 465)
        DoublesRankLabel!.textAlignment = .center
        DoublesRankLabel!.font = DoublesRankFont
        DoublesRankLabel!.adjustsFontSizeToFitWidth = true
        DoublesRankLabel!.backgroundColor = UIColor.lightGray
        DoublesRankLabel!.layer.borderColor = UIColor.red.cgColor
        DoublesRankLabel!.layer.borderWidth = 2.0
        DoublesRankLabel!.layer.cornerRadius = 5
        DoublesRankLabel!.clipsToBounds = true
        
        //Font aspects for Singles Rank
    let SinglesRankFont = UIFont(name: "Impact", size: 30)
    let SinglesRankLabel = SinglesRankLabel
   
        //SinglesRankLabel!.center = CGPoint(x: 240, y: 465)
        SinglesRankLabel!.textAlignment = .center
        SinglesRankLabel!.font = SinglesRankFont
        SinglesRankLabel!.adjustsFontSizeToFitWidth = true
        SinglesRankLabel!.backgroundColor = UIColor.lightGray
        SinglesRankLabel!.layer.borderColor = UIColor.red.cgColor
        SinglesRankLabel!.layer.borderWidth = 2.0
        SinglesRankLabel!.layer.cornerRadius = 5
        SinglesRankLabel!.clipsToBounds = true
        
        
        
        
        //Guage stuff
      
        
        } //end of loading bracket
        
 
  
        


    
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
    
    
    

