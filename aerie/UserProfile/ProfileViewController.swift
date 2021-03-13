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
    
    @IBOutlet var priceRange:  UISlider!
    @IBOutlet var petFriendly: UISwitch!
    @IBOutlet var smokeOrNot:  UISwitch!
    @IBOutlet var confirmBtn:  UIButton!
    
    
    @IBOutlet var backBtn:     UIBarButtonItem!
    @IBOutlet var firstNameField:   UITextField!
    @IBOutlet var lastNameField:    UITextField!
    @IBOutlet var buttonBackView: UIView!
    
    
    private var userFieldAlert:  UIAlertController!
    private var updateDataAlert: UIAlertController!
    private var permissionAlert: UIAlertController!
    
    private var userOperation = UserOperation()
    private var fireStorage = FireStorage()
    private var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedElseWhere()
        userOperation.getUserFirstName(email: UserDefaults.standard.value(forKey: "email") as! String){ firstName in
            self.firstNameField?.text = firstName
        }
        userOperation.getUserLastName(email: UserDefaults.standard.value(forKey: "email") as! String){lastName in
            self.lastNameField?.text = lastName
            
        }
      
        confirmBtn?.layer.cornerRadius = CGFloat(12)
        
        imageView?.isUserInteractionEnabled = true
        imageView?.layer.masksToBounds = false
        imageView?.layer.borderColor = UIColor.white.cgColor
        imageView?.layer.cornerRadius = imageView.frame.height / 2
        imageView?.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
        
        let email = UserDefaults.standard.value(forKey: "email") as! String
        let username = UserDefaults.standard.value(forKey: "username") as! String
        nameField?.text  = username
        emailField?.text = email
        let url = UserDefaults.standard.value(forKey: "url") as! String
        
            
            guard let urlLink = URL(string: url)  else{
                self.imageView?.image = UIImage(named: "ava")
                return
            }
            let avatar_path = self.fireStorage.storageRef.child("image/" + email + "_avatar")
            avatar_path.getData(maxSize: 15*1024*1024){data, err in
                if let err = err{
                    return
                }
                else{
                    let image = UIImage(data:data!)
                    self.imageView?.image = image
                }
            }
        }
    
    
    //back to previous page
    @IBAction func backToHome(){
        self.dismiss(animated: true){
            if let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?  HomeViewController{
                //setting user default like a global variable since it is light weight and used through the whole project
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }
    
    //at least first name and last name cannot be nil
    func validateFields() -> String?{
        if firstNameField.text?.trimmingCharacters(in: .whitespaces) == "" ||
            lastNameField.text?.trimmingCharacters(in: .whitespaces) == "" {
            return Constants.errorMessages.emptyField
        }
        return nil
    }
    
    func getUpdatedData() -> Dictionary<String, Any> {
        var data = Dictionary<String, Any>()
        let fullName = UserDefaults.standard.value(forKey: "username") as! String
        let firstNameRemote = fullName.components(separatedBy: " ")[0]
        let lastNameRemote  = fullName.components(separatedBy: " ")[1]
        let firstName = firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if firstName != firstNameRemote{
            data[Constants.userFields.firstname] = firstName.capitalizingFirstLetter()
        }
        let lastName  = lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if lastName != lastNameRemote{
            data[Constants.userFields.lastname] = lastName.capitalizingFirstLetter()
        }
        return data
    }
    
    // once submit profile button is clicked, we should update the user's profile via firebase
    
    @IBAction func submitProfile(){
        let email = UserDefaults.standard.value(forKey: "email") as? String
        let error = validateFields()
        if error != nil{
            let alertNameField = UIAlertController(title: error, message: nil, preferredStyle: .alert)
            alertNameField.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertNameField, animated: true, completion: nil)
        }
        else{
            let data = self.getUpdatedData()
            userOperation.updateUserDocument(userEmail: email!, data: data){ [self] result in
                if !result{
                    self.updateDataAlert = UIAlertController(title: Constants.errorMessages.errorToSaveDate, message: "Please retry", preferredStyle: .alert)
                    self.updateDataAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(self.updateDataAlert, animated: true, completion: nil)
                }
                
            userOperation.getUserFullName(email: email!){ fullname in
                    UserDefaults.standard.setValue(fullname, forKey: "username")
                }
                
            self.dismiss(animated: true, completion: nil)
                
            
            }
        }
    }
    
}
