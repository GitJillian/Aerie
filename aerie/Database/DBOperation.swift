//
//  DBOperation.swift
//  aerie
//
//  Created by 液晶宝宝 on 2021/1/13.
//  Copyright Yejing Li. All rights reserved.
//  Encapsulate all cloud firestore database operations, including read, write, delete, update

import Foundation
import Firebase

class DBOperation: ObservableObject{
    
    
    //initialize the database and collections
    var database = Firestore.firestore()
    
    @Published var users = [User]()
    @Published var posts = [Post]()
    public var userFields = Constants.userFields.self
    
    func DBOperation(){
    }
    
    
    /**********JUDGING WHETHER A USER EXISTS IN THE COLLECTION REFERENCE************/
    
    
    
    //check whether a post exists in post collection and return a bool value
    func isPostExist(documentName: String) -> Bool{
        let postCollection = database.collection(Constants.dbNames.postDB)
        return isDocumentExist(documentName: documentName, collection: postCollection)
    }
    
    //check whether a document exists with given collection reference
    func isDocumentExist(documentName:String, collection:CollectionReference) ->Bool{
        var flag = true
        let docRef = collection.document(documentName)
        docRef.getDocument{
            (document, error) in
            if let document = document, document.exists{
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")            }
            else{
                print("Document does not exist")
                flag = false
            }
        }
        return flag
                
        }
    
    /**********ADDING/SETTING DATA TO  THE SPECIFIC COLLECTION REFERENCE************/
    
    // if a document already exists, set the values with given dictionary
    // if a document is not created, would be created by calling setData() method
    func addSetDocument(documentName:String, data: Dictionary<String,Any>, collectionRef: CollectionReference) ->Bool{
        var flag = true
        collectionRef.document(documentName).setData(data){
            err in
            if err != nil{
                flag = false
            }else{
            }
        }
        return flag
    }
    
    
    
    //this is used to set or add Document data with given pid as its unique id
    func addSetPostDocument(pid:String, data: Dictionary<String, Any>)->Bool{
        let postCollection = database.collection(Constants.dbNames.postDB)
        let addPostResult = addSetDocument(documentName: pid, data: data, collectionRef: postCollection )
        return addPostResult
    }
    
    
    
    /**********GETTING A DOCUMENT REFERENCE IN THE COLLECTION REFERENCE WITH GIVEN DOCUMENT NAME************/
    /*func getDocument(documentName: String, collectionRef: CollectionReference) -> DocumentReference{
        let docRef = collectionRef.document(documentName)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                //error fetching document
                //print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                //document is empty
                //print("Document data was empty.")
                return
              }
              print("Current data: \(data)")
            } as! DocumentReference
        return docRef
    }*/
    func getDocument(documentName: String, collectionRef: CollectionReference)-> DocumentReference{
    let docRef = collectionRef.document(documentName)

    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
        } else {
            print("Document does not exist")
            return
        }
    }
        return docRef
    }
    
    
    
    
    func getPostDocument( documentName: String ) -> DocumentReference {
        let postCollection = database.collection(Constants.dbNames.postDB)
        return getDocument(documentName: documentName, collectionRef: postCollection)
    }
     
    /**********SEARCHING A DOCUMENT REFERENCE IN THE COLLECTION REFERENCE WITH GIVEN DOCUMENT NAME************/
        func searchByEqualField(field: String, value: Any, collectionRef: CollectionReference, completion:@escaping((_ querySnapshot:[QueryDocumentSnapshot]) -> ())){
        
        //let g = DispatchGroup()
        collectionRef.whereField(field, isEqualTo: value).getDocuments(){(querySnapshot, err) in
            //g.enter()
            if let err = err{
                print("error getting documents\(err)")
                //g.leave()
            }
            else{
                if let documents = querySnapshot?.documents{
                    completion(documents)
                }
                //return nil
                //g.notify(queue: .main){completion(querySnapshot!.documents)}
            }
        }
        
    }
   
   
    
}
