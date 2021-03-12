//
//  ProfileViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/2/23.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import Photos
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private   var alert:       UIAlertController!
    @IBOutlet var backView :   UIView!
    @IBOutlet var nameField:   UILabel!
    @IBOutlet var emailField:  UILabel!
    @IBOutlet var imageView:   UIImageView!
    @IBOutlet var firstName:   UITextView!
    @IBOutlet var lastName:    UITextView!
    @IBOutlet var priceRange:  UISlider!
    @IBOutlet var petFriendly: UISwitch!
    @IBOutlet var smokeOrNot:  UISwitch!
    @IBOutlet var confirmBtn:  UIButton!
    @IBOutlet var scrollView:  UIScrollView!
    @IBOutlet var backBtn:     UIBarButtonItem!
    var imagePickerController = UIImagePickerController()
    var email:String!
    private var permissionAlert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let upLoadTap  = UITapGestureRecognizer(target: self, action:#selector(uploadProfileTapped(_:)))
        
        self.confirmBtn?.layer.cornerRadius = CGFloat(12)
        scrollView?.isScrollEnabled = true
        imageView?.isUserInteractionEnabled = true
        imageView?.layer.masksToBounds = false
        imageView?.layer.borderColor = UIColor.white.cgColor
        imageView?.layer.cornerRadius = imageView.frame.height / 2
        imageView?.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
        imageView?.backgroundColor = UIColor(named:"backgroundReverse")
        imageView?.addGestureRecognizer(upLoadTap)
        //setting avatars by pulling firebase storage data
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string:urlString) else{
                    return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else{
                self.imageView?.image = UIImage(named: "ava")
                return
            }
            //adding the task to the main thread
            DispatchQueue.main.async {
                let image = UIImage(data:data)
                self.imageView?.image = image
            }
        })
        task.resume()
        
        nameField?.text  = UserDefaults.standard.value(forKey: "username") as? String
        emailField?.text = UserDefaults.standard.value(forKey: "email") as? String
    }
    
    // when we dismiss this view controller, we go back to the previous page and save the data
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isBeingDismissed{
            if let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?  HomeViewController{
                //setting user default like a global variable since it is light weight and used through the whole project
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
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
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag){
            if let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?  HomeViewController{
                //setting user default like a global variable since it is light weight and used through the whole project
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }
    
    @IBAction func backToHome(){
        if let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?  HomeViewController{
            //setting user default like a global variable since it is light weight and used through the whole project
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitProfile(){
        
    }
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
        firestorage.uploadToCloud(pngData: imageData, refPath: path)
        
        imagePickerController.dismiss(animated: true){
            self.imageView.image = image
        }
        
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
