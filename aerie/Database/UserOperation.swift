//
//  UserOperation.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/27.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserOperation:DBOperation{
    //initialize the database and collections
    
    var db_name = Constants.dbNames.userDB
    //check whether a user exists in user collection and return a bool value
    func isUserExist(documentName: String, completion:@escaping(Bool)->()){
        let userCollection = super.database.collection(db_name)
        isDocumentExist(documentName: documentName, collection: userCollection){(result) in
            completion(result)
        }
    }
    
    func isUserFieldExist(documentName: String,fieldName: String, completion:@escaping(Bool)->()){
        let userCollection = super.database.collection(db_name)
        isFieldExist(documentName: documentName, collectionRef: userCollection, fieldName: fieldName){result in
            completion(result)
        }
    }
    
    
    //this is used to set or add Document data with given userEmail as its unique id. Note: this operation will overwrite the whole data
    func addSetUserDocument(userEmail:String, data: Dictionary<String, Any>, completion:@escaping(Bool)->()){
        let userCollection = super.database.collection(db_name)
        addSetDocument(documentName: userEmail, data: data, collectionRef: userCollection ){(result) in
            completion(result)
        }
    }
    
    //this is used to update existing user fields without changing the whole data
    func updateUserDocument(userEmail:String, data: Dictionary<String, Any>, completion:@escaping(Bool) ->()){
        let userCollection = super.database.collection(db_name)
        updateDocument(documentName: userEmail, data: data, collectionRef: userCollection){ result in
            completion(result)
        }
    }

    
    func getUserFirstName(email:String, completion: @escaping(String) -> ()){
        getUserDocument(documentName: email) { (data) in
            let firstName = data[self.userFields.firstname] as! String
            completion(firstName.capitalizingFirstLetter())
        }
    }
    
    func getUserLastName(email:String, completion: @escaping(String) -> ()){
        getUserDocument(documentName: email) { (data) in
            let lastName = data[self.userFields.lastname] as! String
            completion(lastName.capitalizingFirstLetter())
        }
    }
    
    func getUserFullName(email: String, completion: @escaping(String) -> ()){
        getUserDocument(documentName: email) { (data) in
            let firstName = data[self.userFields.firstname] as! String
            let lastName = data[self.userFields.lastname] as! String
            completion(firstName.capitalizingFirstLetter()+" "+lastName.capitalizingFirstLetter())
        }
    }
    
    func getUserGender(email: String, completion: @escaping(String) ->()){
        getUserDocument(documentName: email){ data in
            completion(data[self.userFields.gender] as! String)
        }
    }
    
    func getUserBirthDate(email: String, completion:@escaping(String) -> ()){
        getUserDocument(documentName: email){ data in
            completion(data[self.userFields.birth] as! String)
        }
    }
    
    func getAllUsers(completion:@escaping([User]) ->()){
        let userCollection = super.database.collection(db_name)
        userCollection.addSnapshotListener{(querySnapShot, err) in
            guard let documents = querySnapShot?.documents else{
                return
            }
            var users:[User] = []
            for document in documents{
            
                let data      = document.data()
                let dateOfBirth = data[self.userFields.birth] as? String ?? ""
                let age       = data[self.userFields.age]  as? Int ?? 0
                let email     = data[self.userFields.emailField] as? String ?? ""
                let gender    = data[self.userFields.gender] as? String ?? "male"
                let firstName = data[self.userFields.firstname] as? String ?? ""
                let lastName  = data[self.userFields.lastname] as? String ?? ""
                let petFriendly = data[self.userFields.petFriendly] as? Bool ?? false
                let smokeOrNot  = data[self.userFields.smokeOrNot] as? Bool ?? false
                let location    = data[self.userFields.locationStr] as? [String:Any] ?? [String:Any]()
                let expectedRentUpper = data[self.userFields.expectedRentUpper] as? Int ?? 0
                let expectedRentLower = data[self.userFields.expectedRentLower] as? Int ?? 0
                
                // TODO: FIX OBJECTIDENTIFIER ERROR TOMORROW
                let user = User(email: email, gender: gender, firstName: firstName,  lastName: lastName, dateOfBirth: dateOfBirth, age: age, location: location, expectedRentUpper: expectedRentUpper, expectedRentLower: expectedRentLower, petFriendly: petFriendly, smokeOrNot: smokeOrNot)
                users.append(user)
            
            }
            self.users = users
            completion(users)
        }
    }
    
    func getUserDocument( documentName: String, completion:@escaping([String:Any])->()) {
        let userCollection = database.collection(Constants.dbNames.userDB)
        getDocument(documentName: documentName, collectionRef: userCollection){(data) in
            completion(data)
            
        }
    }
}
