//
//  Post.swift
//  aerie
//
//  Created by 液晶宝宝 on 2021/1/13.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation

//used for sending/managing posts for users
struct Post{
    
    var pid: String
    var uid: String
    var description: String
    var timestamp:   Date
    var budget:      Int
    var expectedLocation: [String: Any]
    var dictionary: [String: Any]{
        return[Constants.postFields.pidField:     pid,
               Constants.postFields.uidField:     uid,
               Constants.postFields.description:  description,
               Constants.postFields.timeStamp:    timestamp,
               Constants.postFields.budget   :    budget,
               Constants.postFields.expectedLocation:expectedLocation
        ]
    }
    
}

//used for viewing posts in post tab
struct PostModel{
    
    var pid: String
    var uid: String
    var description: String
    var timestamp:   Date
    var budget:      Int
    var expectedLocation: [String: Any]
    var userLocation    : [String: Any]
    var userEmail       : String
    var userFullName    : String
    var userAge         : Int
    var userGender      : String
    var petFriendly     : Bool
    var smokeOrNot      : Bool
    
    var dictionary: [String: Any]{
        return [Constants.postModel.pidField:     pid,
                Constants.postModel.uidField:     uid,
                Constants.postModel.description:  description,
                Constants.postModel.timeStamp:    timestamp,
                Constants.postModel.budget   :    budget,
                Constants.postModel.expectedLocation:expectedLocation,
                Constants.postModel.userLocation: userLocation,
                Constants.postModel.userEmail:    userEmail,
                Constants.postModel.userFullName: userFullName,
                Constants.postModel.userAge:      userAge,
                Constants.postModel.userGender:   userGender,
                Constants.postModel.petFriendly:  petFriendly,
                Constants.postModel.smokeOrNot:   smokeOrNot
         ]
    }
}
