//
//  FireStorage.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/11.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import FirebaseStorage

class FireStorage{
    private var storageRef = Storage.storage().reference()
    
    // download the resources from the url path from firestorage
    func getUrlByPath(path: String, completion:@escaping(URL)->()){
        let fileRef = storageRef.child(path)
        fileRef.downloadURL(completion: { url, err in
            if err != nil{
                return
            }else{
                
                UserDefaults.standard.set(url!.absoluteString, forKey: "url")
                completion(url!)
            }
            
        })
    }
    
    //uploads local file with fileurl to the fire storage path
    func uploadToCloud(fileurl: URL, refPath: String){
        
        
        let photoRef   = storageRef.child(refPath)
        let uploadTask = photoRef.putFile(from:fileurl,
                                          metadata:nil){(metadata, err) in
                                          guard err == nil else{
                                                    return
                                                                }
        }
        uploadTask.resume()
        
    }
}

