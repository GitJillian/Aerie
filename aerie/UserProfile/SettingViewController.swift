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
    
    @IBOutlet var errorLabel:    UILabel!
    @IBOutlet var saveBtn :      UIBarButtonItem!
    @IBOutlet var location:      UILabel!
    @IBOutlet var rangeSlider:   RangeSlider!
    @IBOutlet var lowerLabel:    UITextField!
    @IBOutlet var upperLabel:    UITextField!
    @IBOutlet var petBool:       UILabel!
    @IBOutlet var smokeBool:     UILabel!
    @IBOutlet var locationBtn  : UIButton!
    @IBOutlet var petSwitch:     UISwitch!
    @IBOutlet var smokeSwitch:   UISwitch!
    @IBOutlet var backView:      UIView!
    private   var userOperation = UserOperation()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                // Always adopt a light interface style.
                overrideUserInterfaceStyle = .light
            }
        UserDefaults.standard.setValue("expectedLocation", forKey: "locationType")
        
        
        self.hideKeyboardWhenTappedElseWhere()
        errorLabel?.textColor = UIColor(named:"buttonText")
        errorLabel?.alpha = 0
        //if the range slider has been changed, the text fields should update
        rangeSlider?.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        //if the user directly put price range to textfields, the range slider should update
        lowerLabel?.addTarget(self, action: #selector(lowerInputDidChanged(sender:)), for: .editingDidEnd)
        upperLabel?.addTarget(self, action: #selector(upperInputDidChanged(sender:)), for: .editingDidEnd)
        petSwitch?.addTarget(self, action: #selector(petSwitchChanged(sender:)), for: .touchUpInside)
        smokeSwitch?.addTarget(self, action: #selector(smokeSwitchChanged(sender:)), for: .touchUpInside)
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
                self.lowerLabel?.text = "\(Int(lower))"
                self.upperLabel?.text = "\(Int(upper))"
            }
            else if upperIsSet && !lowerIsSet{
                let upper = data[Constants.userFields.expectedRentUpper] as! Double
                self.rangeSlider?.upperValue = upper
                self.rangeSlider?.lowerValue = Double(0)
                self.lowerLabel?.text = "0"
                self.upperLabel?.text = "\(Int(upper))"
            }
            else if !upperIsSet && lowerIsSet{
                let lower = data[Constants.userFields.expectedRentLower] as! Double
                self.rangeSlider?.upperValue = Double(2000)
                self.rangeSlider?.lowerValue = lower
                self.lowerLabel?.text = "\(Int(lower))"
                self.upperLabel?.text = "2000"
            }
            else{
                self.rangeSlider?.upperValue = Double(2000)
                self.rangeSlider?.lowerValue = Double(0)
                self.lowerLabel?.text = "0"
                self.upperLabel?.text = "2000"

            }
            //setting is pet friendly using UISwitch
            let petFriendlyIsSet = data[Constants.userFields.petFriendly] != nil
            if petFriendlyIsSet{
                let isPetFriendly = data[Constants.userFields.petFriendly] as! Bool
                self.petSwitch?.setOn(isPetFriendly, animated: true)
                if isPetFriendly{
                    self.petBool?.text = "On"
                }else{
                    self.petBool?.text = "Off"
                }
            }else{
                self.petSwitch?.setOn(true, animated: true)
                self.petBool?.text = "On"
            }
            //setting is smoking allowed using UISwitch
            let smokeIsSet = data[Constants.userFields.smokeOrNot] != nil
            if smokeIsSet{
                let isSmokeAllowed = data[Constants.userFields.smokeOrNot] as! Bool
                self.smokeSwitch?.setOn(isSmokeAllowed, animated: true)
                if isSmokeAllowed{
                    self.smokeBool?.text = "On"
                }else{
                    self.smokeBool?.text = "Off"
                }
            }else{
                self.smokeSwitch?.setOn(true, animated: true)
                self.smokeBool?.text = "On"
            }
            //setting desired location using String
            let desiredLocationIsSet = data[Constants.userFields.expectedLocation] != nil
            if desiredLocationIsSet{
                let desiredLocation = data[Constants.userFields.expectedLocation] as! String
                self.location?.text = desiredLocation
            }else{
                self.location?.text = ""
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showError(_ message:String) {
        errorLabel?.text = message
        errorLabel?.alpha = 1
    }
    
    //when the price is dragged, the text label changes accordingly
    @objc func rangeSliderValueChanged(sender: Any){
        let priceLower = Int(rangeSlider!.lowerValue)
        let priceUpper = Int(rangeSlider!.upperValue)
        let lowerStr   = String(format: "%d", priceLower)
        let upperStr   = String(format: "%d", priceUpper)
        lowerLabel?.text = lowerStr
        upperLabel?.text = upperStr
    }
    
    //at least first name and last name cannot be nil
    func validateFields() -> String?{
        if lowerLabel.text?.trimmingCharacters(in: .whitespaces) == "" ||
            upperLabel.text?.trimmingCharacters(in: .whitespaces) == ""
        {
            return Constants.errorMessages.emptyField
        }
        
        else{
            
            let upperValue = lowerLabel.text?.trimmingCharacters(in: .whitespaces)
            let lowerValue = upperLabel.text?.trimmingCharacters(in: .whitespaces)
            if (NumberFormatter().number(from: upperValue!) == nil){
                return "The input value for price is invalid"
            }
            if (NumberFormatter().number(from: lowerValue!) == nil){
                return "The input value for price is invalid"
            }
        }
        return nil
    }
    
    //if user changes the lower value in textfield
    @objc func lowerInputDidChanged(sender : UITextField){
        let priceLower = lowerLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        if let nb = NumberFormatter().number(from: priceLower){
            let priceLowerDouble = nb.doubleValue
            if priceLowerDouble >= 0 {
                errorLabel?.alpha = 0
                rangeSlider?.lowerValue = priceLowerDouble
            }
            else{
                showError("The input value for price is invalid")
            }
        }
    }
    
    //if user changes upper value in textfield
    @objc func upperInputDidChanged(sender: UITextField){
        let priceUpper = upperLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        if let nb = NumberFormatter().number(from: priceUpper){
            let priceUpperDouble = nb.doubleValue
            if priceUpperDouble > 0 {
                errorLabel?.alpha = 0
                rangeSlider?.upperValue = priceUpperDouble
            }
            else{
                showError("The input value for price is invalid")
            }
        }
    }
    
    @objc func petSwitchChanged(sender: UISwitch){
        if petSwitch?.isOn == true{
            petBool?.text = "On"
        }
        else{
            petBool?.text = "Off"
        }
    }
    @objc func smokeSwitchChanged(sender: UISwitch){
        if smokeSwitch?.isOn == true{
            smokeBool?.text = "On"
        }
        else{
            smokeBool?.text = "Off"
        }
    }
    //if user clicks the save profile button, it would update the data to firebase cloud store and diss miss current controller
    @IBAction func saveProfile(){
        
            if validateFields() == nil{
                let updatedData    = getUpdatedForm()
                let email          = UserDefaults.standard.value(forKey: "email") as! String
                userOperation.updateUserDocument(userEmail: email, data: updatedData){ result in
                    if !result{
                        return
                    }else{
                        self.errorLabel?.alpha = 0
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }else{
                showError("The input value for price is invalid")
            }
    }
    
    //getting the updated data and store them into a dictionary
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
