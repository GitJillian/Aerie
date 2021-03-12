//
//  UserVC.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation

import FirebaseStorage
import FirebaseAuth
import UIKit

class UserVC: BaseVC{
    private var signoutController = SignOutViewController()
    private var profileController = ProfileViewController()
    private var SettingController = SettingViewController()
    @IBOutlet var backImage: UIImageView!
    var users: [User] = []
    @IBOutlet var upLoadBtn: UIButton!
    private var backButton: UIBarButtonItem!
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var settingBtn: UIButton!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var NameField: UILabel!
    
    private var contactAlert:UIAlertController!
    
   
    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        backImage?.loadGif(name: "circle-light-cropped2")
        
        
        
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        imageView.contentMode = .scaleAspectFit
        settingBtn.clipsToBounds = true
        profileBtn.clipsToBounds = true
        settingBtn.layer.cornerRadius = CGFloat(10)
        profileBtn.layer.cornerRadius = CGFloat(10)
        
        self.NameField?.text = UserDefaults.standard.value(forKey: "username") as? String
        
        self.addChildControllers()
        //let email = UserDefaults.standard.value(forKey: "email") as! String
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else{
                return
        }
       /* fireStorage.getUrlByPath(path: "image/"+email+"_avatar"){url in
            
            UserDefaults.standard.setValue(url.absoluteString, forKey: "url")
            print("url in viewDidLoad", UserDefaults.standard.value(forKey: "url") as! String)
            guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
                          let url = URL(string:urlString) else{
                                return
                    }*/
            let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
                        guard let data = data, error == nil else{
                            self.imageView.image = UIImage(named: "ava")
                            return
                        }
                        //adding the task to the main thread
                        DispatchQueue.main.async {
                            let image = UIImage(data:data)
                            self.imageView.image = image
                        }
                    })
                    task.resume()
        }
            
    
    @IBAction func showContact(){
        contactAlert = UIAlertController(title: "Please contact heyjill1129@gmail.com so as to report any technical issue.", message: nil, preferredStyle: .alert)
        contactAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(self.contactAlert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(){
        self.signoutController.showUpDialog()
    }
    
    
    
    //setting up all child controllers within side menu and add subviews accordingly
    private func addChildControllers(){
        
        //add childs to current object
        addChild(profileController)
        addChild(SettingController)
        addChild(signoutController)

        //add subviews
        view.addSubview(profileController.view)
        view.addSubview(SettingController.view)
        view.addSubview(signoutController.view!)
        
        //set boundaries
        profileController.view.frame = view.bounds
        SettingController.view.frame = view.bounds
        signoutController.view.frame = view.bounds
        
        //set movements
        profileController.didMove(toParent: self)
        SettingController.didMove(toParent: self)
        signoutController.didMove(toParent: self)
        
        //hide the side menu item views as default unless the user clicks on them
        profileController.view.isHidden = true
        SettingController.view.isHidden = true
        signoutController.view.isHidden = true
    }
    
    
    
        
    
    
    
    // bug in changing avatar!!!!
    func downloadAvatar(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let ref = storageRef.child("image/"+email+"_avatar")
        
        ref.downloadURL(completion: {url, error in
            guard let url = url, error == nil else{
                return
            }
            let urlString = url.absoluteString
            
            UserDefaults.standard.set(urlString, forKey: "url")
            print("url", UserDefaults.standard.value(forKey: "url") as! String)
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
                guard let data = data, error == nil else{
                    
                    return
                }
                //adding the task to the main thread
                
                
                    
                    let image = UIImage(data:data)
                    self.imageView.image = image
                
            })
            
        }
        )
        
    }
    func loadAvatar(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let ref = storageRef.child("image/"+email+"_avatar")
        ref.getData(maxSize: 15*1024*1024){ data, err in
            if let err = err{
                print(err.localizedDescription)
                return
            }
            else{
                
                let image = UIImage(data:data!)
                self.imageView.image = image
                self.viewDidLoad()
                    
            }
        }
    }
    
}
