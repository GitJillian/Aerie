import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import Photos
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    private var alert:       UIAlertController!
    private var datePicker = UIDatePicker()
    private var userFieldAlert:  UIAlertController!
    private var updateDataAlert: UIAlertController!
    private var permissionAlert: UIAlertController!
    @IBOutlet var imageView:     UIImageView!
    @IBOutlet var nameField:     UILabel!
    @IBOutlet var emailField:    UILabel!
    @IBOutlet var firstNameField:UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var birthDateTxt:  UITextField!
    @IBOutlet var femmeBtn:      CheckBox!
    @IBOutlet var hommeBtn:      CheckBox!
    @IBOutlet var locationField: UILabel!
    private var userOperation = UserOperation()
    private var fireStorage = FireStorage()
    @IBOutlet weak var smokeSwitch: UISwitch!
    @IBOutlet weak var petSwitch: UISwitch!
    
    private var imagePickerController = UIImagePickerController()
    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        userOperation.isUserFieldExist(documentName: uid, fieldName: Constants.userFields.gender){isGenderExist in
            if isGenderExist{
                self.userOperation.getUserGender(uid:uid){genderStr in
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
        
        UserDefaults.standard.setValue("userLocation", forKey: "locationType")
        
        femmeBtn?.alternateButton = [hommeBtn!]
        hommeBtn?.alternateButton = [femmeBtn!]
        self.hideKeyboardWhenTappedElseWhere()
        userOperation.getUserDocument(documentName: UserDefaults.standard.value(forKey: "uid") as! String){ data in
            let firstName = data[Constants.userFields.firstname] as! String
            let lastName  = data[Constants.userFields.lastname]  as! String
            
            
            self.firstNameField?.text = firstName
            self.lastNameField?.text  = lastName
            
            let setBirthAlready = data[Constants.userFields.birth] != nil
            if setBirthAlready{
                let birthday = data[Constants.userFields.birth]
                self.birthDateTxt?.text   = birthday as? String
            }else{
                self.birthDateTxt?.text = ""
            }
            let setLocation = data[Constants.userFields.locationStr] != nil
            if setLocation{
                let location = data[Constants.userFields.locationStr] as! [String: Any]
                self.locationField?.text = location["title"] as? String
            }else{
                self.locationField?.text = ""
            }
            //setting is pet friendly using UISwitch
            let petFriendlyIsSet = data[Constants.userFields.petFriendly] != nil
            if petFriendlyIsSet{
                let isPetFriendly = data[Constants.userFields.petFriendly] as! Bool
                self.petSwitch?.setOn(isPetFriendly, animated: true)
                
            }else{
                self.petSwitch?.setOn(true, animated: true)
                
            }
            //setting is smoking allowed using UISwitch
            let smokeIsSet = data[Constants.userFields.smokeOrNot] != nil
            if smokeIsSet{
                let isSmokeAllowed = data[Constants.userFields.smokeOrNot] as! Bool
                self.smokeSwitch?.setOn(isSmokeAllowed, animated: true)
                
            }else{
                self.smokeSwitch?.setOn(true, animated: true)
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
        
            
        
            //setting image view to the avatar in firebase storage
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        let avatar_path = self.fireStorage.storageRef.child("image/" + String.safeEmail(emailAddress: uid) + "_avatar")
            avatar_path.getData(maxSize: 15*1024*1024){data, err in
                if let err = err{
                    print(err)
                    self.imageView?.image = UIImage(named: "ava")
                    
                }
                else{
                    let image = UIImage(data:data!)
                    self.imageView?.image = image
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
        //setting maximum date that the user can pick
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -120, to: Date())
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
        // getting the updated data according to the current setting and return it
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
        let isPetFriendly  = petSwitch?.isOn
        let isSmokeing     = smokeSwitch?.isOn
        data[Constants.userFields.petFriendly] = isPetFriendly
        data[Constants.userFields.smokeOrNot]  = isSmokeing
        return data
    }
    
    // once submit profile button is clicked, we should update the user's profile via firebase
    @IBAction func submitProfile(){
        let uid = UserDefaults.standard.value(forKey: "uid") as? String
        let error = validateFields()
        if error != nil{
            let alertNameField = UIAlertController(title: error, message: nil, preferredStyle: .alert)
            alertNameField.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertNameField, animated: true, completion: nil)
        }
        else{
            let data = self.getUpdatedData()
            userOperation.updateUserDocument(uid: uid!, data: data){ [self] result in
                if !result{
                    self.updateDataAlert = UIAlertController(title: Constants.errorMessages.errorToSaveDate, message: "Please retry", preferredStyle: .alert)
                    self.updateDataAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(self.updateDataAlert, animated: true, completion: nil)
                }
                
                userOperation.getUserFullName(uid: uid!){ fullname in
                    UserDefaults.standard.setValue(fullname, forKey: "username")
                }
                
            self.dismiss(animated: true, completion: nil)
                
            
            }
        }
    }
    
}
