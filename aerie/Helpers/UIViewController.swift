//
//  UIViewController.swift
//  aerie
//
//  Created by GitJillian on 2021/2/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//  This is an extension for UIViewController -- it hides the keyboard when user clicks on somewhere else in the screen.

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedElseWhere() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func adjustTextFieldWhenEditing(){
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -190 // Move view 190 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}
