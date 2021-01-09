//
//  ButtonStyler.swift
//  Aerie
//
//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.

import Foundation
import UIKit

class Styler {
    
    static func styleTextField(_ textfield:UITextField, _ color: CGColor) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: Constants.BottomLine.absoluteX, y: textfield.frame.height - Constants.BottomLine.verticalHeight, width: textfield.frame.width, height: Constants.BottomLine.verticalHeight)
        bottomLine.backgroundColor = color
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton, _ fillColor: UIColor, _ borderColor: CGColor? = nil , _ borderWidth: CGFloat? = nil, _ alpha:CGFloat? = 1) {
        
        // Filled rounded corner style
        button.backgroundColor = fillColor
        button.layer.cornerRadius = Constants.Buttons.buttonCornerRadius
        button.layer.borderWidth = CGFloat(borderWidth ?? 0)
        button.layer.borderColor = borderColor
        button.alpha = alpha ?? 1
        
    }
    
    static func setBackgroundWithPic(_ view: UIView, _ imagePath: String){
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: imagePath)?.draw(in: view.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            view.backgroundColor = UIColor(patternImage: image)
    }

}
