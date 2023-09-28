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
import Foundation


class HomeScreenViewController: UIViewController {
    
    
    
 
    
    
    @IBOutlet weak var lbl_testcount: UILabel!
    
    @IBOutlet weak var btn_NewGame: UIButton!
    
    @IBOutlet weak var MainUNLabel: UILabel!
    
    @IBOutlet weak var lbl_DoublesHeader: UILabel!
    @IBOutlet weak var lbl_SinglesHeader: UILabel!
    
    
    @IBOutlet weak var NewDoublesRankLabel: UILabel!
    @IBOutlet weak var NewSinglesRankLabel: UILabel!
    
    
    @IBOutlet weak var DW_letter: UILabel!
    @IBOutlet weak var DL_Letter: UILabel!
    
    @IBOutlet weak var SW_Letter: UILabel!
    @IBOutlet weak var SL_Letter: UILabel!
    
    
    @IBOutlet weak var DoublesWinsLabel: UILabel!
    
    @IBOutlet weak var DoublesLossesLabel: UILabel!
    
    @IBOutlet weak var SinglesWinsLabel: UILabel!
    
    @IBOutlet weak var SinglesLossesLabel: UILabel!
    
    
    
    @IBOutlet weak var lbl_Playometer: UILabel!
    
    @IBOutlet weak var lbl_GamesPlayed: UILabel!
    
    @IBOutlet weak var lbl_PlayMoreGames: UILabel!
    
    
    
    
    
    @IBOutlet weak var backgroundGradView: UIView!
    
    var labelgaugecount: String = ""
    let CurrentDateMinus7 = Calendar.current.date(byAdding: .day, value:-7, to: Date())
  
    
    public var gaugemetercount = ""
    
    var loadingView: UIView?
    var loadingLabel: UILabel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call a function to show the loading view
                showLoadingView()
                
                
        
        //ADD GAUGE / PLAYOMETER

        func currentcountforgauge() {
            // Reference to Firestore collection

            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser!.email


            let query = db.collection("Agressv_Games").whereFilter(Filter.andFilter([
                Filter.whereField("Game_Date", isGreaterOrEqualTo: CurrentDateMinus7!),
                Filter.orFilter([
                    Filter.whereField("Game_Creator", isEqualTo: uid!),
                    Filter.whereField("Game_Opponent_One", isEqualTo: uid!),
                    Filter.whereField("Game_Opponent_Two", isEqualTo: uid!),
                    Filter.whereField("Game_Partner", isEqualTo: uid!)

                ])
            ]))



            query.getDocuments { (querySnapshot, error) in
                if error != nil {
                    return
                }
                else {

                    let count = querySnapshot?.documents.count ?? 0


                    self.labelgaugecount = String(count)
                    self.lbl_testcount.frame.origin = CGPoint(x:225, y:612)
                    self.lbl_testcount.textColor = UIColor.systemGray
                    self.lbl_testcount.font = UIFont.systemFont(ofSize: 12)
                    self.lbl_testcount.text = self.labelgaugecount

                    self.gaugemetercount = String(count)
                    let vc = UIHostingController(rootView: GaugeView(currentValue: self.gaugemetercount))

                        let swiftuiView_gauge = vc.view!
                        swiftuiView_gauge.translatesAutoresizingMaskIntoConstraints = true

                        swiftuiView_gauge.frame.size.width = 400



                        // Add the view controller to the destination view controller.
                    self.addChild(vc)
                    self.view.addSubview(swiftuiView_gauge)

                        self.view.bringSubviewToFront(swiftuiView_gauge)
                        swiftuiView_gauge.frame = CGRectMake( 15, 75, swiftuiView_gauge.frame.size.width, swiftuiView_gauge.frame.size.height ) // set new position exactly


                        // 4
                        // Notify the child view controller that the move is complete.
                        vc.didMove(toParent: self)
                }
            }

        }

        //update the gauge value
        print(currentcountforgauge())









            //GET DATA

            let db = Firestore.firestore()


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
                        let Int_Doubles_Rank = Double(Doubles_Rank_As_String)
                        self.NewDoublesRankLabel.text = String(format: "%.1f", Int_Doubles_Rank!)


                        //Singles Rank number to string conversion
                        let Singles_Rank = document!.data()!["Singles_Rank"]
                        let Singles_Rank_As_String = String(describing: Singles_Rank!)
                        let Int_Singles_Rank = Double(Singles_Rank_As_String)
                        self.NewSinglesRankLabel.text = String(format: "%.1f", Int_Singles_Rank!)

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

            //usernamelabel!.center = CGPoint(x: 200, y: 285)
            usernamelabel!.textAlignment = .center
            usernamelabel!.font = CustomFont
            usernamelabel!.adjustsFontSizeToFitWidth = true
            usernamelabel!.backgroundColor = UIColor.black
            usernamelabel!.layer.cornerRadius = 15
            usernamelabel!.clipsToBounds = true

            //Font aspects for Doubles Rank
            let DoublesRankFont = UIFont(name: "Impact", size: 30)
            let DoublesRankLabelC = NewDoublesRankLabel


            //DoublesRankLabel!.frame.origin = CGPoint(x: 65, y: 340)
            DoublesRankLabelC!.textAlignment = .center
            DoublesRankLabelC!.font = DoublesRankFont
            DoublesRankLabelC!.adjustsFontSizeToFitWidth = true
            DoublesRankLabelC!.backgroundColor = UIColor.lightGray
            DoublesRankLabelC!.layer.borderColor = UIColor.red.cgColor
            DoublesRankLabelC!.layer.borderWidth = 2.0
            DoublesRankLabelC!.layer.cornerRadius = 5
            DoublesRankLabelC!.clipsToBounds = true

