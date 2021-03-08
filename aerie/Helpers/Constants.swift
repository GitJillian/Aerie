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
        static let profileViewController = "ProfileVC"
    }
    
    struct Images{
        static let backgroundPic = "background_main"
    }
    
    struct Buttons{
        
        static var buttonCornerRadius = CGFloat(10)
        static var borderWidth = CGFloat(1)
        
    }
    
    struct BottomLine{
        static var absoluteX = CGFloat(0)
        static var verticalHeight = CGFloat(4)
    }
    
    struct Texts{
        static var signUpTitle = "Sign Up"
        static var signOutText = "Are you sure you want to sign out?"
    }
    
    struct errorMessages{
        static var loginError = "Login error."
        static var emptyField = "Please fill all fields."
        static var errorToSaveDate   = "Error saving user data"
        static var passwordMismatch  = "Password should be at least 8 characters, contains a special character and a number."
        static var passwordNotEqual  = "Your passwords are not the same. "
        static var failureCreateUser = "Failed to create user."
        static var failureToSignOut  = "Failed to sign out. Please retry later."
    }
    
    struct dbNames{
        static var userDB = "users"
        static var postDB = "posts"
    }
    
    struct userFields{
        static var age         = "age"
        static var gender      = "gender"
        static var postings    = "postings"
        static var emailField  = "email"
        static var firstname   = "firstname"
        static var lastname    = "lastname"
        static var petFriendly = "petFriendly"
        static var smokeOrNot  = "smokeOrNot"
        static var expectedRentUpper = "expectedRentUpper"
        static var expectedRentLower = "expectedRentLower"
        static var expectedLocation  = "expectedLocation"
        static var isProfileUploaed  = "isProfileUploaded"
        static var profileUrl        = "profileUrl"
    }
}
