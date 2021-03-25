//
//  UIView.swift
//  aerie
//
//  Created by jillianli on 2021/3/18.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//

import UIKit
extension UIView {

    func addShadow() {
        layer.cornerRadius = 12
        layer.masksToBounds = true;
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 6.0
        layer.masksToBounds = false
    }
}
