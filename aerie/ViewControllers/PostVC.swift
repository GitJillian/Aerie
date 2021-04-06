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
    @IBOutlet var composeBtn : UIButton!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDataToTable()
        self.tableView?.isScrollEnabled = false
        self.tableView?.alwaysBounceVertical = false
        self.scrollView?.delegate  = self
        self.tableView?.delegate   = self
        self.tableView?.dataSource = self
        
        self.hideKeyboardWhenTappedElseWhere()
        self.scrollView?.refreshControl = UIRefreshControl()
        self.scrollView?.refreshControl?.addTarget(self, action: #selector(updateTableAutomatic(_:)), for: .valueChanged)
        self.scrollView?.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh posts")
        
    }
    
    func loadDataToTable(){
        postOperation.getAllPosts(){listOfPost in
            //self.scrollView = self.view as? UIScrollView
            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width,height: CGFloat(Double(listOfPost.count) * 145 + 50) )
            self.cellHeight?.constant = CGFloat(Double(listOfPost.count) * 145)
            
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func updateTableAutomatic(_ sender: AnyObject){
        postOperation.getAllPosts(){listOfPost in
            //self.scrollView = self.view as? UIScrollView
            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width,height: CGFloat(Double(listOfPost.count) * 145 + 50) )
            self.cellHeight?.constant = CGFloat(Double(listOfPost.count) * 145)
            
            //getting a list of posts and load them to table view
            self.postArray = listOfPost
            self.scrollView.refreshControl?.endRefreshing()
            self.tableView?.reloadData()
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
        
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let composePostVC = sb.instantiateViewController(withIdentifier: Constants.Storyboard.sendpostViewController) as! SendPostViewController
        composePostVC.modalPresentationStyle = .overFullScreen
        self.present(composePostVC, animated: true, completion: nil)
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
            let location = document[Constants.userFields.locationStr] as! [String: Any]
            let locationStr = location["title"] as? String
            let gender      = document[Constants.userFields.gender] as! String
            
            if gender == Constants.genderStr.female{
                Styler.setFemaleBtn(cell.genderBtn!)
            }else{
                Styler.setMaleBtn(cell.genderBtn!)
            }
            cell.NameLabel?.text = name
            cell.locationLabel?.text = locationStr
            
            let fireStorage = FireStorage()
            let path = "image/"+postCell.uid+"_avatar"
            fireStorage.loadAvatarByPath(path: path){data in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let post = postArray[indexPath.row]
        let pid  = post.pid
        UserDefaults.standard.setValue(pid, forKey: "pidView")
        self.viewPost()
    }
    
    func viewPost(){
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let viewPostModel = sb.instantiateViewController(withIdentifier: "ViewPostVC") as! ViewPostController
        self.present(viewPostModel, animated: true, completion: nil)
        
    }
}
