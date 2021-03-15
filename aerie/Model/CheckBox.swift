//
//  CheckBox.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/15.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    var alternateButton:Array<CheckBox>?
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons() {
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:CheckBox in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setTitleColor(UIColor(named:"hintText"), for: .selected)
                self.layer.borderColor = UIColor(named:"hintText")?.cgColor
            } else {
                self.setTitleColor(UIColor.darkGray, for: .normal)
                self.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
}
