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
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping(Bool)->()){
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentName = UserDefaults.standard.value(forKey: "username") as? String else{return}
        let ref = super.database.collection(messageDB)
        let messageDate = firstMessage.sentDate
        let dateString  = Date.toString(messageDate)
        var message     = ""
        
    }
}
