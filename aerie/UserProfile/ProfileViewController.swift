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
    @IBOutlet weak var birthDateTxt: UITextField!
    @IBOutlet var priceRange:  UISlider!
    @IBOutlet var petFriendly: UISwitch!
    @IBOutlet var smokeOrNot:  UISwitch!
    
    @IBOutlet weak var femmeBtn: CheckBox!
    @IBOutlet weak var hommeBtn: CheckBox!
    @IBOutlet var backBtn:     UIBarButtonItem!
    @IBOutlet var firstNameField:   UITextField!
    @IBOutlet var lastNameField:    UITextField!
    @IBOutlet var buttonBackView: UIView!
    
    private var datePicker = UIDatePicker()
    private var userFieldAlert:  UIAlertController!
    private var updateDataAlert: UIAlertController!
    private var permissionAlert: UIAlertController!
    
    private var userOperation = UserOperation()
    private var fireStorage = FireStorage()
    private var imagePickerController = UIImagePickerController()
    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        let email = UserDefaults.standard.value(forKey: "email") as! String
        userOperation.isUserFieldExist(documentName: email, fieldName: Constants.userFields.gender){isGenderExist in
            if isGenderExist{
                self.userOperation.getUserGender(email: email){genderStr in
                    if genderStr == Constants.genderStr.female{
                        self.femmeBtn.isSelected = true
                        self.hommeBtn.isSelected = false
                    }else{
                        self.femmeBtn.isSelected = false
                        self.hommeBtn.isSelected = true
                    }
                }
            }else{
                self.femmeBtn.isSelected = true
                self.hommeBtn.isSelected = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        femmeBtn?.alternateButton = [hommeBtn!]
        hommeBtn?.alternateButton = [femmeBtn!]
        self.hideKeyboardWhenTappedElseWhere()
        userOperation.getUserDocument(documentName: UserDefaults.standard.value(forKey: "email") as! String){ data in
            let firstName = data[Constants.userFields.firstname] as! String
            let lastName  = data[Constants.userFields.lastname]  as! String
            
            
            self.firstNameField?.text = firstName
            self.lastNameField?.text  = lastName
            
            let setBirthAlready = data[Constants.userFields.birth] != nil
            if setBirthAlready{
                let birthday = data[Constants.userFields.birth]
                self.birthDateTxt?.text   = birthday as? String
            }else{
                self.birthDateTxt?.text = "Select Birthday"
            }
            
        }
      
        
        
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
        
        initializeDatePick()
        
        let url = UserDefaults.standard.value(forKey: "url") as! String
            
        if url == "no url"{
            self.imageView?.image = UIImage(named: "ava")
        }
        else{
            //setting image view to the avatar in firebase storage
            let avatar_path = self.fireStorage.storageRef.child("image/" + email + "_avatar")
            avatar_path.getData(maxSize: 15*1024*1024){data, err in
                if let err = err{
                    print(err)
                    return
                }
                else{
                    let image = UIImage(data:data!)
                    self.imageView?.image = image
                }
            }
        }
        
    }
    
    //enable user to choose date of birth
    func initializeDatePick(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(selectDateFinshed))
        toolBar.setItems([doneBtn], animated: true)
        
        birthDateTxt?.inputAccessoryView = toolBar
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        birthDateTxt?.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func selectDateFinshed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        birthDateTxt?.text = formatter.string(from: datePicker.date)
        birthDateTxt?.endEditing(true)
    }
    
    
    //at least first name and last name cannot be nil
    func validateFields() -> String?{
        if firstNameField.text?.trimmingCharacters(in: .whitespaces) == "" ||
            lastNameField.text?.trimmingCharacters(in: .whitespaces) == "" ||
            birthDateTxt.text?.trimmingCharacters(in: .whitespaces)  == ""{
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
        
        //get selected gender
        if self.femmeBtn.isSelected {
            data[Constants.userFields.gender] = Constants.genderStr.female
        }  else{
            data[Constants.userFields.gender] = Constants.genderStr.male
        }
        //get selected birthday
        
        let birthday = birthDateTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let now = Date()
        let birthdayToDate = Date(birthday)
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthdayToDate, to: now)
        let age = ageComponents.year!
        data[Constants.userFields.age] = age
        data[Constants.userFields.birth] = birthday
        
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
