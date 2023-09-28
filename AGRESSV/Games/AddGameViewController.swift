//
//  AddGameViewController.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/18/23.
//

import UIKit
import UIKit
import Firebase
import FirebaseFirestore


class AddGameViewController: UIViewController {
    
    
   
    
    @IBOutlet weak var lbl_WL_Prompt: UILabel!
    
    @IBOutlet weak var lbl_CurrentUser: UILabel!
    
    @IBOutlet weak var lbl_Partner: UILabel!
    
    @IBOutlet weak var lbl_OppOne: UILabel!
    
    @IBOutlet weak var lbl_OppTwo: UILabel!
    
    @IBOutlet weak var lbl_doublesgame: UILabel!
    
    @IBOutlet weak var lbl_VS: UILabel!
    
    //For calculating players' ranks
    var CurrentUserDoublesRank: String!
    var PartnerDoublesRank: String!
    var OppOneDoublesRank: String!
    var OppTwoDoublesRank: String!
    
    //Displaying game players
    var currentuser: String = ""
    var selectedCellValue: String = SharedData.shared.PartnerSelection //Partner
    var selectedCellValueOppOne: String =  SharedData.shared.OppOneSelection//Opp One
    var selectedCellValueOppTwo: String = SharedData.shared.OppTwoSelection
    
    
   //For posting to Agressv_Games table to enable rolling 7 day count of games played
    var selectedCellValueEmail: String = ""
    var selectedCellValueOppOneEmail: String = ""
    var selectedCellValueOppTwoEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        func getcurrentuser() {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email
            let docRef = db.collection("Agressv_Users").document(uid!)
            
            docRef.getDocument { (document, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    print("\(document!.documentID) => \(String(describing: document!.data()))")
                    
                    let CurrentUser = document!.data()!["Username"]
                    let Current_User_As_String = String(describing: CurrentUser!)
                    self.currentuser = Current_User_As_String
                    self.lbl_CurrentUser.text = self.currentuser
                 
                }
            }
        }
        
        print(getcurrentuser())
        
        func GetDoublesRank() {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email
            let docRef = db.collection("Agressv_Users").document(uid!)
            
            docRef.getDocument { (document, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    print("\(document!.documentID) => \(String(describing: document!.data()))")
                    
                    let Doubles_Rank = document!.data()!["Doubles_Rank"]
                    let Doubles_Rank_As_String = String(describing: Doubles_Rank!)
                    self.CurrentUserDoublesRank = Doubles_Rank_As_String
                    
                 
                }
            }
        }
        
