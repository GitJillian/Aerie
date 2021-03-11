//
//  UIImageView.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/10.
//  Copyright © 2021 Yejing Li. All rights reserved.
//


import ImageIO
import UIKit

extension UIImageView {

    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}
