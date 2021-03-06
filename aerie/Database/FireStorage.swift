//
//  FireStorage.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/11.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit
class FireStorage{
    var storageRef = Storage.storage().reference()
    
    // download the resources from the url path from firestorage
    func getUrlByPath(path: String, completion:@escaping(String)->()){
        let fileRef = storageRef.child(path)
        fileRef.downloadURL(completion: { url, err in
            if err != nil{
                return
            }else{
                UserDefaults.standard.set(url?.absoluteString, forKey: "url")
                completion(url!.absoluteString)
            }
        })
    }
    
    func getURLByPath2(path: String, completion:@escaping(URL) -> ()){
        let fileRef = storageRef.child(path)
        fileRef.downloadURL(completion: { url, err in
            if err != nil{
                return
            }else{
                
                completion(url!)
            }
        })
    }
    
    
    //uploads local file with fileurl to the fire storage path
    func uploadToCloud(pngData: Data, refPath: String, completion:@escaping(Bool) -> ()){
        
        
        let photoRef   = storageRef.child(refPath)
         photoRef.putData(pngData,
                          metadata:nil) {(metadata, err) in
                                          guard err == nil else{
                                                    completion(false)
                                                    return
                                                                }
            photoRef.child(refPath).downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteString
                UserDefaults.standard.setValue(urlString, forKey: "url")
            })
            completion(true)
        }
    }
    
    func loadAvatarByPath(path: String, completion:@escaping(Data) ->()){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let ref = storageRef.child(path)
        ref.getData(maxSize: 15*1024*1024){ data, err in
            if let err = err{
                print("\(err.localizedDescription)")
                completion(Data())
                return
            }
            else{
                completion(data!)
                    
            }
        }
    }
}

