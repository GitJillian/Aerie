//
//  ShadowButton.swift
//  aerie
//
//  Created by Gitjillianli on 2021/3/23.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

        private var shadowLayer: CAShapeLayer!

        override func layoutSubviews() {
            super.layoutSubviews()

            if shadowLayer == nil {
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 15).cgPath
                shadowLayer.fillColor = UIColor.white.cgColor

                shadowLayer.shadowColor = UIColor.darkGray.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                shadowLayer.shadowOpacity = 0.8
                shadowLayer.shadowRadius = 2

                layer.insertSublayer(shadowLayer, at: 0)
                
            }
        }

}
