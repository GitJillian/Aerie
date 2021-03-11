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
    
    
    @IBOutlet var backBtn : UIBarButtonItem!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func backToHome(){
        self.dismiss(animated: true, completion: nil)
        
    }
}
