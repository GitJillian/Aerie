//
//  ManageYourPost.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/15.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit

class ManageYourPost: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var goback: UIButton!
    
    var postArray = [Post]()
    var postOperation = PostOperation()
    var userOperation = UserOperation()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isScrollEnabled = true
        self.tableView.alwaysBounceVertical = false
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.hideKeyboardWhenTappedElseWhere()
        self.loadDataToTable()
    }
    
    @IBAction func goaway(){
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let initialBoard = sb.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as! HomeViewController
        self.view.window?.rootViewController = initialBoard
        self.view.window?.makeKeyAndVisible()
    }
    
    func loadDataToTable(){
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        
        postOperation.getPostsByUser(uid:uid){listOfPost in
            
            self.cellHeight?.constant = CGFloat(Double(listOfPost.count) * 115 )
            
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    //return height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    //return count of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //initializing each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageCell", for: indexPath) as! ManagePostViewCell
        let postCell = self.postArray[indexPath.row]
        let date     = postCell.timestamp
        let description = postCell.description
        let budget   = postCell.budget
        let location = postCell.expectedLocation
        cell.expectedLocation?.text = location["title"] as? String
        cell.budget?.text = "\(budget)"
        cell.timeLabel?.text = date.toString()
        cell.descriptionView?.text  = description
        return cell
        
    }
    
    // Override to support editing the table view. Here we just use swiping to delete a post
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = self.postArray[indexPath.row]
            postOperation.removePostByPid(pid: cell.pid){result in
                if result{
                self.postArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                }
            }
        }
    }
    
    
    //    handle events when selecting a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let post = postArray[indexPath.row]
        let pid  = post.pid
        
        //just a tester for showing description. TODO: CHANGE THAT!!!!
        let alert = UIAlertController()
        
        alert.view.addSubview(UIView())
        alert.pruneNegativeWidthConstraints()
        
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {[self] action in
            UserDefaults.standard.setValue(pid, forKey: "pidManage")
            
            let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let initialBoard = sb.instantiateViewController(withIdentifier: Constants.Storyboard.editPostController) as! EditPostViewController
            self.present(initialBoard, animated: true, completion: nil)
            //self.view.window?.rootViewController = initialBoard
            //self.view.window?.makeKeyAndVisible()
        }
        ))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {[self] action in
            postOperation.removePostByPid(pid: pid){result in
                if !result{
                    return
                }
                else{
                    self.dismiss(animated: true){
                        self.postArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.reloadData()
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

