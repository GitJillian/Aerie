//
//  PostVC.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import Firebase
class PostVC: BaseVC, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet var tableView: UITableView!
    var postArray = [Post]()
    var postOperation = PostOperation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        postOperation.getAllPosts(){listOfPost in
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            DispatchQueue.main.async {
                self.tableView.delegate   = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
        checkUpdatedPosts()
        
    }
    
    
    
    @IBAction func ComposePost(_ sender: Any){
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let description = "Test if it works"
        
        postOperation.getAllPosts(){postList in
            let number = postList.count
            let pid = "post_\(number)"
            let newPost: Dictionary<String, Any> = [Constants.postFields.pidField:    pid,
                           Constants.postFields.uidField:    email,
                           Constants.postFields.description: description,
                           Constants.postFields.timeStamp:   Date()]
            self.postOperation.addSetPostDocument(pid: pid,
                                                  data: newPost)
            { result in
                
                let alert = UIAlertController()
                alert.title = "Fail to post!"
                alert.addAction(UIAlertAction(title: "fine", style: .default, handler: nil))
                if result{
                    let userOperation = UserOperation()
                    userOperation.addUserPost(userEmail: email, pid: pid){result in
                        if result{
                            alert.title = "Successfully post!"
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        }
                    }
                }
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postArray.count
    }
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let postCell = self.postArray[indexPath.row]
        
        cell.textLabel?.text = "\(postCell.pid)"
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .secondarySystemBackground
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.textLabel?.textColor = UIColor(named: "hintText")

        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let post = postArray[indexPath.row]
        
        
        //just a tester for showing description. TODO: CHANGE THAT!!!!
        let alert = UIAlertController(title: "View", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: post.description, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func loadDataToPostTable(){
        postOperation.getAllPosts(){listOfPost in
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func checkUpdatedPosts(){
        print("I am really running")
        postOperation.getPostUpdates{querySnapShots in
            querySnapShots.documentChanges.forEach{
                diff in
                
                let pid = diff.document.data()[Constants.postFields.pidField]
                if diff.type == .added{
                    let data = diff.document.data()
                    let pid  = data[Constants.postFields.pidField] as! String
                    let uid  = data[Constants.postFields.uidField] as! String
                    let description = data[Constants.postFields.description] as! String
                    let timeStamp   = data[Constants.postFields.timeStamp]   as! Timestamp
                    let timeStampDate = timeStamp.dateValue()
                    let post = Post(pid: pid, uid: uid, description: description, timestamp: timeStampDate)
                    self.postArray.append(post)
                    print("post has been added, \(diff.document.data())")
                    
                }
                else if diff.type == .removed{
                    
                    if let index: Int = self.postArray.firstIndex(where: { $0.pid == pid as! String }){
                        self.postArray.remove(at: index)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
