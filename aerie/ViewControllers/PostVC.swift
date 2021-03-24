//
//  PostVC.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import Firebase
class PostVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var Header: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    var postArray = [Post]()
    var postOperation = PostOperation()
    //@IBOutlet weak var tableViewCell: UITableViewCell!
    @IBOutlet var composeBtn : UIButton!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.composeBtn.translatesAutoresizingMaskIntoConstraints = false
        self.hideKeyboardWhenTappedElseWhere()
        self.loadDataToTable()
        self.tableView.isScrollEnabled = false
        self.tableView.alwaysBounceVertical = false
        self.scrollView.delegate  = self
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }
    
    func loadDataToTable(){
        postOperation.getAllPosts(){listOfPost in
            //self.scrollView = self.view as? UIScrollView
            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width,height: CGFloat(Double(listOfPost.count) * 146) )
            self.cellHeight?.constant = CGFloat(Double(listOfPost.count) * 146)
            
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    func updateTableAutomatic(){
        postOperation.getAllPosts(){listOfPost in
            //self.scrollView = self.view as? UIScrollView
            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width,height: CGFloat(Double(listOfPost.count) * 146) )
            self.cellHeight?.constant = CGFloat(Double(listOfPost.count) * 146)
            
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            
            self.tableView?.reloadData()
        }
    }
    
    @IBAction func updateTable(){
        postOperation.getAllPosts(){listOfPost in
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            
            self.tableView.reloadData()
            
        }
    }
    
    //when the scroll view begins scrolling, the compose button should stay the same place
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let transition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
           let  off = scrollView.contentOffset.y
           // make sure the compose button position stays here
           self.composeBtn.frame = CGRect(x: 280, y:   off + 600, width: composeBtn.frame.size.width, height: composeBtn.frame.size.height)
           self.Header.frame = CGRect(x:0, y: off + 0, width: Header.frame.size.width, height: Header.frame.size.height)
        if transition.y > 0{
            self.searchBar.frame = CGRect(x:0, y: off + 105
                                          , width: searchBar.frame.size.width, height: searchBar.frame.size.height)
        }
    }
    
    
    
    @IBAction func ComposePost(_ sender: Any){
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let description = ["Get interested in apartments in south keys", "Looking for a house", "Want to find a roommate"]
        
        postOperation.getAllPosts(){postList in
            let number = postList.count
            let pid = "post_\(number)"
            let newPost: Dictionary<String, Any> = [Constants.postFields.pidField:    pid,
                           Constants.postFields.uidField:    email,
                           Constants.postFields.description: description[Int.random(in: 0..<2)],
                           Constants.postFields.timeStamp:   Date(),
                           Constants.postFields.budget:      Int.random(in: 100..<1000)]
            self.postOperation.addSetPostDocument(pid: pid,
                                                  data: newPost)
            { result in
                let alert = UIAlertController()
                alert.view.addSubview(UIView())
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.pruneNegativeWidthConstraints()
                if result{
                    let userOperation = UserOperation()
                    
                    userOperation.addUserPost(userEmail: email, pid: pid){result in
                        if result{
                            alert.title = "Successfully post."
                        }else{
                            alert.title = "Fail to post."
                        }
                    }
                }
                else{
                    alert.title = "Fail to post."
                }
                self.present(alert, animated: false, completion: nil)
                self.updateTableAutomatic()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        let postCell = self.postArray[indexPath.row]
        let uid = postCell.uid
        let userOperation = UserOperation()
        cell.descriptionText?.text = postCell.description
        userOperation.getUserDocument(documentName: uid){document in
            
            let name = "\(document[Constants.userFields.firstname] ?? "first") \( document[Constants.userFields.lastname] ?? "last"), \(document[Constants.userFields.age] ?? "\(0)")"
            let location = "\(document[Constants.userFields.locationStr] ?? "Canada")"
            
            cell.NameLabel?.text = name
            cell.locationLabel?.text = location
            
            let fireStorage = FireStorage()
            fireStorage.loadAvatar(){data in
                if data.isEmpty{
                    cell.avatarImage?.image = UIImage(named:"ava")
                }else{
                    let image = UIImage(data: data)
                    cell.avatarImage?.image = image
                }
            }
        }
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
        let alert = UIAlertController()
        
        alert.view.addSubview(UIView())
        alert.pruneNegativeWidthConstraints()
        
        alert.addAction(UIAlertAction(title: post.description, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
