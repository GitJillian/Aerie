//
//  MessageOperation.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/4.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MessageKit

class MessageOperation: DBOperation{
    let messageDB = Constants.dbNames.messageDB
    
    public func sendMessageToCollection(with receiver:String, message: Message, completion: @escaping(Bool)->()){
        let senderEmail = String.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String)
        let receiverEmail = String.safeEmail(emailAddress: receiver)
        let ref = database.collection(messageDB)
        let data = message.dict
        ref.document(senderEmail).collection(receiverEmail).addDocument(data: data){err in
            if let err = err{
                print(err.localizedDescription)
                completion(false)
            }else{
                ref.document(receiverEmail).collection(senderEmail).addDocument(data: data){ err2 in
                    if let err = err{
                        print(err.localizedDescription)
                        completion(false)
                    }else{
                        completion(true)
                    }
                }
            }
        }
    }
    
    
    public func getChatByUser(with otherEmail: String, completion:@escaping([Message]) -> ()){
        let currentEmail = String.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as!  String)
        let receiverEmail = String.safeEmail(emailAddress: otherEmail)
        let ref = database.collection(messageDB)
        ref.document(currentEmail)
            .collection(receiverEmail)
            .order(by:"sentDate", descending: false)
            .addSnapshotListener(){querySnapshot, err in
            
            if let err = err{
                print(err.localizedDescription)
                completion([])
            }else{
                var messages: [Message] = []
                for document in querySnapshot!.documents{
                    let message = Message(message: document.data())
                    messages.append(message)
                }
                completion(messages)
            }
        }
    }
}
    

