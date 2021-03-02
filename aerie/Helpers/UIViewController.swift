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
}
