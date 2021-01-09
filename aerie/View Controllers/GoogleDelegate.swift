//
//  GoogleSignIn.swift
//  aerie
//
//  Created by 液晶宝宝 on 2021/1/8.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    @Published var signedIn: Bool = false
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // If the previous `error` is null, then the sign-in was succesful
        
        signedIn = true
        //let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //self.view.window?.rootViewController = homeViewController
        //self.view.window?.makeKeyAndVisible()
    }
    
    
}
