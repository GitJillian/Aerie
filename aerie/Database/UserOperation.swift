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
    
    // add new pid to user's post string array
    func addUserPost(userEmail: String, pid: String, completion:@escaping(Bool) -> ()){
        updateUserDocument(userEmail: userEmail, data: [self.userFields.postings: FieldValue.arrayUnion([pid])]){ result in
            completion(result)
        }
    }
    
    //remove pid from user's post string array
    func removeUserPost(userEmail: String, pid: String, completion:@escaping(Bool) -> ()){
        updateUserDocument(userEmail: userEmail, data: [self.userFields.postings: FieldValue.arrayRemove([pid])]){ result in
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
    
    func getUserPostNumber(email: String, completion:@escaping(Int) ->()){
        isUserFieldExist(documentName: email, fieldName: self.userFields.postings){ result in
            if result{
                self.getUserDocument(documentName: email) {data in
                    let posts = data[self.userFields.postings] as! [String]
                    completion(posts.count)
                    }
            }
            else{
                completion(0)
            }
            
        }
    }
    
    func getUserPosts(email: String, completion:@escaping([String]) -> ()){
        getUserDocument(documentName: email){data in
            completion(data[self.userFields.postings] as! [String])
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
                let dateOfBirth = data[self.userFields.birth] as? String ?? ""
                let age       = data[self.userFields.age]  as? Int ?? 0
                let email     = data[self.userFields.emailField] as? String ?? ""
                let gender    = data[self.userFields.gender] as? String ?? "male"
                let firstName = data[self.userFields.firstname] as? String ?? ""
                let lastName  = data[self.userFields.lastname] as? String ?? ""
                let petFriendly = data[self.userFields.petFriendly] as? Bool ?? false
                let smokeOrNot  = data[self.userFields.smokeOrNot] as? Bool ?? false
                let location    = data[self.userFields.locationStr] as? String ?? ""
                let expectedRentUpper = data[self.userFields.expectedRentUpper] as? Int ?? 0
                let expectedRentLower = data[self.userFields.expectedRentLower] as? Int ?? 0
                let expectedLocation  = data[self.userFields.expectedLocation] as? String ?? ""
                let postings = data[self.userFields.postings] as? [String] ?? []
                
                // TODO: FIX OBJECTIDENTIFIER ERROR TOMORROW
                return User(email: email, gender: gender, firstName: firstName,  lastName: lastName, expectedLocation: expectedLocation, dateOfBirth: dateOfBirth, age: age, location: location, expectedRentUpper: expectedRentUpper, expectedRentLower: expectedRentLower, petFriendly: petFriendly, smokeOrNot: smokeOrNot,  postings: postings)
            
            }
        }
    }
    func getUserDocument( documentName: String, completion:@escaping([String:Any])->()) {
        let userCollection = database.collection(Constants.dbNames.userDB)
        getDocument(documentName: documentName, collectionRef: userCollection){(data) in
            completion(data)
            
        }
    }
}
