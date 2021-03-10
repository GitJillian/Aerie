//
//  OwnPostViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/2/23.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import UIKit
class SettingViewController: UIViewController{
    
    private var signoutController = SignOutViewController()
    override func viewDidLoad() {
        addChild(signoutController)
        view.addSubview(signoutController.view!)
        self.signoutController.view.frame = view.bounds
        self.signoutController.didMove(toParent: self)
        self.signoutController.view.isHidden = true
        super.viewDidLoad()
    }
    @IBAction func signOut(){
        self.signoutController.showUpDialog()
    }
}
