//
//  PostOperation.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/20.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
class PostOperation:DBOperation{
    var postModels = [PostModel]()
    //check whether a post exists in post collection and return a bool value
    func isPostExist(pid: String, completion: @escaping(Bool) -> ()) {
        let postCollection = database.collection(Constants.dbNames.postDB)
        isDocumentExist(documentName: pid, collection: postCollection){(isExist) in
            if !isExist{
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    //this is used to set or add Document data with given pid as its unique id
    func addSetPostDocument(pid:String, data: Dictionary<String, Any>, completion: @escaping(Bool) -> ()){
        let postCollection = database.collection(Constants.dbNames.postDB)
        addSetDocument(documentName: pid, data: data, collectionRef: postCollection ){(addResult) in
            completion(addResult)
        }
    }
    
    //this is used to update existing post fields without changing the whole data
    func updatePostDocument(pid:String, data: Dictionary<String, Any>, completion:@escaping(Bool) ->()){
        let userCollection = super.database.collection(Constants.dbNames.postDB)
        updateDocument(documentName: pid, data: data, collectionRef: userCollection){ result in
            completion(result)
        }
    }
    
    //get a post according to its pid
    func getPostDocument( pid: String, completion:@escaping([String:Any])->()) {
        let postCollection = database.collection(Constants.dbNames.postDB)
        getDocument(documentName: pid, collectionRef: postCollection){(data) in
            completion(data)
        }
    }
    
    
    func getPostsByUser( uid: String, completion:@escaping([Post]) -> ()){
        database.collection(Constants.dbNames.postDB)
            .whereField(Constants.postFields.uidField, isEqualTo: uid)
            .getDocuments(){
                querySnapshot, err in
                if let err = err{
                    print("\(err.localizedDescription)")
                    completion([Post]())
                }else{
                    var posts: [Post] = []
                    let documents = querySnapshot!.documents
                    for document in documents{
                        let data = document.data()
                        let pid  = data[Constants.postFields.pidField] as! String
                        let uid  = data[Constants.postFields.uidField] as! String
                        let description = data[Constants.postFields.description] as! String
                        let timeStamp   = data[Constants.postFields.timeStamp]     as! Timestamp
                        let timeStampDate = timeStamp.dateValue()
                        let budget      = data[Constants.postFields.budget] as! Int
                        let expectedLocation = data[Constants.postFields.expectedLocation] as! [String:Any]
                        let post = Post(pid: pid,
                                        uid: uid,
                                        description: description,
                                        timestamp: timeStampDate,
                                        budget: budget,
                                        expectedLocation: expectedLocation)
                        posts.append(post)
                    }
                    completion(posts)
                }
            }
        
    }
    
    //add a post and return its pid and result
    func addPostDocument(data:Dictionary<String, Any>, completion:@escaping(Bool, String)->()){
        let postCollection = database.collection(Constants.dbNames.postDB)
        addDocument(data: data, collectionRef: postCollection){isSuccess, pid in
            completion(isSuccess, pid)
        }
    }
    
    func getAllPostModels(completion: @escaping([PostModel]) -> ()){
       
        database.collection(Constants.dbNames.postDB).getDocuments(){ querySnapShot, error in
            if let error = error{
                completion([PostModel]())
                print("\(error.localizedDescription)")
                            }else{
                
                let documents = querySnapShot!.documents
                for document in documents{
                    let data = document.data()
                    let pid  = data[Constants.postFields.pidField] as! String
                    let uid  = data[Constants.postFields.uidField] as! String
                    let description = data[Constants.postFields.description] as! String
                    let timeStamp   = data[Constants.postFields.timeStamp]     as! Timestamp
                    let timeStampDate = timeStamp.dateValue()
                    let budget      = data[Constants.postFields.budget] as! Int
                    let expectedLocation = data[Constants.postFields.expectedLocation] as! [String:Any]
                    let userOperation = UserOperation()
                    userOperation.getUserById(documentName: uid){user in
                        let userEmail = user.email
                        let userFullname = "\(user.firstName) \(user.lastName)"
                        let userLocation = user.location
                        let userAge   = user.age
                        let userGender = user.gender
                        let petFriendly = user.petFriendly
                        let smokeOrNot  = user.smokeOrNot
                        let post = PostModel(pid: pid, uid: uid, description: description, timestamp: timeStampDate, budget: budget, expectedLocation: expectedLocation, userLocation: userLocation, userEmail: userEmail, userFullName: userFullname, userAge: userAge, userGender: userGender, petFriendly: petFriendly, smokeOrNot: smokeOrNot)
                        
                        self.postModels.append(post)
                    }
                }
            completion(self.postModels)
            }
        self.postModels.removeAll()
        }
        
    }
    
    //get all posts
    func getAllPosts(completion: @escaping([Post])-> ()){
        database.collection(Constants.dbNames.postDB).getDocuments(){ querySnapShot, error in
            if let error = error{
                print("\(error.localizedDescription)")
            }else{
                var posts: [Post] = []
                let documents = querySnapShot!.documents
                for document in documents{
                    let data = document.data()
                    let pid  = data[Constants.postFields.pidField] as! String
                    let uid  = data[Constants.postFields.uidField] as! String
                    let description = data[Constants.postFields.description] as! String
                    let timeStamp   = data[Constants.postFields.timeStamp]     as! Timestamp
                    let timeStampDate = timeStamp.dateValue()
                    let budget      = data[Constants.postFields.budget] as! Int
                    let expectedLocation = data[Constants.postFields.expectedLocation] as! [String:Any]
                    let post = Post(pid: pid, uid: uid, description: description, timestamp: timeStampDate, budget: budget, expectedLocation: expectedLocation)
                    posts.append(post)
                }
                completion(posts)
            }
        }
    }
    
    
    
    //remove a post using pid
    func removePostByPid(pid: String, completion:@escaping(Bool) -> ()){
        database.collection(Constants.dbNames.postDB).document(pid).delete(){err in
            if let err = err{
                print("error deleting your post, \(err.localizedDescription)")
                completion(false)
            }
            completion(true)
        }
    }
}
