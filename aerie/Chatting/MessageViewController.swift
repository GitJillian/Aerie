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
    
    
    var content:String
    var sender:   SenderType
    //var receiver: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}

class MessageViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    let currentUser = Sender(senderId: UserDefaults.standard.value(forKey: "email") as? String ?? "self", displayName: UserDefaults.standard.value(forKey: "username") as? String ?? "self")
    var otherUserObj: User!
    var messages = [MessageType]()
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    //When use press send button this method is called.
        
    let message = Message(content: text,
                              sender: currentUser,
                              //receiver: Sender(senderId: otherUserObj.email, displayName:"\(otherUserObj.firstName) \(otherUserObj.lastName))"),
                              messageId:"123",
                              sentDate: Date(),
                              kind:.text(text)
    )
    //calling function to insert and save message
    insertNewMessage(message)
    save(message)
    //clearing input field
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    private func insertNewMessage(_ message: Message) {
    //add the message to the messages array and reload it
    messages.append(message)
    messagesCollectionView.reloadData()
    DispatchQueue.main.async {
        self.messagesCollectionView.scrollToLastItem(animated: true)
    }
    }
    
    private func save(_ message: Message) {
    //Preparing the data as per our firestore collection
    
    
    let messageDB = MessageOperation()
        messageDB.createNewConversation(with: otherUserObj.email, firstMessage: message){
            result in
            if !result{
                print("cannot create new conversation")
                return
            }
            self.messagesCollectionView.scrollToBottom()
        }
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
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputView?.frame = CGRect(x: 20, y: 600, width: messageInputBar.inputTextView.frame.size.width, height: messageInputBar.inputTextView.frame.size.height
        )
        messageInputBar.sendButton.setTitleColor(.darkGray, for: .normal)
        self.navigationItem.title = "\(otherUserObj.firstName) \(otherUserObj.lastName)"
        self.hideKeyboardWhenTappedElseWhere()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
               
        messageInputBar.delegate = self
        messageInputBar.autoresizesSubviews=true
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
