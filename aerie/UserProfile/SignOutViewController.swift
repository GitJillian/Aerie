//
//  SignOutViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/2/23.
//  Copyright © 2021 Yejing Li. All rights reserved.
//  This controller contains an alert view, asking whether the user wants to sign out. If yes, just sign out. If no, stay in the page.

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
class SignOutViewController: UIViewController{
    
    //an alert view containing a yes/no option and a message of 'are you sure to log out'
    private var alert:UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
        alert = UIAlertController(title: Constants.Texts.signOutText, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {action in
        //google accout is signing out...
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        do {
            //if the user chooses to sign out, we should redirect the user to the ViewController view
            let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let initialBoard = sb.instantiateViewController(withIdentifier: "ViewVC") as! ViewController
            
            self.view.window?.rootViewController = initialBoard
            self.view.window?.makeKeyAndVisible()
            //firebase account is signing out...
            try firebaseAuth.signOut()
        } catch let error  {
            print(error)
                }
            }
        ))
    }
    
    func showUpDialog(){
        present(self.alert, animated: true, completion: nil)
    }
}
