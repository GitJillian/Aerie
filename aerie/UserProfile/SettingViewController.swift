//
//  OwnPostViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/2/23.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import UIKit
import WARangeSlider

class SettingViewController: UIViewController{
    
    
    @IBOutlet var saveBtn :      UIButton!
    @IBOutlet var location:      UITextField!
    @IBOutlet var rangeSlider:   RangeSlider!
    @IBOutlet var priceLabel:    UITextField!
    @IBOutlet var managePostBtn: UIButton!
    @IBOutlet var locationBtn  : UIButton!
    @IBOutlet var petSwitch:     UISwitch!
    @IBOutlet var smokeSwitch:   UISwitch!
    private   var userOperation = UserOperation()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedElseWhere()
        self.navigationController?.navigationBar.isHidden = true
        
        rangeSlider?.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        
        saveBtn?.layer.cornerRadius = CGFloat(10)
        
        //we first read the fields already set in user profile and set them. If not, we are making default settings
        let email = UserDefaults.standard.value(forKey: "email") as! String
        userOperation.getUserDocument(documentName: email){ data in
            //setting rent upper bound and lower bound
            let upperIsSet = data[Constants.userFields.expectedRentUpper] != nil
            let lowerIsSet = data[Constants.userFields.expectedRentLower] != nil
            if  upperIsSet && lowerIsSet{
                let upper = data[Constants.userFields.expectedRentUpper] as! Double
                let lower = data[Constants.userFields.expectedRentLower] as! Double
                self.rangeSlider?.upperValue = upper
                self.rangeSlider?.lowerValue = lower
                self.priceLabel?.text = "\(lower) - \(upper) CAD"
            }
            else if upperIsSet && !lowerIsSet{
                let upper = data[Constants.userFields.expectedRentUpper] as! Double
                self.rangeSlider?.upperValue = upper
                self.rangeSlider?.lowerValue = Double(0)
                self.priceLabel?.text = "0 - \(upper) CAD"
            }
            else if !upperIsSet && lowerIsSet{
                let lower = data[Constants.userFields.expectedRentLower] as! Double
                self.rangeSlider?.upperValue = Double(3000)
                self.rangeSlider?.lowerValue = lower
                self.priceLabel?.text = "\(lower) - 3000 CAD"
            }
            else{
                self.rangeSlider?.upperValue = Double(3000)
                self.rangeSlider?.lowerValue = Double(0)
                self.priceLabel?.text = "Not set"
                
            }
            //setting is pet friendly using UISwitch
            let petFriendlyIsSet = data[Constants.userFields.petFriendly] != nil
            if petFriendlyIsSet{
                let isPetFriendly = data[Constants.userFields.petFriendly] as! Bool
                self.petSwitch?.setOn(isPetFriendly, animated: true)
            }else{
                self.petSwitch?.setOn(true, animated: true)
            }
            //setting is smoking allowed using UISwitch
            let smokeIsSet = data[Constants.userFields.smokeOrNot] != nil
            if smokeIsSet{
                let isSmokeAllowed = data[Constants.userFields.smokeOrNot] as! Bool
                self.smokeSwitch?.setOn(isSmokeAllowed, animated: true)
            }else{
                self.smokeSwitch?.setOn(true, animated: true)
            }
            //setting desired location using String
            let desiredLocationIsSet = data[Constants.userFields.expectedLocation] != nil
            if desiredLocationIsSet{
                let desiredLocation = data[Constants.userFields.expectedLocation] as! String
                self.location?.text = desiredLocation
            }else{
                self.location?.text = "Not Set"
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //when the price is dragged, the text label changes accordingly
    @objc func rangeSliderValueChanged(sender: Any){
        let priceLower = Int(rangeSlider!.lowerValue)
        let priceUpper = Int(rangeSlider!.upperValue)
        let lowerStr   = String(format: "%d", priceLower)
        let upperStr   = String(format: "%d", priceUpper)
        priceLabel?.text = lowerStr + "-" + upperStr
    }
    
    @IBAction func saveProfile(){
        let updatedData    = getUpdatedForm()
        let email          = UserDefaults.standard.value(forKey: "email") as! String
        userOperation.updateUserDocument(userEmail: email, data: updatedData){ result in
            if !result{
                return
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func getUpdatedForm() -> Dictionary<String, Any>{
        var data = Dictionary<String, Any>()
        
        let isPetFriendly  = petSwitch?.isOn
        let isSmokeing     = smokeSwitch?.isOn
        let desireLocation = location?.text
        let minPrice       = Int(rangeSlider!.lowerValue)
        let maxPrice       = Int(rangeSlider!.upperValue)
        
        data[Constants.userFields.petFriendly] = isPetFriendly
        data[Constants.userFields.smokeOrNot]  = isSmokeing
        data[Constants.userFields.expectedLocation] = desireLocation
        data[Constants.userFields.expectedRentLower] = minPrice
        data[Constants.userFields.expectedRentUpper] = maxPrice
        return data
    }
}
