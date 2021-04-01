//
//  ViewPostController.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/1.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit

class ViewPostController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    private var pid : String!
    private var userOperation = UserOperation()
    private var postOperation = PostOperation()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        
        self.pid = UserDefaults.standard.value(forKey: "pidView") as? String
        self.postOperation.getPostDocument(pid: self.pid){post in
            
            let uid = post[Constants.postFields.uidField] as! String
            let fireStorage = FireStorage()
            let path = "image/"+uid+"_avatar"
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
                if gender == Constants.genderStr.female{
                    Styler.setFemaleBtn(self.genderBtn)
                }else{
                    Styler.setMaleBtn(self.genderBtn)
                }
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
