//
//  User.swift
//  aerie
//
//  Created by 液晶宝宝 on 2021/1/7.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//

import Foundation


struct User{
    
    var email: String
    var firstName: String
    var lastName: String
    var uid: String
    var age: Int
    var description: String
    var petFriendly: Bool
    var gender: String
    var expectedRentUpper: Int
    var expectedRentLower: Int
    var expectedLocation: String
    var postings:[Post] = []
    // TODO: Add GOOGLE MAP API
    
}

struct Post{
    
    var pid: String
    var uid: String
    var description: String
    var petFriendly: Bool
    var gender: String
    var expectedRentUpper: Int
    var expectedRentLower: Int
    var expectedLocation: String
    
}
