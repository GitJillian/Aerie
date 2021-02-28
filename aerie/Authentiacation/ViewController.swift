//
//  ViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.

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
        googleButton!.addTarget(self, action: #selector(signinUserUsingGoogle(_ :)), for: .touchUpInside)
        self.errorLabel?.alpha = 0
        Styler.setBackgroundWithPic(self.view!, Constants.Images.backgroundPic)
        Styler.styleFilledButton(signUpButton, .clear, Constants.Colors.borderColor, Constants.Buttons.borderWidth)
        Styler.styleFilledButton(loginButton, UIColor.white)
        
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
        
        userManagement.addSetUserDocument(userEmail: currentEmail, data: [userField.emailField: currentEmail , userField.firstname: user.profile.givenName ?? "", userField.lastname: user.profile.familyName ?? ""]){(result) in
            if !result{
                return
            }
            // once the log in is successful, would switch to home view
            
            self.switchToHome(email:currentEmail)
            
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
        let email = emailTextField?.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField?.text!.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email ?? "", password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel?.textColor = Constants.Colors.white
                self.errorLabel?.text = Constants.errorMessages.loginError
                self.errorLabel?.alpha = 1
                
            }
            else {
                self.switchToHome(email: email ?? "")
            }
        }
    }
    
    func switchToHome(email: String){
        
        if let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?  HomeViewController{
            homeViewController.email = email
            let useroperation = UserOperation()
            useroperation.getUserName(email: email){(name) in
                homeViewController.userName = name
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
    

