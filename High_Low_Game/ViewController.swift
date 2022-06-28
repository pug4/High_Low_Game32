//
//  ViewController.swift
//  High_Low_Game
//
//  Created by JOJO on 5/15/22.
//  Copyright © 2022 Jayu. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    var scoreLabelValue = 100
    var highScoreSaved: Int{ UserDefaults.standard.integer(forKey: "highScore00111111")
    }
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var winOrLose: UILabel!
    @IBAction func highButton(_ sender: Any) {
        buttonFunction(buttonType: true)
    }
    @IBAction func lowButton(_ sender: Any) {
        
        buttonFunction(buttonType: false)
    }
    func buttonFunction(buttonType: Bool){
        let bool = Bool.random()
        if bool == buttonType{
            keepGoing()
            }
        else{
            lose(loseBool: bool)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.highScore.text = String(self.highScoreSaved)
    }
    func uploadHighScore(highscore: Int){
        let database = Database.database().reference()
        if UserDefaults.standard.string(forKey: "userID61111") == nil{
            let userID = database.childByAutoId()
            UserDefaults.standard.setValue(userID.key!, forKey: "userID61111")
            database.child(UserDefaults.standard.string(forKey: "userID61111")!).setValue(["score": highscore])
        }
        database.child(UserDefaults.standard.string(forKey: "userID61111")!).updateChildValues(["score": highscore])
    }
   func keepGoing(){
        winOrLose.text = String(scoreLabelValue)
        scoreLabelValue += 100
        winOrLose.backgroundColor = .green
        if self.scoreLabelValue > self.highScoreSaved{
            let defualts: UserDefaults = UserDefaults.standard
            defualts.setValue(self.scoreLabelValue-100, forKey: "highScore00111111")
            defualts.synchronize()
            self.highScore.text = String(self.highScoreSaved)
            uploadHighScore(highscore: scoreLabelValue-100)
    }
    
    }
    func lose(loseBool: Bool){
        var text = ""
        winOrLose.text = "The High_Low Game: Is the variable High or Low?"
        scoreLabelValue = 100
        winOrLose.backgroundColor = .red
        popupView.center = view.center
        popupView.alpha = 1
        popupView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        self.view.addSubview(popupView)
        if loseBool{
            text = "High"
        }
        else{
            text = "Low"
        }
        
        loseLabel.text = "You lose! The correct answer was \(text)!"
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
          self.popupView.transform = .identity
        })
    }
    @IBOutlet weak var loseLabel: UILabel!
    @IBAction func dismissButtonOnScorePopUp(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
          self.popupView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        }) { (success) in
          self.popupView.removeFromSuperview()
            self.highScore.text = String(self.highScoreSaved)
        }
    }
}

