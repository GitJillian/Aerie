//
//  ProfileViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/2/23.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController{
    
    private   var alert:       UIAlertController!
    @IBOutlet var nameField:   UILabel!
    @IBOutlet var avatar:      UIImageView!
    @IBOutlet var firstName:   UITextView!
    @IBOutlet var lastName:    UITextView!
    @IBOutlet var priceRange:  UISlider!
    @IBOutlet var petFriendly: UISwitch!
    @IBOutlet var smokeOrNot:  UISwitch!
    @IBOutlet var confirmBtn:  UIButton!
    @IBOutlet var scrollView:  UIScrollView!
    @IBOutlet var backBtn:     UIBarButtonItem!
    var email:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmBtn?.layer.cornerRadius = CGFloat(12)
        scrollView?.isScrollEnabled = true
        
    }
    @IBAction func backToHome(){
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func submitProfile(){
        
    }
}
