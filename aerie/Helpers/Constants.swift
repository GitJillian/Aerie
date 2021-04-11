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
        
        static let homeViewController       = "HomeVC"
        static let profileViewController    = "ProfileVC"
        static let sendpostViewController   = "SendPostVC"
        static let managePostViewController = "ManagePostVC"
        static let editPostController       = "EditPostVC"
    }
    
    struct Images{
        static let backgroundPic = "background_main"
        static let avaBackPic    = "ava_back"
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
        static var setLocation = "Do you want to pick this place as your location?"
        static var setExpectedLocation = "Do you want to pick this place as your expected location for residence?"
    }
    
    struct errorMessages{
        static var loginError = "Login error."
        static var emptyField = "Please fill all fields."
        static var errorToSaveDate   = "Error saving user data"
        static var passwordMismatch  = "Password should be at least 8 characters, contains a special character and a number."
        static var passwordNotEqual  = "Your passwords are not the same. "
        static var failureCreateUser = "Failed to create user."
        static var failureToSignOut  = "Failed to sign out. Please retry later."
        static var upperValueError   = "Upper value is invalid. Please retry."
        static var lowerValueError   = "Lower value is invalid. Please retry."
    }
    
    struct dbNames{
        static var userDB = "users"
        static var postDB = "posts"
        static var messageDB = "message"
    }
    
    struct genderStr{
        static var female = "female"
        static var male   = "male"
        static var unisex = "unisex"
    }
    
    struct userFields{
        static var uid         = "uid"
        static var age         = "age"
        static var birth       = "birthday"
        static var gender      = "gender"
        static var emailField  = "email"
        static var firstname   = "firstname"
        static var lastname    = "lastname"
        static var petFriendly = "petFriendly"
        static var smokeOrNot  = "smokeOrNot"
        static var locationStr = "location"
        
    }
    
    struct location{
        static var locationName = "locationName"
        static var adminRegion  = "adminRegion"
        static var locality     = "locality"
        static var country      = "country"
    }
    
    struct postFields{
        static var pidField    = "pid"
        static var uidField    = "uid"
        static var description = "description"
        static var timeStamp   = "timeStamp"
        static var budget      = "budget"
        static var expectedLocation  = "expectedLocation"
    }
    
    struct cells {
        static var normalCell = "cell"
        static var manageCell = "manageCell"
    }
    
    struct filter{
        static var petFilter   = "petFilter"
        static var smokeFilter = "smokeFilter"
        static var priceUpper  = "priceUpper"
        static var priceLower  = "priceLower"
        static var ageLower    = "ageLower"
        static var ageUpper    = "ageUpper"
        static var genderFilter = "genderFilter"
    }
    
    struct postModel{
        static var pidField = "pid"
        static var uidField = "uid"
        static var description = "description"
        static var timeStamp   = "timeStamp"
        static var budget      = "budget"
        static var expectedLocation  = "expectedLocation"
        static var userLocation = "location"
        static var userEmail   = "email"
        static var userFullName = "fullname"
        static var userAge     = "age"
        static var userGender  = "gender"
        static var petFriendly = "petFriendly"
        static var smokeOrNot  = "smokeOrNot"
        
    }
}
