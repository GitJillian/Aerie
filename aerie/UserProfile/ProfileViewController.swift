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
    @IBOutlet var emailField:  UILabel!
    @IBOutlet var imageView:   UIImageView!
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
        imageView?.layer.masksToBounds = false
        imageView?.layer.borderColor = UIColor.white.cgColor
        imageView?.layer.cornerRadius = imageView.frame.height / 2
        imageView?.clipsToBounds = true
        
        //setting avatars by pulling firebase storage data
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string:urlString) else{
                    return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else{
                self.imageView?.image = UIImage(named: "ava")
                return
            }
            //adding the task to the main thread
            DispatchQueue.main.async {
                let image = UIImage(data:data)
                self.imageView?.image = image
            }
        })
        task.resume()
        
        nameField?.text  = UserDefaults.standard.value(forKey: "username") as? String
        emailField?.text = UserDefaults.standard.value(forKey: "email") as? String
    }
    @IBAction func backToHome(){
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func submitProfile(){
        
    }
}
