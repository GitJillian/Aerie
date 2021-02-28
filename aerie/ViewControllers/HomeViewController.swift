//
//  HomeViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.

import UIKit
import FirebaseAuth
import Firebase
import SwiftUI
import SideMenu
class HomeViewController: UITabBarController {
    
    var email:String = ""
    var userName:String = ""
    
    private var UserViewControl: UserVC!
    private var PostViewControl: PostVC!
    private var ChatViewControl: ChatVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UserViewControl = UserVC()
        self.PostViewControl = PostVC()
        self.ChatViewControl = ChatVC()
        
    }
    
}
