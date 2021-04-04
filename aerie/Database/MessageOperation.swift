//
//  MessageOperation.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/4.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import FirebaseFirestore

class MessageOperation: DBOperation{
    let messageDB = Constants.dbNames.messageDB
    public func createNewConversation(with otherUserEmail: String, firstMessage: Message, completion: @escaping(Bool)->()){
        let currentEmail:String = firstMessage.sender.senderId
        
        let ref = super.database.collection(messageDB)
        var data = [String:Any]()
        
        data["sentDate"]  = firstMessage.sentDate
        data["content"]   = firstMessage.content
        data["sender"]    = firstMessage.sender.senderId
        data["messageId"] = firstMessage.messageId
        
        addSetDocument(documentName: "\(currentEmail)", data: data, collectionRef: ref){
            result in
            completion(result)
        }
        
    }
}
