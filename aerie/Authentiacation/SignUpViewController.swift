//
//  SignUpViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.


import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

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

        // Do any additional setup after loading the view.
        init_interface()
    }
    
    func init_interface() {
    
        // Hide the error label
        
        errorLabel.alpha = 0
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationItem.title = Constants.Texts.signUpTitle
        Styler.setBackgroundWithPic(self.view, Constants.Images.backgroundPic)
        Styler.styleTextField(firstNameTextField, Constants.Colors.white.cgColor)
        Styler.styleTextField(lastNameTextField, Constants.Colors.white.cgColor)
        Styler.styleTextField(emailTextField, Constants.Colors.white.cgColor)
        Styler.styleTextField(passwordTextField, Constants.Colors.white.cgColor)
        Styler.styleTextField(passwordConfirm, Constants.Colors.white.cgColor)
        Styler.styleFilledButton(signUpButton, Constants.Colors.white)
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
                    
                    
                    let result = userManagement.addSetUserDocument(userEmail: email, data: [self.userField.firstname:firstName, self.userField.lastname:lastName, self.userField.emailField: email ])
                    
                    if !result{
                        self.showError(Constants.errorMessages.errorToSaveDate)                    }}
                    self.SwitchToHomePage(email:email)
                    
                
            }
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func SwitchToHomePage(email: String) {
        
        if let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController{
            homeViewController.email = email
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        }
    }
    
}
