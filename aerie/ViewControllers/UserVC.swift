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
        
        self.NameField?.text = UserDefaults.standard.value(forKey: "username") as? String
        
        self.addChildControllers()
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let fireStorage = FireStorage()
        fireStorage.getUrlByPath(path:"image/" + email + "_avatar"){ url in
            
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
    
    // bug in changing avatar!!!!
    func downloadAvatar(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let ref = storageRef.child("image/"+email+"_avatar")
        
        ref.downloadURL(completion: {url, error in
            guard let url = url, error == nil else{
                self.imageView.image = UIImage(named: "ava")
                return
            }
            let urlString = url.absoluteString
            
            UserDefaults.standard.set(urlString, forKey: "url")
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let firestorage = FireStorage()
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let path  = "image/" + email + "_avatar"
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            
            firestorage.uploadToCloud(fileurl: url, refPath: path)
            self.downloadAvatar()
        }
        
       imagePickerController.dismiss(animated: true, completion: nil)
       
       /* firestorage.getUrlByPath(path: path) {urlPath in
            let urlString = urlPath.absoluteString
            UserDefaults.standard.set(urlString, forKey: "url")
            self.viewDidLoad()
        }*/
        
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
