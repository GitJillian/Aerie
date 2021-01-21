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

class HomeViewController: UITabBarController {
    var userView: ListView!
    var email:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        userView.onAppear()
    }
    
}
