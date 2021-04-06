//
//  SendPostViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/24.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit
import FirebaseFirestore
class SendPostViewController: UIViewController,UINavigationControllerDelegate, UITextFieldDelegate {
    var postOperation = PostOperation()
    @IBOutlet weak var textViewBack: UIView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var profileViewBack: UIView!
    @IBOutlet weak var femmeBtn: CheckBox!
    @IBOutlet weak var hommeBtn: CheckBox!
    @IBOutlet weak var dateOfBirthText: UITextField!
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var setOwnLocationBtn: UIButton!
    @IBOutlet weak var preferenceView: UIView!
    @IBOutlet weak var PetSwitch: UISwitch!
    @IBOutlet weak var SmokeSwitch: UISwitch!
    @IBOutlet weak var budgetText: UITextField!
    @IBOutlet weak var desiredLocationText: UITextField!
    @IBOutlet weak var setDesiredLocation: UIButton!
    
    private var userOperation = UserOperation()
    private var fireStorage = FireStorage()
    private var imagePickerController = UIImagePickerController()
    private var datePicker = UIDatePicker()
    private var expectedLocationDict = [String: Any]()
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        profileViewBack.addShadow()
        textViewBack.addShadow()
        preferenceView.addShadow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOwnLocationBtn.addTarget(self,  action: #selector(setOwnlocationClicked),     for: .touchUpInside)
        setDesiredLocation.addTarget(self, action: #selector(setDesiredlocationClicked), for: .touchUpInside)
        self.adjustTextFieldWhenEditing()
        self.hideKeyboardWhenTappedElseWhere()
        femmeBtn?.alternateButton = [hommeBtn!]
        hommeBtn?.alternateButton = [femmeBtn!]
        
        let email = UserDefaults.standard.value(forKey: "email") as! String
        
        userOperation.getUserDocument(documentName: email){ data in
            let isGenderExist = data[Constants.userFields.gender] != nil
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
            
            let setBirthAlready = data[Constants.userFields.birth] != nil
            if setBirthAlready{
                let birthday = data[Constants.userFields.birth]
                self.dateOfBirthText?.text   = birthday as? String
            }else{
                self.dateOfBirthText?.text = ""
            }
            let setLocation = data[Constants.userFields.locationStr] != nil
            if setLocation{
                let location = data[Constants.userFields.locationStr] as! [String: Any]
                self.LocationText?.text = location["title"] as? String
            }else{
                self.LocationText?.text = ""
            }
            
            let petFriendlyIsSet = data[Constants.userFields.petFriendly] != nil
            if petFriendlyIsSet{
                let isPetFriendly = data[Constants.userFields.petFriendly] as! Bool
                self.PetSwitch?.setOn(isPetFriendly, animated: true)
                
            }else{
                self.PetSwitch?.setOn(true, animated: true)
            }
            //setting is smoking allowed using UISwitch
            let smokeIsSet = data[Constants.userFields.smokeOrNot] != nil
            if smokeIsSet{
                let isSmokeAllowed = data[Constants.userFields.smokeOrNot] as! Bool
                self.SmokeSwitch?.setOn(isSmokeAllowed, animated: true)
            }else{
                self.SmokeSwitch?.setOn(true, animated: true)
            }
            //setting desired location using String
            let desiredLocationIsSet = data[Constants.postFields.expectedLocation] != nil
            if desiredLocationIsSet{
                let desiredLocation = data[Constants.postFields.expectedLocation] as! [String: Any]
                self.desiredLocationText?.text = desiredLocation["title"] as? String
                self.expectedLocationDict = desiredLocation
            }else{
                self.desiredLocationText?.text = ""
            }
            
        }
        initializeDatePick()
    }
    
    @objc func setOwnlocationClicked(){
        UserDefaults.standard.setValue("userLocation", forKey: "locationType")
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let initialBoard = sb.instantiateViewController(withIdentifier: "MapVC") as! MapViewController
        self.present(initialBoard, animated: true, completion: nil)

    }
    
    @objc func setDesiredlocationClicked(){
        
        UserDefaults.standard.setValue("expectedLocation", forKey: "locationType")
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let initialBoard = sb.instantiateViewController(withIdentifier: "MapVC") as! MapViewController
        self.present(initialBoard, animated: true, completion: nil)
    }
    
    
    //enable user to choose date of birth
    func initializeDatePick(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(selectDateFinshed))
        toolBar.setItems([doneBtn], animated: true)
        
        dateOfBirthText?.inputAccessoryView = toolBar
        //setting maximum date that the user can pick
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -120, to: Date())
        dateOfBirthText?.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func selectDateFinshed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateOfBirthText?.text = formatter.string(from: datePicker.date)
        dateOfBirthText?.endEditing(true)
    }
    
    @IBAction func gobackToDiscover(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateFields() -> Bool{
        let description: String = descriptionTextField?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let dateOfBirth: String = dateOfBirthText?.text?.trimmingCharacters(in: .whitespacesAndNewlines)     ?? ""
        let budget     : String = budgetText?.text?.trimmingCharacters(in: .whitespacesAndNewlines)          ?? ""
        let ownLocation: String = LocationText?.text?.trimmingCharacters(in: .whitespacesAndNewlines)        ?? ""
        let desiredLocation: String = desiredLocationText?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if description.count < 10{
            return false
        }
        if description == "" || dateOfBirth == "" || budget == "" || ownLocation == "" || desiredLocation == ""{
            return false
        }
        if (NumberFormatter().number(from: budget) == nil){
            return false
        }
        return true
    }
    
    func getUpdatedUserProfile() -> Dictionary<String, Any>{
        var data = Dictionary<String, Any>()
        let isPetFriendly  = PetSwitch?.isOn
        let isSmokeing     = SmokeSwitch?.isOn
        data[Constants.userFields.petFriendly] = isPetFriendly
        data[Constants.userFields.smokeOrNot]  = isSmokeing
        
        let birthday       = dateOfBirthText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let now = Date()
        let birthdayToDate = Date(birthday)
        let calendar = Calendar.current
        //get selected gender
        if self.femmeBtn.isSelected {
            data[Constants.userFields.gender] = Constants.genderStr.female
        }  else{
            data[Constants.userFields.gender] = Constants.genderStr.male
        }
        let ageComponents = calendar.dateComponents([.year], from: birthdayToDate, to: now)
        let age = ageComponents.year!
        data[Constants.userFields.age] = age
        data[Constants.userFields.birth] = birthday
        return data
    }
    
    @IBAction func sendPost(){
        //if all fields looks correct
        if validateFields(){
            let email = String.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String)
            let pid = "post_\(email)_\(Date())"
            let userData = getUpdatedUserProfile()
            
            var postData = Dictionary<String, Any>()
            let budget = budgetText?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let description : String = descriptionTextField?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            postData[Constants.postFields.pidField] = pid
            postData[Constants.postFields.uidField] = UserDefaults.standard.value(forKey: "email") as! String
            postData[Constants.postFields.timeStamp] = Date()
            postData[Constants.postFields.description] = description
            postData[Constants.postFields.budget]   = Int(budget ?? "0")
            postData[Constants.postFields.expectedLocation] = self.expectedLocationDict
            self.postOperation.addSetPostDocument(pid: pid,
                                                      data: postData)
                { result in
                    let alert = UIAlertController()
                    alert.view.addSubview(UIView())
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    if result{
                        
                        let userOperation = UserOperation()
                        userOperation.updateUserDocument(userEmail: UserDefaults.standard.value(forKey: "email") as! String, data: userData){result in
                            if result{
                                alert.title = "Successfully post."
                            }else{
                                alert.title = "Fail to post."
                            }
                        }
                    }
                    else{
                        alert.title = "Fail to post."
                    }
                    self.present(alert, animated: true, completion: nil)
                    }
                }
            
        else{
            let alert = UIAlertController()
            alert.view.addSubview(UIView())
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.title = "Please make sure all fields are filled and correct."
            self.present(alert, animated: false, completion: nil)
            
            }
        }
}
