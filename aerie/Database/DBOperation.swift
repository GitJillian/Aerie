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
    
    
    /**********JUDGING WHETHER A USER EXISTS IN THE COLLECTION REFERENCE************/
    
    //check whether a field exists in a document, given name and field name
    func isFieldExist(documentName: String, collectionRef: CollectionReference, fieldName: String, completion: @escaping(Bool)->()){
        getDocument(documentName: documentName, collectionRef: collectionRef){ data in
                let fieldExists = data[fieldName] != nil
                completion(fieldExists)
        }
    }
    
    //check whether a document exists with given collection reference
    func isDocumentExist(documentName:String, collection:CollectionReference, completion: @escaping(Bool)->()){
        
        let docRef = collection.document(documentName)
        docRef.getDocument{
            (document, error) in
            if let document = document, document.exists{
                completion(true)
            }
            else{
                completion(false)
                }
            }
        }
    
    /**********ADDING/SETTING DATA TO  THE SPECIFIC COLLECTION REFERENCE************/
    
    func addDocument(data: Dictionary<String, Any>, collectionRef: CollectionReference, completion:@escaping(Bool, String) -> ()){
        var docRef : DocumentReference? = nil
        docRef = collectionRef.addDocument(data: data){err in
            if let err = err{
                completion(false, "")
                print(err)
            }else{
                completion(true, docRef!.documentID)
            }
        }
    }
    
    // if a document already exists, set the values with given dictionary
    // if a document is not created, would be created by calling setData() method
    func addSetDocument(documentName:String, data: Dictionary<String,Any>, collectionRef: CollectionReference, completion:@escaping(Bool) ->()){
        
        collectionRef.document(documentName).setData(data){
            err in
            if err != nil{
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func updateDocument(documentName: String, data: Dictionary<String, Any>, collectionRef: CollectionReference, completion:@escaping(Bool) -> ()){
        collectionRef.document(documentName).updateData(data){err in
            if let err = err{
                print("error updating document: \(err)")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    /**********GETTING A DOCUMENT REFERENCE IN THE COLLECTION REFERENCE WITH GIVEN DOCUMENT NAME************/
    func getDocument(documentName: String, collectionRef: CollectionReference, completion: @escaping([String:Any]) -> ()){
        collectionRef.document(documentName)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                return
              }
              guard let data = document.data() else {
                return
              }
                completion(data)
            }
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
