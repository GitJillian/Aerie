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


class MessageViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    let currentUser = Sender(senderId: String.safeEmail(emailAddress: UserDefaults.standard.value(forKey: "email") as! String),
                             displayName: UserDefaults.standard.value(forKey: "username") as? String ?? "self")
    var otherUserObj: User!
    var messages = [MessageType]()
    var messageOperation = MessageOperation()
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? .green: .secondarySystemBackground
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    //When use press send button this method is called.
        
    let message = Message(content: text,
                          sender: currentUser,
                          receiver: Sender(senderId:   String.safeEmail(emailAddress: otherUserObj.email),
                                           displayName:"\(otherUserObj.firstName) \(otherUserObj.lastName)"),
                          messageId:UUID().uuidString,
                          sentDate: Date(),
                          kind:.text(text))
        //TODO: enable other types such as emoji / photo
        //calling function to insert and save message
        insertNewMessage(message)
        save(message)
        //clearing input field
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    private func loadConversation(otherUserEmail: String){
        self.messages.removeAll()
        messageOperation.getChatByUser(with: String.safeEmail(emailAddress: otherUserEmail)){listOfChats in
            self.messages = listOfChats
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
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
        messageDB.sendMessageToCollection(with: otherUserObj.email, message: message){
            result in
            if !result{
                return
            }
            self.messagesCollectionView.scrollToLastItem(animated: true)
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
        messageInputBar.sendButton.setTitleColor(.darkGray, for: .normal)
        messageInputBar.inputTextView.placeholder = "message"
        self.navigationItem.title = "\(otherUserObj.firstName) \(otherUserObj.lastName)"
        self.hideKeyboardWhenTappedElseWhere()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
               
        messageInputBar.delegate = self
        messageInputBar.autoresizesSubviews=true
        setupInputButton()
        loadConversation(otherUserEmail: otherUserObj.email)
        
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
