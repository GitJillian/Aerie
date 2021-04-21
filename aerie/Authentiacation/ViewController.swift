//
//  ViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.
//  The log in controller that contains email field, password field, the option to log in as Google accout, and register an accout using emails

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase


class ViewController: UIViewController, GIDSignInDelegate{
    
    
    @IBOutlet weak var signUpButton : UIButton!
    
    @IBOutlet weak var loginButton  : UIButton!
    
    @IBOutlet weak var googleButton : UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    public var userField = Constants.userFields.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //before we log in, the default username and email should be nothing
        UserDefaults.standard.set("no name", forKey:"username")
        UserDefaults.standard.set("no email",forKey: "email")
        UserDefaults.standard.set("no url",  forKey: "url")
        UserDefaults.standard.set("no uid",  forKey: "uid")
        googleButton!.addTarget(self, action: #selector(signinUserUsingGoogle(_ :)), for: .touchUpInside)
        self.errorLabel?.textColor = UIColor(named:"buttonText")
        self.errorLabel?.alpha = 0
        Styler.setBackgroundWithPic(self.view!, Constants.Images.backgroundPic)
        Styler.styleFilledButton(signUpButton, .clear, UIColor(named:"line")?.cgColor, Constants.Buttons.borderWidth)
        Styler.styleFilledButton(loginButton,  UIColor(named:"textBackGround") ?? .clear)
        signUpButton.tintColor = UIColor(named:"line")
        loginButton.tintColor = UIColor(named:"text")
        //close keyboard when you click on somewhere else on the screen
        self.hideKeyboardWhenTappedElseWhere()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
       
        let userManagement = UserOperation()
        guard let currentEmail = user.profile.email else{return}
        userManagement.isUserExist(email: currentEmail){ [self] userExist in
            if !userExist{
               
                let uid = UUID().uuidString
                // once the log in is successful, would switch to home view
                UserDefaults.standard.set(uid, forKey: "uid")
                UserDefaults.standard.set(currentEmail, forKey: "email")
                
                userManagement.addSetUserDocument(uid: uid, data: [self.userField.emailField: currentEmail , userField.firstname: user.profile.givenName ?? "", userField.lastname: user.profile.familyName ?? "", Constants.userFields.uid: uid]){(result) in
                    if !result{
                        return
                    }else{
                        self.switchToHome()
                    }
                }
            }
            else{
                
                let userOperation = UserOperation()
                userOperation.getUidByEmail(email: currentEmail){uid in
                    UserDefaults.standard.set(currentEmail, forKey: "email")
                    UserDefaults.standard.set(uid  , forKey: "uid")
                    
                    self.switchToHome()
                }
            }
            
            
        }
    }

    
    
    // When the Google Sign in Button is clicked, will direct to Google Log in interface
    @objc func signinUserUsingGoogle(_ sender: UIButton) {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        
        // Create cleaned versions of the text field
        let email    = emailTextField?.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField?.text!.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email ?? "", password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel?.textColor = UIColor(named:"text")
                self.errorLabel?.text = Constants.errorMessages.loginError
                self.errorLabel?.alpha = 1
                
            }
            else {
                
                let userOperation = UserOperation()
                userOperation.getUidByEmail(email: email!){uid in
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(uid  , forKey: "uid")
                    
                    self.switchToHome()
                }
                
            }
        }
    }
    
    func switchToHome(){
        //setting user default like a global variable since it is light weight and used through the whole project
        
        if let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?  HomeViewController{
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            loginTapped(loginButton!)
        }
        return true
    }
}