            //Font aspects for Singles Rank
            let SinglesRankFont = UIFont(name: "Impact", size: 30)
            let SinglesRankLabel = NewSinglesRankLabel

            //SinglesRankLabel!.center = CGPoint(x: 240, y: 465)
            SinglesRankLabel!.textAlignment = .center
            SinglesRankLabel!.font = SinglesRankFont
            SinglesRankLabel!.adjustsFontSizeToFitWidth = true
            SinglesRankLabel!.backgroundColor = UIColor.lightGray
            SinglesRankLabel!.layer.borderColor = UIColor.red.cgColor
            SinglesRankLabel!.layer.borderWidth = 2.0
            SinglesRankLabel!.layer.cornerRadius = 5
            SinglesRankLabel!.clipsToBounds = true







            //POSITION ALL LABELS

            let DogLeft = UIImage(named: "dobermanpsdleft.png")
            let DogLeftView:UIImageView = UIImageView()
            DogLeftView.contentMode = UIView.ContentMode.scaleAspectFit
            DogLeftView.frame.size.width = 140
            DogLeftView.frame.size.height = 140
            //myImageView.center = self.view.center
            DogLeftView.center = CGPoint(x: 70, y: 200)
            DogLeftView.image = DogLeft
            view.addSubview(DogLeftView)

            let DogRight = UIImage(named: "dobermanpsd.png")
            let DogRightView:UIImageView = UIImageView()
            DogRightView.contentMode = UIView.ContentMode.scaleAspectFit
            DogRightView.frame.size.width = 140
            DogRightView.frame.size.height = 140
            //myImageView.center = self.view.center
            DogRightView.center = CGPoint(x: 360, y: 200)
            DogRightView.image = DogRight
            view.addSubview(DogRightView)

            let BlackCircle = UIImage(named: "blackcircle.png")
            let myImageView:UIImageView = UIImageView()
            myImageView.contentMode = UIView.ContentMode.scaleAspectFit
            myImageView.frame.size.width = 140
            myImageView.frame.size.height = 140
            //myImageView.center = self.view.center
            myImageView.center = CGPoint(x: 211, y: 160)
            myImageView.image = BlackCircle
            view.addSubview(myImageView)

            btn_NewGame.frame.origin = CGPoint(x:157, y:144)
            view.bringSubviewToFront(btn_NewGame)


            MainUNLabel.frame.origin = CGPoint(x: 30, y:240)
            MainUNLabel.frame.size.width = 370


            lbl_DoublesHeader.frame.origin = CGPoint(x: 65, y:320)
            lbl_SinglesHeader.frame.origin = CGPoint(x: 285, y:320)


            NewDoublesRankLabel.frame.origin = CGPoint(x:65, y:370)
            NewDoublesRankLabel.frame.size.width = 80
            NewDoublesRankLabel.frame.size.height = 80


            NewSinglesRankLabel.frame.origin = CGPoint(x:285, y:370)
            NewSinglesRankLabel.frame.size.width = 80
            NewSinglesRankLabel.frame.size.height = 80


            DW_letter.frame.origin = CGPoint(x:65, y:480)
            DL_Letter.frame.origin = CGPoint(x:65, y:520)
            SW_Letter.frame.origin = CGPoint(x:285, y:480)
            SL_Letter.frame.origin = CGPoint(x:285, y:520)


            DoublesWinsLabel.frame.origin = CGPoint(x:95, y:480)
            DoublesLossesLabel.frame.origin = CGPoint(x:95, y:520)
            SinglesWinsLabel.frame.origin = CGPoint(x:315, y:480)
            SinglesLossesLabel.frame.origin = CGPoint(x:315, y:520)


            lbl_Playometer.frame.origin = CGPoint(x:65, y:595)
            lbl_GamesPlayed.frame.origin = CGPoint(x:65, y:615)




            lbl_PlayMoreGames.frame.origin = CGPoint(x:120, y: 715)

            let AgressvLogo = UIImage(named: "AgressvLogoSmall.png")
            let AgressvBtmLogo:UIImageView = UIImageView()
            AgressvBtmLogo.contentMode = UIView.ContentMode.scaleAspectFit
            AgressvBtmLogo.frame.size.width = 350
            AgressvBtmLogo.frame.size.height = 350
            //myImageView.center = self.view.center
            AgressvBtmLogo.center = CGPoint(x: 217, y: 800)
            AgressvBtmLogo.image = AgressvLogo
            view.addSubview(AgressvBtmLogo)
            

        
        
        // Simulate loading for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Call a function to hide the loading view
            self.hideLoadingView()
        }
        
    
        } //end of loading bracket
        
        
    
    func showLoadingView() {
            // Create a UIView that covers the entire screen
            loadingView = UIView(frame: view.bounds)
            loadingView?.backgroundColor = .white
            
            // Create a UILabel with the desired text
            loadingLabel = UILabel()
            loadingLabel?.text = "Loading your stats..."
            loadingLabel?.textColor = .black
            loadingLabel?.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the label to the loading view
            if let loadingLabel = loadingLabel {
                loadingView?.addSubview(loadingLabel)
                loadingLabel.centerXAnchor.constraint(equalTo: loadingView!.centerXAnchor).isActive = true
                loadingLabel.centerYAnchor.constraint(equalTo: loadingView!.centerYAnchor).isActive = true
            }
            
            // Add the loading view to the main view controller
            if let loadingView = loadingView {
                view.addSubview(loadingView)
            }
        }
        
        func hideLoadingView() {
            // Remove the loading view and label from the main view controller
            loadingLabel?.removeFromSuperview()
            loadingView?.removeFromSuperview()
            
            // Set the references to nil to release memory
            loadingLabel = nil
            loadingView = nil
        }
       

        
    } //end of class
    
    
    
    
    
    
    

