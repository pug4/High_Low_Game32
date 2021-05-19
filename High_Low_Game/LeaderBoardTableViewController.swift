//
//  LeaderBoardTableViewController.swift
//  High_Low_Game
//
//  Created by JOJO on 5/15/21.
//  Copyright © 2021 Jayu. All rights reserved.
//
import Foundation
import UIKit
import Firebase


class LeaderBoardTableViewController: UITableViewController{
    struct user{
        var score = Int()
        var userName = String()
    }
    var userNameBool: Bool = false
    var scoresArrayTableView: Array = [Int]()
    var userNamesArrayTableView: Array = [String]()
    var winnerArray = [[String: Int]]()
    var winnerDict = [String: Int]()
    let database = Database.database().reference()
    var userName = String()
    var scores = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    database.child(UserDefaults.standard.string(forKey: "userID611")!).setValue(["userName": UserDefaults.standard.string(forKey: "name611")!])
        if UserDefaults.standard.string(forKey: "name611") == nil{
            collectUserName()
            userNameBool = true
        }else{
            uploadHighScoreAndUserName(highscore: UserDefaults.standard.integer(forKey: "highScore001111"), userName: UserDefaults.standard.string(forKey: "name611")!)
            sortWinners()
            self.tableView.reloadData()
        }
    }
    func uploadHighScoreAndUserName(highscore: Int, userName: String){
        let database = Database.database().reference()
        if (UserDefaults.standard.string(forKey: "name611") != nil) && UserDefaults.standard.string(forKey: "userID611") == nil{
            database.child(UserDefaults.standard.string(forKey: "userID611")!).setValue(["score": highscore])
            database.child(UserDefaults.standard.string(forKey: "userID611")!).setValue(["userName": userName])
        }
        database.child(UserDefaults.standard.string(forKey: "userID611")!).updateChildValues(["score": highscore])
    }
    func collectUserName(){
        
        var nameField: UITextField?
        let alertController = UIAlertController(title: "Add User Name", message: nil, preferredStyle: .alert)
            alertController.addTextField { (textField) in
                nameField = textField
                nameField?.text = ""
            }
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] (_) in
            nameField = alertController?.textFields![0]
            let def = UserDefaults.standard
            let name = def.string(forKey: "name611")
            def.setValue((nameField?.text!)!, forKey: "name611")
            def.synchronize()
            self.uploadHighScoreAndUserName(highscore: UserDefaults.standard.integer(forKey: "highScore001111"), userName: UserDefaults.standard.string(forKey: "name611")!)
            }))
        self.present(alertController, animated: true, completion: nil)
        self.tableView.reloadData()
        
        }
    func sortWinners(){
        var newArrayThing: [user] = []
        Database.database().reference().observe(.value, with: { (snapshot) in

            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    self.userName = snap.childSnapshot(forPath: "userName").value! as? String ?? ""
                    self.scores = snap.childSnapshot(forPath: "score").value! as? Int ?? 0
                    newArrayThing.append(user.init(score: self.scores, userName: self.userName))
                    newArrayThing.sort{ $0.score > $1.score }
                }
                    for winners in newArrayThing{
                        self.scoresArrayTableView.append(winners.score)
                        self.userNamesArrayTableView.append(winners.userName)
//                        self.scoresArrayTableView = self.scoresArrayTableView.filter { $0 != 0}
                       // if let key = winners.first(where: { $0.value == winners[self.userName] ?? 0 })?.key{
//self.userNamesArrayTableView.append(key)

                    }
                
                print(self.userNamesArrayTableView)
                print(self.scoresArrayTableView)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
