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
    
    public func isNewChat(with  otherUserEmail: String, completion:@escaping(Bool)->()){
        
        let currentEmail = String.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String)
        let ref = super.database.collection(messageDB)
        let safeOtherEmail = String.safeEmail(emailAddress: otherUserEmail)
        completion(true)
    }
    
    
    
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
    
    //not used but kept in here for further use
    public func sendMessageTo(with otherUserEmail: String, message: Message, completion: @escaping(Bool)->()){
        isNewChat(with: otherUserEmail){isnewchat in
            if isnewchat{
                self.newMessage(with: otherUserEmail, firstMessage: message){result in
                    completion(result)
                }
            }else{
                self.appendToChatList(with: otherUserEmail, message: message){result in
                    completion(result)
                }
            }
        }
    }
    //not used but kept in here for further use
    public func receiverUpdate(with receiverEmail: String, message: Message, completion: @escaping(Bool) ->()){
        let senderEmail = String.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String)
        let ref = database.collection(messageDB)
        let data = message.dict
        addSetDocument(documentName: receiverEmail, data: [senderEmail:data], collectionRef: ref){result in
            completion(result)
        }
    }
    //not used but kept in here for further use
    public func newMessage(with otherUserEmail: String, firstMessage: Message, completion: @escaping(Bool)->()){
        let currentEmail   = String.safeEmail(emailAddress: firstMessage.sender.senderId)
        let safeOtherEmail = String.safeEmail(emailAddress: otherUserEmail)
        let ref = super.database.collection(messageDB)
        let data = firstMessage.dict
        
        addSetDocument(documentName: currentEmail, data: [safeOtherEmail:[data]], collectionRef: ref){
            result in
            if result{
                self.receiverUpdate(with: safeOtherEmail, message: firstMessage){result2 in
                    completion(result2)
                }
            }
            completion(result)
        }
    }
    //not used but kept in here for further use
    public func appendToChatList(with otherUserEmail: String, message: Message, completion: @escaping(Bool)->()){
        let currentEmail = String.safeEmail(emailAddress: message.sender.senderId)
        let safeOtherEmail = String.safeEmail(emailAddress: otherUserEmail)
        let data = message.dict
        let ref = database.collection(messageDB)
        updateDocument(documentName: currentEmail, data: [safeOtherEmail: FieldValue.arrayUnion([data])], collectionRef: ref){result in
            if result{
                
                self.updateDocument(documentName: safeOtherEmail, data: [currentEmail: FieldValue.arrayUnion([data])], collectionRef: ref){result in
                    completion(result)
                }
            }else{
                completion(result)
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
    public func getAllChats(completion:@escaping([Message]) -> ()){
        let currentEmail = String.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as!  String)
        let ref = database.collection(messageDB)
        ref.addSnapshotListener(){querySnapshot, err in
            guard let documents = querySnapshot?.documents else{
                return
            }
            var messages:[Message] = []
            for document in documents {
                let data = document.data()
                
            }
            completion(messages)
        }
    }
    
}
