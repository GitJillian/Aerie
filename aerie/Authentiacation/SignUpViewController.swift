//
//  SignUpViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.


import UIKit
import FirebaseAuth
import FirebaseStorage
import Photos

class SignUpViewController: UIViewController{

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var passwordConfirm: UITextField!
    
    
    public var userField = Constants.userFields.self
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adjustTextFieldWhenEditingNew()
        self.hideKeyboardWhenTappedElseWhere()
        // Do any additional setup after loading the view.
        init_interface()
    }
    
    func adjustTextFieldWhenEditingNew(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow1(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide1(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow1(sender: NSNotification) {
         self.view.frame.origin.y = -30 // Move view 190 points upward
    }

    @objc func keyboardWillHide1(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @IBAction func hideSignUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func init_interface() {
        // Hide the error label
        
        errorLabel.alpha = 0
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationItem.title = Constants.Texts.signUpTitle
        
        Styler.styleTextField(firstNameTextField, UIColor(named:"line")?.cgColor ?? UIColor.white.cgColor)
        Styler.styleTextField(lastNameTextField,  UIColor(named:"line")?.cgColor ?? UIColor.white.cgColor)
        Styler.styleTextField(emailTextField,     UIColor(named:"line")?.cgColor ?? UIColor.white.cgColor)
        Styler.styleTextField(passwordTextField,  UIColor(named:"line")?.cgColor ?? UIColor.white.cgColor)
        Styler.styleTextField(passwordConfirm,    UIColor(named:"line")?.cgColor ?? UIColor.white.cgColor)
        Styler.styleFilledButton(signUpButton,    UIColor(named:"button") ?? .clear, UIColor(named:"buttonText")?.cgColor, Constants.Buttons.borderWidth)
        signUpButton.setTitleColor(UIColor(named:"buttonText"), for: .normal)
    }
        
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordConfirm.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""    {
            
            return Constants.errorMessages.emptyField
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordConfirmText = passwordConfirm.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        if !passwordTest.evaluate(with: cleanedPassword){
            return Constants.errorMessages.passwordMismatch
        }
            
        if cleanedPassword != passwordConfirmText{
            return Constants.errorMessages.passwordNotEqual
        }
        return nil
    }
    

    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                   // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError(Constants.errorMessages.failureCreateUser)
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                    
                    let userManagement = UserOperation()
                    
                    let uid = UUID().uuidString
                    userManagement.addSetUserDocument(uid: uid, data: [self.userField.firstname:firstName, self.userField.lastname:lastName, self.userField.emailField: email, self.userField.uid
                                                                        : uid ]){(result) in
                        if !result{
                            self.showError(Constants.errorMessages.errorToSaveDate)
                        }
                        UserDefaults.standard.set(uid,   forKey: "uid")
                        UserDefaults.standard.set(email, forKey: "email")
                        self.SwitchToHomePage()
                    }
                }
            }
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func SwitchToHomePage() {
        
        
        if let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?  HomeViewController{
            
                //setting user default like a global variable since it is light weight and used through the whole project
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            
        }
    }
}
