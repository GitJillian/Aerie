//
//  ViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.

import UIKit
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate{
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        init_interface()
        googleButton.addTarget(self, action: #selector(signinUserUsingGoogle(_ :)), for: .touchUpInside)
    }
    
    func init_interface() {
        
        Styler.setBackgroundWithPic(self.view, Constants.Images.backgroundPic)
        Styler.styleFilledButton(signUpButton, .clear, Constants.Colors.borderColor, Constants.Buttons.borderWidth)
        Styler.styleFilledButton(loginButton, UIColor.white)
        errorLabel.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
            }
        // once the log in is successful, would switch to home view
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        }
    
    // When the Google Sign in Button is clicked, will direct to Google Log in interface
    @objc func signinUserUsingGoogle(_ sender: UIButton) {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.textColor = Constants.Colors.black
                self.errorLabel.text = Constants.errorMessages.loginError
                self.errorLabel.alpha = 1
            }
            else {
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
    

