//
//  User.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/18.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation

protocol UserSerializable{
    init?(dictionary: [String: Any])
}
struct User{
    
    var email: String
    var gender: String
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var age: Int
    var location: [String:Any]
    var expectedRentUpper: Int
    var expectedRentLower: Int
    var petFriendly: Bool
    var smokeOrNot: Bool
    var dictionary: [String: Any]{
        return[Constants.userFields.emailField: email,
               Constants.userFields.gender    : gender,
               Constants.userFields.firstname : firstName,
               Constants.userFields.lastname  : lastName,
               Constants.userFields.birth     : dateOfBirth,
               Constants.userFields.age       : age,
               Constants.userFields.locationStr:location,
               Constants.userFields.expectedRentUpper: expectedRentUpper,
               Constants.userFields.expectedRentLower: expectedRentLower,
               Constants.userFields.petFriendly: petFriendly,
               Constants.userFields.smokeOrNot: smokeOrNot,
        ]
    }
}

extension User: UserSerializable {
    init?(dictionary :[String: Any]){
        guard let dateOfBirth = dictionary[Constants.userFields.birth] as? String,
        let age       = dictionary[Constants.userFields.age]  as? Int,
        let email     = dictionary[Constants.userFields.emailField] as? String ,
        let gender    = dictionary[Constants.userFields.gender] as? String ,
        let firstName = dictionary[Constants.userFields.firstname] as? String ,
        let lastName  = dictionary[Constants.userFields.lastname] as? String ,
        let petFriendly = dictionary[Constants.userFields.petFriendly] as? Bool ,
        let smokeOrNot  = dictionary[Constants.userFields.smokeOrNot] as? Bool ,
        let location    = dictionary[Constants.userFields.locationStr] as? [String:Any] ,
        let expectedRentUpper = dictionary[Constants.userFields.expectedRentUpper] as? Int ,
        let expectedRentLower = dictionary[Constants.userFields.expectedRentLower] as? Int
        else{
            return nil
            
        }
        self.init(email: email, gender: gender, firstName: firstName,  lastName: lastName, dateOfBirth: dateOfBirth, age: age, location: location, expectedRentUpper: expectedRentUpper, expectedRentLower: expectedRentLower, petFriendly: petFriendly, smokeOrNot: smokeOrNot)
    }
}
