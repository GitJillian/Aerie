//
//  PostOperation.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/20.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import Firebase
class PostOperation:DBOperation{
    
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
    
    //add a post and return its pid and result
    func addPostDocument(data:Dictionary<String, Any>, completion:@escaping(Bool, String)->()){
        let postCollection = database.collection(Constants.dbNames.postDB)
        addDocument(data: data, collectionRef: postCollection){isSuccess, pid in
            completion(isSuccess, pid)
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
                    let post = Post(pid: pid, uid: uid, description: description, timestamp: timeStampDate)
                    posts.append(post)
                }
                completion(posts)
                
                
            }
        }
    }
    
    func getPostUpdates(completion:@escaping(QuerySnapshot) -> ()){
        let postDB = database.collection(Constants.dbNames.postDB)
        postDB.whereField(Constants.postFields.timeStamp, isGreaterThan: Date()).addSnapshotListener{
            querySnapShot, error in
            guard let querySnapShot = querySnapShot, error != nil else{
                return
            }
            completion(querySnapShot)
        }
    }
}
