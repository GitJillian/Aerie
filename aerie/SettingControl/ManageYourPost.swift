//
//  ManageYourPost.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/15.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit

class ManageYourPost: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var finishBtn: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var postArray = [Post]()
    var postOperation = PostOperation()
    var userOperation = UserOperation()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isScrollEnabled = false
        self.tableView.alwaysBounceVertical = false
        self.scrollView.delegate  = self
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.hideKeyboardWhenTappedElseWhere()
        self.loadDataToTable()
    }
    
    func loadDataToTable(){
        let email = UserDefaults.standard.value(forKey: "email") as! String
        
        postOperation.getPostsByUser(uid:email){listOfPost in
            //self.scrollView = self.view as? UIScrollView
            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width,height: CGFloat(Double(listOfPost.count) * 116) )
            self.cellHeight?.constant = CGFloat(Double(listOfPost.count) * 116)
            
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    //return height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {action in
            
        }
        ))
        alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: {[self] action in
            postOperation.removePostByPid(pid: pid){result in
                if !result{
                    return
                }
                else{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
}
