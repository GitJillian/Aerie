//
//  ChatVc.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//


import Foundation
import MessageKit

class UserChatIconCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
class ChatVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    var userOperation = UserOperation()
    @IBOutlet weak var Header: UIView!
    private var userArray = [User]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
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
        self.scrollView?.refreshControl = UIRefreshControl()
        self.scrollView?.refreshControl?.addTarget(self, action: #selector(updateTableAutomatic(_:)), for: .valueChanged)
        self.scrollView?.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh posts")
    }
    func loadDataToTable(){
        userOperation.getAllUsers(){listOfUser in
            var users = listOfUser
            let uid = UserDefaults.standard.value(forKey: "uid") as! String
            //remove the current user itself from chat list
            let index = users.firstIndex{ $0.uid == uid}
            if let index = index{
                
                users.remove(at: index)
            }
            
            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width,height: CGFloat(Double(listOfUser.count) * 81) )
            self.cellHeight?.constant = CGFloat(Double(listOfUser.count) * 81)
            self.userArray = users
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func updateTableAutomatic(_ sender: AnyObject){
        userOperation.getAllUsers(){listOfUser in
            var users = listOfUser
            let uid = UserDefaults.standard.value(forKey: "uid") as! String
            //remove the current user itself from chat list
            let index = users.firstIndex{ $0.uid == uid}
            if let index = index{
                
                users.remove(at: index)
            }
            
            self.scrollView?.contentSize = CGSize(width: self.view.frame.size.width,height: CGFloat(Double(listOfUser.count) * 81) )
            self.cellHeight?.constant = CGFloat(Double(listOfUser.count) * 81)
            self.userArray = users
            self.tableView?.reloadData()
            
        }
    }
    
    //when the scroll view begins scrolling, the compose button should stay the same place
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
           let  off = scrollView.contentOffset.y
           // make sure the header position stays here
           self.Header.frame = CGRect(x:0, y: off + 0, width: Header.frame.size.width, height: Header.frame.size.height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
            //when a user is selected, should let them have a conversation
        self.performSegue(withIdentifier: "chat", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "chat"){
           
            let controller = (segue.destination as! UINavigationController).topViewController as! MessageViewController
            let row = (sender as! NSIndexPath).row
            let user = userArray[row]
            controller.otherUserObj = user
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cells.normalCell, for: indexPath) as! UserChatIconCell
        let userCell = self.userArray[indexPath.row]
        let uid = userCell.uid
        
        
        let name = "\(userCell.firstName) \(userCell.lastName)"
        let messageOperation = MessageOperation()
        messageOperation.getLatestChat(with: userCell.email){message in
            cell.nameLabel?.text = name
            cell.messageLabel?.text = message
            
            let fireStorage = FireStorage()
        
        let path = "image/"+String.safeEmail(emailAddress: uid)+"_avatar"
            fireStorage.loadAvatarByPath(path: path){data in
                if data.isEmpty{
                    cell.avatar?.image = UIImage(named:"ava")
                }else{
                    let image = UIImage(data: data)
                    cell.avatar?.image = image
                }
            }
        }
        return cell
    }
}
