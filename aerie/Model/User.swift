//
//  User.swift
//  aerie
//
//  Created by 液晶宝宝 on 2021/1/13.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//
import Foundation
struct User: Identifiable{
    
    var id: String = UUID().uuidString
    var email: String
    var gender: String
    
    var firstName: String
    var lastName: String
    var expectedLocation: String
    
    var age: Int
    var expectedRentUpper: Int
    var expectedRentLower: Int
    
    var petFriendly: Bool
    var smokeOrNot: Bool
    
    var postings:[Post]
    // TODO: Add GOOGLE MAP API
    
}
