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
    static func setBackgroundWithColor(_ view: UIView, _ color: UIColor){
        view.backgroundColor = color
    }
    
    static func setFemaleBtn(_ btn: UIButton){
        btn.backgroundColor = UIColor(red: 0.8863, green: 0.6627, blue: 0.6118, alpha: 1.0)
        btn.setTitle(Constants.genderStr.female, for: .normal)
        btn.layer.cornerRadius = CGFloat(5)
    }
    
    static func setMaleBtn(_ btn: UIButton){
        btn.backgroundColor = UIColor(red: 0.6039, green: 0.7333, blue: 0.8784, alpha: 1.0)
        btn.setTitle(Constants.genderStr.male, for: .normal)
        btn.layer.cornerRadius = CGFloat(5)
    }
    
    static func setPetFriendlyBtn(_ btn: UIButton){
        btn.backgroundColor = UIColor(red: 0.5098, green: 0.7176, blue: 0.6275, alpha: 1.0)
        btn.setTitle("pet", for: .normal)
        btn.layer.cornerRadius = CGFloat(5)
        btn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        btn.imageEdgeInsets.left = -10
    }
    
    static func setPetUnfriendlyBtn(_ btn: UIButton){
        btn.backgroundColor = UIColor(red: 0.5098, green: 0.7176, blue: 0.6275, alpha: 1.0)
        btn.setTitle("pet", for: .normal)
        btn.layer.cornerRadius = CGFloat(5)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.imageEdgeInsets.left = -10
    }
    
    static func setSmokeBtn(_ btn: UIButton){
        btn.backgroundColor = UIColor(red: 0.9294, green: 0.8471, blue: 0.6588, alpha: 1.0)
        btn.setTitle("smoke", for: .normal)
        btn.layer.cornerRadius = CGFloat(5)
        btn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        btn.imageEdgeInsets.left = -10
    }
    
    static func setNonSmokeBtn(_ btn:UIButton){
        btn.backgroundColor = UIColor(red: 0.9294, green: 0.8471, blue: 0.6588, alpha: 1.0)
        btn.setTitle("smoke", for: .normal)
        btn.layer.cornerRadius = CGFloat(5)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.imageEdgeInsets.left = -10
    }
    
    
    
    
    
    

}
