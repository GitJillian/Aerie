//
//  UserVC.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import Photos
import FirebaseStorage
import FirebaseAuth
import UIKit

class UserVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private var profileController = ProfileViewController()
    private var ownPostController = OwnPostViewController()
    private var signoutController = SignOutViewController()
    var users: [User] = []
    private var email:String!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var NameField: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    private var alert:UIAlertController!
    var imagePickerController = UIImagePickerController()
    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(uploadProfileTapped(_:)))
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        imageView.contentMode = .scaleAspectFit
        imagePickerController.delegate = self
        
        let tabBar = self.tabBarController as! HomeViewController
        self.email = tabBar.email
        self.NameField?.text = tabBar.userName
        
        self.addChildControllers()
        
        //setting avatars by pulling firebase storage data
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string:urlString) else{
                    return
        }
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
    
    //setting up all child controllers within side menu and add subviews accordingly
    private func addChildControllers(){
        
        //add childs to current object
        addChild(profileController)
        addChild(ownPostController)
        addChild(signoutController)
        
        //add subviews
        view.addSubview(profileController.view)
        view.addSubview(ownPostController.view)
        view.addSubview(signoutController.view!)
        
        //set boundaries
        profileController.view.frame = view.bounds
        ownPostController.view.frame = view.bounds
        signoutController.view.frame = view.bounds
        
        //set movements
        profileController.didMove(toParent: self)
        ownPostController.didMove(toParent: self)
        signoutController.didMove(toParent: self)
        
        //hide the side menu item views as default unless the user clicks on them
        profileController.view.isHidden = true
        ownPostController.view.isHidden = true
        signoutController.view.isHidden = true
        
        //setting gesture recognizers
    }
    
    // bug in changing avatar!!!!
    func downloadAvatar(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child("image/"+self.email+"_avatar")
        
        ref.downloadURL(completion: {url, error in
            guard let url = url, error == nil else{
                self.imageView.image = UIImage(named: "ava")
                return
            }
            let urlString = url.absoluteString
            print("Downloadurl: \(urlString)")
            UserDefaults.standard.set(urlString, forKey: "url")
            self.viewDidLoad()
        })
        
    }
    
    
    
    @IBAction func signOut(){
        signoutController.showUpDialog()
    }
    
    // if the button is clicked, switch to profile setting.
    @IBAction func setProfile(){
        if let profileSetController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileViewController) as?  ProfileViewController{
            profileSetController.email = self.email
                self.view.window?.rootViewController = profileSetController
                self.view.window?.makeKeyAndVisible()
        }
    }
    
    // link this action to the 'upload' button
    @objc func uploadProfileTapped(_ sender: Any){
        checkPermission()
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    
    //this step checks whether it is allowed to access the user's photo library
    func checkPermission(){
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized{
            PHPhotoLibrary.requestAuthorization({ (status:
                PHAuthorizationStatus)-> Void in
                ()
                
            })
        }
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized{
            PHPhotoLibrary.requestAuthorization(requestAuthroizationHandler)
        }
    }
        
    
    //ask for authorization to access to user's photo library
    func requestAuthroizationHandler(status: PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized{
            alert = UIAlertController(title: "Please allow access to photo library in privacy settings.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .cancel, handler:nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadToCloud(fileurl: URL){
        let storage    = Storage.storage()
        let storageRef = storage.reference()
        
        let photoRef   = storageRef.child("image/"+self.email+"_avatar")
        let uploadTask = photoRef.putFile(from:fileurl,
                                          metadata:nil){(metadata, err) in
                                          guard err == nil else{
                                                    return
                                                                }
            
            self.downloadAvatar()
        }
        uploadTask.resume()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            uploadToCloud(fileurl: url)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
