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
import SDWebImage

class MessageViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let currentUser = Sender(senderId:    UserDefaults.standard.value(forKey: "email") as! String,
                             displayName: UserDefaults.standard.value(forKey: "username") as? String ?? "self")
    var otherUserObj: User!
    var messages = [MessageType]()
    var messageOperation = MessageOperation()
    private var imagePickerController   = UIImagePickerController()
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
        return isFromCurrentSender(message: message) ? UIColor.init(named: "hintText")! : .secondarySystemBackground
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    //When use press send button this method is called.
        
    let message = Message(content: text,
                          sender: currentUser,
                          receiver: Sender(senderId:   otherUserObj.email,
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
           // messageInputBar.inputTextView.becomeFirstResponder()
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
    
    //used to load avatar for sender and receiver
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        
        if sender.senderId == currentUser.senderId{
            
            let uid = UserDefaults.standard.value(forKey: "uid") as! String
            let path = "image/\(uid)_avatar"
            let fireStorage = FireStorage()
            fireStorage.loadAvatarByPath(path: path){data in
                if !data.isEmpty{
                    let image = UIImage(data: data)
                    avatarView.image = image
                }
            }
            
        }else{
            
           let userOperation = UserOperation()
            userOperation.getUidByEmail(email: otherUserObj.email){
                uid in
                
                let path = "image/\(uid)_avatar"
                let fireStorage = FireStorage()
                fireStorage.loadAvatarByPath(path: path){data in
                    if !data.isEmpty{
                        let image = UIImage(data: data)
                        avatarView.image = image
                    }
                }
                
            }
        }
    }
    
    //set up buttons and input bar
    func setupInputButton() {
            let button = InputBarButtonItem()
            button.setSize(CGSize(width: 35, height: 35), animated: false)
            button.setImage(UIImage(systemName: "paperclip"), for: .normal)
            button.onTouchUpInside { [weak self] _ in
                    self?.selectPicture()
                }
            messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
            messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        }
    
    
    
    //dismiss the message controller itself
    @IBAction func dissMiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
            guard let message = message as? Message else {
                return
            }

            switch message.kind {
            case .photo(let media):
                imageView.sd_setImage(with: media.url, completed: nil)
            default:
                break
            }
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    func selectPicture(){
    //enable user to select picture
       
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate   = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            let firestorage = FireStorage()
            let messageID = UUID().uuidString
            
            let path  = "message/\(messageID)"
            
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
                return
            }
            guard let imageData = image.pngData() else{
                return
            }
            
            
            firestorage.uploadToCloud(pngData: imageData, refPath: path){result1 in
                if result1{
                    
                    firestorage.getURLByPath2(path: path){
                        url in
                        
                        let media = Media(url:url,
                                      image: nil,
                                      placeholderImage: UIImage(named:
                                        "ava")!,
                                      size: CGSize(width: 100, height: 100))
                        let message = Message(content:   url.absoluteString,
                                          sender:    self.currentUser,
                                          receiver:  Sender(senderId:   self.otherUserObj.email,
                                                            displayName:"\(self.otherUserObj.firstName) \(self.otherUserObj.lastName)"),
                                          messageId: messageID,
                                          sentDate:  Date(),
                                          kind:      .photo(media))
                        
                        self.imagePickerController.dismiss(animated: true){
                        self.insertNewMessage(message)
                                
                        self.save(message)
                        self.messagesCollectionView.scrollToLastItem(animated: true)
                            
                        }
                    }
                }
            }
        }
    }
