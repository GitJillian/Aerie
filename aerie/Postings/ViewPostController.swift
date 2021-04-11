//
//  ViewPostController.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/1.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit

class ViewPostController: UIViewController {
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var expectedLocation: UILabel!
    var pid : String!
    private var userOperation = UserOperation()
    private var postOperation = PostOperation()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        self.descriptionField?.clipsToBounds = true
        self.descriptionField?.layer.cornerRadius = CGFloat(10)
        self.baseView?.clipsToBounds = true
        self.baseView?.layer.cornerRadius = CGFloat(10)
        
        self.postOperation.getPostDocument(pid: self.pid){post in
            
            let uid = post[Constants.postFields.uidField] as! String
            let expectedlocationDict = post[Constants.postFields.expectedLocation] as! [String:Any]
            self.expectedLocation?.text = expectedlocationDict["title"] as? String
            let budget = post[Constants.postFields.budget] as! Int
            self.budgetLabel?.text = "\(budget) CAD"
            let description = post[Constants.postFields.description] as? String
            self.descriptionField?.text = description
            let fireStorage = FireStorage()
            let path = "image/"+String.safeEmail(emailAddress: uid)+"_avatar"
            fireStorage.loadAvatarByPath(path: path){data in
                if data.isEmpty{
                    self.avatar?.image = UIImage(named:"ava")
                }else{
                    let image = UIImage(data: data)
                    self.avatar?.image = image
                }
            }
            self.userOperation.getUserDocument(documentName: uid){ user in
                self.name?.text = "\(user[Constants.userFields.firstname] ?? "") \(user[Constants.userFields.lastname] ?? ""), \(user[Constants.userFields.age] ?? 0)"
                let currentLocation = user[Constants.userFields.locationStr] as! [String:Any]
                self.location?.text = "\(currentLocation["title"] ?? " ")"
                let gender = user[Constants.userFields.gender] as! String
                self.genderLabel.text = gender
                let petFriendly = user[Constants.userFields.petFriendly] as! Bool
                if !petFriendly{
                    let petButton = UIButton()
                    petButton.setTitle("no pets", for: .normal)
                    petButton.titleLabel?.font = .systemFont(ofSize: 12)
                    petButton.backgroundColor = UIColor(red: 0.9294, green: 0.8471, blue: 0.6588, alpha: 1.0)
                    petButton.layer.cornerRadius = CGFloat(5)
                    petButton.frame = CGRect(x: 130, y: 87, width: 100, height: 30)
                    petButton.setTitleColor(UIColor.white, for: .normal)
                    self.headerView?.addSubview(petButton)
                }
                let smokeOrNot = user[Constants.userFields.smokeOrNot] as! Bool
                if !smokeOrNot{
                    let smokeButton = UIButton()
                    smokeButton.setTitle("non-smoker", for: .normal)
                    smokeButton.titleLabel?.font = .systemFont(ofSize: 12)
                    smokeButton.backgroundColor = UIColor(red: 0.5098, green: 0.7176, blue: 0.6275, alpha: 1.0)
                    smokeButton.layer.cornerRadius = CGFloat(5)
                    smokeButton.setTitleColor(UIColor.white, for: .normal)
                    if petFriendly{
                        smokeButton.frame = CGRect(x: 130, y: 87, width: 100, height: 30)
                    }
                    else{
                        smokeButton.frame = CGRect(x: 250, y: 87, width:100, height: 30)
                    }
                    self.headerView?.addSubview(smokeButton)
                    
                }
            
            }
        }
    }
}