        print(GetDoublesRank())
        
        
        func GetPartnerRank() {
            let db = Firestore.firestore()
            let uid = selectedCellValue
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerDoublesRank = document.data()["Doubles_Rank"] as? String
                        if let PartnerDoublesRank = PartnerDoublesRank {
                            self.PartnerDoublesRank = PartnerDoublesRank
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        
        func GetOppOneRank() {
            let db = Firestore.firestore()
            let uid = selectedCellValueOppOne
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerDoublesRank = document.data()["Doubles_Rank"] as? String
                        if let PartnerDoublesRank = PartnerDoublesRank {
                            self.OppOneDoublesRank = PartnerDoublesRank
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        
        func GetOppTwoRank() {
            let db = Firestore.firestore()
            let uid = selectedCellValueOppTwo
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerDoublesRank = document.data()["Doubles_Rank"] as? String
                        if let PartnerDoublesRank = PartnerDoublesRank {
                            self.OppTwoDoublesRank = PartnerDoublesRank
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        
        func GetPartnerEmail() {
            let db = Firestore.firestore()
            let uid = selectedCellValue
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerEmail = document.data()["Email"] as? String
                        if let PartnerEmail = PartnerEmail {
                            self.selectedCellValueEmail = PartnerEmail
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        
        func GetOppOneEmail() {
            let db = Firestore.firestore()
            let uid = selectedCellValueOppOne
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerEmail = document.data()["Email"] as? String
                        if let PartnerEmail = PartnerEmail {
                            self.selectedCellValueOppOneEmail = PartnerEmail
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        
        func GetOppTwoEmail() {
            let db = Firestore.firestore()
            let uid = selectedCellValueOppTwo
            let query = db.collection("Agressv_Users").whereField("Username", isEqualTo: uid)
        
            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error")
                } else {
                    for document in querySnapshot!.documents {
                        // Access the value of field2 from the document
                        let PartnerEmail = document.data()["Email"] as? String
                        if let PartnerEmail = PartnerEmail {
                            self.selectedCellValueOppTwoEmail = PartnerEmail
                        } else {
                            return
                        }
                        
                        
                        
                        
                    }
                }
            }
        }
        
        print(GetPartnerRank())
        print(GetOppOneRank())
        print(GetOppTwoRank())
        print(GetPartnerEmail())
        print(GetOppOneEmail())
        print(GetOppTwoEmail())
        
        
        
        self.lbl_Partner.text = selectedCellValue
        self.lbl_OppOne.text = selectedCellValueOppOne
        self.lbl_OppTwo.text = selectedCellValueOppTwo
        
        lbl_doublesgame.frame.origin = CGPoint(x:70, y:110)
        
        lbl_CurrentUser.frame.origin = CGPoint(x:140, y:210)
        lbl_Partner.frame.origin = CGPoint(x:140, y:250)
        lbl_OppOne.frame.origin = CGPoint(x:140, y:360)
        lbl_OppTwo.frame.origin = CGPoint(x:140, y:400)
        
        
        lbl_VS.frame.origin = CGPoint(x:175, y:300)
        lbl_WL_Prompt.frame.origin = CGPoint(x:70, y:500)
        
        
    } //end of load
    
    
    
    var WL_Selection = "W"
    
    var Today = Date()
 
    
    
  
   
    
    @IBOutlet weak var seg_WLOutlet: UISegmentedControl!
    
    
    
    @IBAction func seg_WL(_ sender: UISegmentedControl) {

       
        if seg_WLOutlet.selectedSegmentIndex == 0
        {

            self.WL_Selection = "W"
            
            }
            else if seg_WLOutlet.selectedSegmentIndex == 1
                        
            {
            
            self.WL_Selection = "L"
            
            }
        }
    
    
    
    
    @IBAction func btn_LogGame(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.email
        let Partner_ref = db.collection("Agressv_Users").document(selectedCellValueEmail)
        let OppOne_ref = db.collection("Agressv_Users").document(selectedCellValueOppOneEmail)
        let OppTwo_ref = db.collection("Agressv_Users").document(selectedCellValueOppTwoEmail)
        let Game_ref = db.collection("Agressv_Games").document()
        let User_ref = db.collection("Agressv_Users").document(uid!)
        
        
        
        if WL_Selection == "W" {
            
            //increment winning side
            User_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])
            
            User_ref.updateData([
                "Doubles_Rank": FieldValue.increment(0.1)])
            
            Partner_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])
            
            Partner_ref.updateData([
                "Doubles_Rank": FieldValue.increment(0.1)])
            
            //decrement losing side
            OppOne_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])
            
            OppTwo_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])
            
            if OppOneDoublesRank == "8.5" {
                //do not decrement
            }
            else
            {
                OppOne_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
            
            if OppTwoDoublesRank == "8.5" {
                //do not decrement
            }
            else
            {
                OppTwo_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
            
            
            
        }
        
        else if WL_Selection == "L"{
            
            
            //increment winning side
            OppOne_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])
            
            OppOne_ref.updateData([
                "Doubles_Rank": FieldValue.increment(0.1)])
            
            OppTwo_ref.updateData([
                "Doubles_Games_Wins": FieldValue.increment(Int64(1))])
            
            OppTwo_ref.updateData([
                "Doubles_Rank": FieldValue.increment(0.1)])
            
            //decrement losing side
            User_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])
            
            Partner_ref.updateData([
                "Doubles_Games_Losses": FieldValue.increment(Int64(1))])
            
            //if Doubles Rank is 8.5 do not decrement
            if CurrentUserDoublesRank == "8.5" {
                //do not decrement
            }
            else
            {
                User_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
            if PartnerDoublesRank == "8.5" {
                //do not decrement
            }
            else
            {
                Partner_ref.updateData([
                    "Doubles_Rank": FieldValue.increment(-0.1)])
            }
        }
        
        
        
        
        Game_ref.setData(["Game_Result" : WL_Selection, "Game_Date" : Today, "Game_Creator": uid!, "Game_Type": "Doubles", "Game_Partner": selectedCellValueEmail, "Game_Opponent_One": selectedCellValueOppOneEmail, "Game_Opponent_Two": selectedCellValueOppTwoEmail])
        
        User_ref.updateData([
            "Doubles_Games_Played": FieldValue.increment(Int64(1))])
        
        //Partner_ref
        //          Partner_ref.updateData([
        //            "Doubles_Games_Played": FieldValue.increment(Int64(1))])
        
        let dialogMessage = UIAlertController(title: "Success!", message: "Your game has been logged.", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            self.performSegue(withIdentifier: "LogGameGoHome", sender: self)
        })
        
        
        
        
        //let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            
            // Perform the segue to the target view controller
           
            
        }
        
    
        
        
    
    
    
    
    
    
    
    
    }//end of class

