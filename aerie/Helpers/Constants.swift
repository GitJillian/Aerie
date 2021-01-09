//
//  Constants.swift
//  Aerie
//  Used for defining some frequently used variables and assignment values with semantic meanings

//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.

import Foundation
import UIKit

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "HomeVC"
        
    }
    struct Colors{
        static let borderColor = UIColor.white.cgColor
        static let black       = UIColor.black
        static let white       = UIColor.white
        static let transparent:UIColor = .clear
        static let grassGreen  = UIColor.init(red: 0.22, green: 0.77, blue: 0.61, alpha: 1.00)
        static let skyBlue     = UIColor.init(red: 0.27, green: 0.76, blue: 0.95, alpha: 1.00)
        static let tiffany     = UIColor.init(red: 0.40, green: 0.80, blue: 0.80, alpha: 1.00)
    }
    
    struct Images{
        static let backgroundPic = "background_main"
    }
    
    struct Buttons{
        
        static var buttonCornerRadius = CGFloat(10)
        static var borderWidth = CGFloat(1)
        
    }
    
    struct BottomLine{
        
        static var verticalHeight = CGFloat(2.5)
        static var absoluteX = CGFloat(0)
        
    }
    
    struct Texts{
        static var signUpTitle = "Sign Up"
    }
    
    struct errorMessages{
        
        static var passwordMismatch = "Please make sure your password is at least 8 characters, contains a special character and a number."
        static var passwordNotEqual = "Your passwords are not the same. Please re-enter and try again."
        static var emptyField = "Please fill all fields."
        static var failureCreateUser = "Failed to create user."
        static var errorToSaveDate = "Error saving user data"
        static var loginError = "Login error. Please re-enter email and password!"
    }
}
