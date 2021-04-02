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
import Photos


class UserVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    private var signoutController = SignOutViewController()
    private var profileController = ProfileViewController()
    
    @IBOutlet var backImage: UIImageView!
    
    private var permissionAlert: UIAlertController!
    private var backButton: UIBarButtonItem!
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var settingBtn: UIButton!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var NameField: UILabel!
    
    private var contactAlert:UIAlertController!
    private var fireStorage   = FireStorage()
    private var userOperation = UserOperation()
    private var imagePickerController   = UIImagePickerController()
    
    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Styler.setBackgroundWithColor(self.view,  UIColor(named:"background")!)
        let upLoadTap  = UITapGestureRecognizer(target: self, action:#selector(uploadProfileTapped(_:)))
        imageView?.addGestureRecognizer(upLoadTap)
        
        backImage?.loadGif(name: "circle-light-cropped2")
        
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        imageView.contentMode = .scaleAspectFill
        settingBtn.clipsToBounds = true
        profileBtn.clipsToBounds = true
        settingBtn.layer.cornerRadius = CGFloat(10)
        profileBtn.layer.cornerRadius = CGFloat(10)
        settingBtn.layer.shadowColor  = UIColor.darkGray.cgColor
        profileBtn.layer.shadowColor  = UIColor.darkGray.cgColor
        settingBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        profileBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        let email = UserDefaults.standard.value(forKey: "email") as! String
        userOperation.getUserFullName(email: email){name in
            UserDefaults.standard.setValue(name, forKey: "username")
            self.NameField?.text = name
        }
        
        self.addChildControllers()
        
        
        fireStorage.getUrlByPath(path: "image/" + email + "_avatar"){ url in
            
            guard let urlLink = URL(string: url)  else{
                self.imageView?.image = UIImage(named: "ava")
                return
            }
            //fetching the avatar and place it to the image view
            let task = URLSession.shared.dataTask(with: urlLink, completionHandler: {data, _, error in
                        guard let data = data, error == nil else{
                            return
                        }
                        //adding the task to the main thread
                        DispatchQueue.main.async {
                            
                            let image = UIImage(data:data)
                            self.imageView?.image = image
                        }
                    })
            task.resume()
        }
    }
    
    @objc func toTestTable(){
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let initialBoard = sb.instantiateViewController(withIdentifier: Constants.Storyboard.managePostViewController) as! ManageYourPost
        
        self.view.window?.rootViewController = initialBoard
        let snapshot = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
        initialBoard.view.addSubview(snapshot)
        UIView.transition(with: snapshot,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                              snapshot.layer.opacity = 0
                          },
                          completion: { status in
                              snapshot.removeFromSuperview()
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
    // link this action to the 'upload' button
    @objc func uploadProfileTapped(_ sender: Any){
        checkPermission()
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
   /* @IBAction func showTestTable(){
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let initialBoard = sb.instantiateViewController(withIdentifier: "TestTable") as! TestTable
        
        self.view.window?.rootViewController = initialBoard
        let snapshot = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
        initialBoard.view.addSubview(snapshot)
        UIView.transition(with: snapshot,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                              snapshot.layer.opacity = 0
                          },
                          completion: { status in
                              snapshot.removeFromSuperview()
                          })
    }*/
    
    @IBAction func showPosts(){
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let initialBoard = sb.instantiateViewController(withIdentifier: Constants.Storyboard.managePostViewController) as! ManageYourPost
        
        self.view.window?.rootViewController = initialBoard
        let snapshot = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
        initialBoard.view.addSubview(snapshot)
        UIView.transition(with: snapshot,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                              snapshot.layer.opacity = 0
                          },
                          completion: { status in
                              snapshot.removeFromSuperview()
                          })
    }
    //if user clicks on 'Help Center', it shows a dialog asking the user to contact the author
    @IBAction func showContact(){
        contactAlert = UIAlertController(title: "Please contact heyjill1129@gmail.com so as to report any technical issue.", message: nil, preferredStyle: .alert)
        contactAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(self.contactAlert, animated: true, completion: nil)
    }
    
    //if sign out button is clicked, we show up the sign out controller.
    @IBAction func signOut(){
        self.signoutController.showUpDialog()
    }
    
    
    
    //setting up all child controllers within side menu and add subviews accordingly
    private func addChildControllers(){
        
        //add childs to current object
        addChild(profileController)
        
        addChild(signoutController)

        //add subviews
        view.addSubview(profileController.view)
        
        view.addSubview(signoutController.view!)
        
        //set boundaries
        profileController.view.frame = view.bounds
        
        signoutController.view.frame = view.bounds
        
        //set movements
        profileController.didMove(toParent: self)
        
        signoutController.didMove(toParent: self)
        
        //hide the side menu item views as default unless the user clicks on them
        profileController.view.isHidden = true
        
        signoutController.view.isHidden = true
    }
    
    //customize the image picker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let firestorage = FireStorage()
        //we need to get the user email so as to upload the file with correct path and name
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let path  = "image/" + email + "_avatar"
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        firestorage.uploadToCloud(pngData: imageData, refPath: path){result in
            if result{
                firestorage.getUrlByPath(path: path){ url in
                    
                    self.imagePickerController.dismiss(animated: true){
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    //dismiss the image view picker controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
