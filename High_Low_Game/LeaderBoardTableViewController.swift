//
//  LeaderBoardTableViewController.swift
//  High_Low_Game
//
//  Created by JOJO on 5/15/22.
//  Copyright © 2022 Jayu. All rights reserved.
//
import Foundation
import UIKit
import Firebase //Firebase is a 3rd party database


class LeaderBoardTableViewController: UITableViewController{
    struct user{
        var score = Int()
        var userName = String()
    }
    var userNameBool: Bool = false
    var scoresArrayTableView: Array = [Int]()
    var userNamesArrayTableView: Array = [String]()
    let database = Database.database().reference()
    var userName = String()
    var scores = Int()
    @objc func reload(sender:AnyObject)
    {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(self.reload), for: UIControl.Event.valueChanged)
        self.tableView.delegate = self
        if UserDefaults.standard.string(forKey: "name61111") == nil{
            collectUserName()
            userNameBool = true
        }else{
            database.child(UserDefaults.standard.string(forKey: "userID61111") ?? "").setValue(["userName": UserDefaults.standard.string(forKey: "name61111")!])
            uploadHighScoreAndUserName(highscore: UserDefaults.standard.integer(forKey: "highScore00111111"), userName: UserDefaults.standard.string(forKey: "name61111")!)
            sortWinners()
            self.tableView.reloadData()
        }
    }
    func uploadHighScoreAndUserName(highscore: Int, userName: String){
        let database = Database.database().reference()
        if (UserDefaults.standard.string(forKey: "name61111") != nil) && UserDefaults.standard.string(forKey: "userID61111") == nil{
            database.child(UserDefaults.standard.string(forKey: "userID61111")!).setValue(["score": highscore])
            database.child(UserDefaults.standard.string(forKey: "userID61111")!).setValue(["userName": userName])
        }
        database.child(UserDefaults.standard.string(forKey: "userID61111")!).updateChildValues(["score": highscore])
    }
    func collectUserName(){
        
        var userNameField: UITextField?
        let nameCollecter = UIAlertController(title: "Add User Name", message: nil, preferredStyle: .alert)
            nameCollecter.addTextField { (textField) in
                userNameField = textField
                userNameField?.text = ""
            }
        nameCollecter.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak nameCollecter] (_) in
            userNameField = nameCollecter?.textFields![0]
            let def = UserDefaults.standard
            def.string(forKey: "name61111")
            def.setValue((userNameField?.text!)!, forKey: "name61111")
            def.synchronize()
            self.uploadHighScoreAndUserName(highscore: UserDefaults.standard.integer(forKey: "highScore00111111"), userName: UserDefaults.standard.string(forKey: "name61111")!)
            }))
        self.present(nameCollecter, animated: true, completion: nil)
        self.tableView.reloadData()
        }
    func sortWinners(){
        var structArray: [user] = []
        Database.database().reference().observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    self.userName = snap.childSnapshot(forPath: "userName").value! as? String ?? ""
                    self.scores = snap.childSnapshot(forPath: "score").value! as? Int ?? 0
                    structArray.append(user.init(score: self.scores, userName: self.userName))
                    structArray.sort{ $0.score > $1.score }
                }
                    for winners in structArray{
                            self.scoresArrayTableView.append(winners.score)
                            self.userNamesArrayTableView.append(winners.userName)
                        }
            
                self.tableView.reloadData()
            }
    })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.scoresArrayTableView.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier1", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = String(self.scoresArrayTableView[indexPath.row])       //String(indexScores)
        cell.textLabel?.font = UIFont(name: "TrebuchetMS", size: 15)
        cell.detailTextLabel?.text = userNamesArrayTableView[indexPath.row]
        
        return cell
    }
    

}

//
