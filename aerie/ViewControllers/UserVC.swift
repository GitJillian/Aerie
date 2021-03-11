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
    private var signoutController = SignOutViewController()
    private var profileController = ProfileViewController()
    private var SettingController = SettingViewController()
    @IBOutlet var backImage: UIImageView!
    var users: [User] = []
    private var email:String!
    private var backButton: UIBarButtonItem!
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var settingBtn: UIButton!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var NameField: UILabel!
    private var permissionAlert:UIAlertController!
    private var contactAlert:UIAlertController!
    
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
        
        backImage?.loadGif(name: "circle-light-cropped2")
        
        
        let upLoadTap  = UITapGestureRecognizer(target: self, action:#selector(uploadProfileTapped(_:)))
        imageView.addGestureRecognizer(upLoadTap)
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        imageView.contentMode = .scaleAspectFit
        imagePickerController.delegate = self
        settingBtn.clipsToBounds = true
        profileBtn.clipsToBounds = true
        settingBtn.layer.cornerRadius = CGFloat(10)
        profileBtn.layer.cornerRadius = CGFloat(10)
        
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
    
    @IBAction func showContact(){
        contactAlert = UIAlertController(title: "Please contact heyjill1129@gmail.com so as to report any technical issue.", message: nil, preferredStyle: .alert)
        contactAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(self.contactAlert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(){
        self.signoutController.showUpDialog()
    }
    // link this action to the 'upload' button
    @objc func uploadProfileTapped(_ sender: Any){
        checkPermission()
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
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
            permissionAlert = UIAlertController(title: "Please allow access to photo library in privacy settings.", message: nil, preferredStyle: .alert)
            permissionAlert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            permissionAlert.addAction(UIAlertAction(title: "Cancel",
                                          style: .cancel, handler:nil))
            present(permissionAlert, animated: true, completion: nil)
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
