//
//  Message.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/5.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import MessageKit
import Foundation
import FirebaseFirestore
struct Sender: SenderType{
    var senderId:    String
    var displayName: String
}

struct Message: MessageType{
    var content:   String
    var sender:    SenderType
    var receiver:  SenderType
    var messageId: String
    var sentDate:  Date
    var kind:      MessageKind
    var dict:      [String:Any]{
        
        return ["content" :     content,
                "senderName":   sender.displayName,
                "senderId"  :   sender.senderId,
                "receiverName": receiver.displayName,
                "receiverId":   receiver.senderId,
                "messageId":    messageId,
                "sentDate":     sentDate,
                "kind":         kind.messageKindString]
    }
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

extension Message{
    init(message: Dictionary<String, Any>){
        
        let ts = message["sentDate"] as! Timestamp
        content = message["content"] as? String ?? ""
        sender  = Sender(senderId:   message["senderId"] as! String,
                         displayName:message["senderName"] as! String)
        receiver = Sender(senderId: message["receiverId"] as! String,
                          displayName: message["receiverName"] as! String)
        messageId = message["messageId"] as! String
        sentDate  = ts.dateValue()
        
        switch (message["kind"] as! String){
            
            case "text":
                kind = .text(content)
            case "photo":
               
                let media = Media(url: URL(string: content),
                                      image: nil,
                                      placeholderImage: UIImage(named: "ava")!,
                                      size: CGSize(width: 150, height: 150))
                kind = .photo(media)
                
            default:
                kind = .text("sometext")
        }//todo: initialize photo type and emoji type
    }
}
extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .photo(_):
            return "photo"
        default:
            return "text"
        }
    }
}
