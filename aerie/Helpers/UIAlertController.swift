//
//  UIAlertController.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/22.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit
extension UIAlertController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        pruneNegativeWidthConstraints()
    }

    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
