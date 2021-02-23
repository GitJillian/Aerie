//
//  UserOperation.swift
//  aerie
//
//  Created by jillianli on 2021/1/27.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import Firebase

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
    var profilePic: Bool
    var postings:[Post]
    // TODO: Add GOOGLE MAP API
    
}

class UserOperation:DBOperation{
    //initialize the database and collections
    
    var db_name = Constants.dbNames.userDB
    //check whether a user exists in user collection and return a bool value
    func isUserExist(documentName: String) -> Bool{
        let userCollection = super.database.collection(db_name)
        return super.isDocumentExist(documentName: documentName, collection: userCollection)
    }
    
    //this is used to set or add Document data with given userEmail as its unique id
    func addSetUserDocument(userEmail:String, data: Dictionary<String, Any>)->Bool{
        let userCollection = super.database.collection(db_name)
        let addUserResult = super.addSetDocument(documentName: userEmail, data: data, collectionRef: userCollection )
        return addUserResult
    }
    
    func getUserName(email:String, completion: @escaping(String) -> ()){
        let userCollection = super.database.collection(db_name)
        userCollection.document(email).getDocument { (doc, err) in
            guard let user = doc else{return}
            let username = user.data()?[self.userFields.firstname] as! String
            completion(username)
        }
    }
    
    func getAllUsers(){
        let userCollection = super.database.collection(db_name)
        userCollection.addSnapshotListener{(querySnapShot, err) in
            guard let documents = querySnapShot?.documents else{
                return
            }
            self.users = documents.map {(QueryDocumentSnapshot)-> User in
                
                let data      = QueryDocumentSnapshot.data()
                let age       = data[self.userFields.age]  as? Int ?? 0
                let email     = data[self.userFields.emailField] as? String ?? ""
                let gender    = data[self.userFields.gender] as? String ?? "male"
                let firstName = data[self.userFields.firstname] as? String ?? ""
                let lastName  = data[self.userFields.lastname] as? String ?? ""
                let petFriendly = data[self.userFields.petFriendly] as? Bool ?? false
                let smokeOrNot  = data[self.userFields.smokeOrNot] as? Bool ?? false
                let expectedRentUpper = data[self.userFields.expectedRentUpper] as? Int ?? 0
                let expectedRentLower = data[self.userFields.expectedRentLower] as? Int ?? 0
                let expectedLocation  = data[self.userFields.expectedLocation] as? String ?? ""
                let profileUploaded   = data[self.userFields.isProfileUploaed] as? Bool ?? false
                let postings = data[self.userFields.postings] as? [Post] ?? []
                // TODO: FIX OBJECTIDENTIFIER ERROR TOMORROW
                return User(email: email, gender: gender, firstName: firstName,  lastName: lastName, expectedLocation: expectedLocation, age: age, expectedRentUpper: expectedRentUpper, expectedRentLower: expectedRentLower, petFriendly: petFriendly, smokeOrNot: smokeOrNot, profilePic: profileUploaded,postings: postings)
            
            }
        }
    }
    func getUserDocument( documentName: String ) -> DocumentReference {
        let userCollection = database.collection(Constants.dbNames.userDB)
        return getDocument(documentName: documentName, collectionRef: userCollection)
    }
}
