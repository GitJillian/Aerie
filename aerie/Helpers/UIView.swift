//
//  UIView.swift
//  aerie
//
//  Created by jillianli on 2021/3/18.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//

import UIKit
extension UIView {


  func dropShadow(scale: Bool = true) {
    layer.cornerRadius = CGFloat(10)
    layer.masksToBounds = true
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
