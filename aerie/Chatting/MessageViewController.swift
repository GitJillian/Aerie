//
//  ChatViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/4.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView
struct Sender: SenderType{
    var senderId: String
    var displayName: String
}
struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class MessageViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    let currentUser = Sender(senderId: "self", displayName: "You")
    var otherUserObj: User!
    var messages = [MessageType]()
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.row]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            messageInputBar.inputTextView.becomeFirstResponder()
            //if let conversationId = conversationId {
             //   listenForMessages(id: conversationId, shouldScrollToBottom: true)
           // }
      //  }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(otherUserObj.firstName) \(otherUserObj.lastName)"
        self.hideKeyboardWhenTappedElseWhere()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
               
        messageInputBar.delegate = self
        setupInputButton()
        
    }
    func setupInputButton() {
            let button = InputBarButtonItem()
            button.setSize(CGSize(width: 35, height: 35), animated: false)
            button.setImage(UIImage(systemName: "paperclip"), for: .normal)
            
            messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
            messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        }
    
    @IBAction func dissMiss(){
        self.dismiss(animated: true, completion: nil)
    }

}
