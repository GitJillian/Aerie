//
//  EditPostViewController.swift
//  aerie
//
//  Created by jillianli on 2021/3/27.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var setDesiredLocationBtn: UIButton!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var expectedLocationLabel: UILabel!
    @IBOutlet weak var budgetText: UITextField!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    var pid: String!
    var postOperation = PostOperation()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedElseWhere()
        descriptionField?.delegate = self
        
        setDesiredLocationBtn?.addTarget(self, action: #selector(setDesiredlocationClicked), for: .touchUpInside)
        descriptionField?.layer.borderWidth = CGFloat(1.5)
        descriptionField?.layer.borderColor = UIColor(named: "menuBack")?.cgColor
        descriptionField?.layer.cornerRadius = CGFloat(10)
        descriptionField?.layer.masksToBounds = true
        self.pid = UserDefaults.standard.value(forKey: "pidManage") as? String
        postOperation.getPostDocument(pid: self.pid){document in
            let budget = document[Constants.postFields.budget] as! Int
            let expectedLocation = document[Constants.postFields.expectedLocation] as! [String: Any]
            self.expectedLocationLabel?.text = expectedLocation["title"] as? String
            self.budgetText?.text = "\(budget)"
            self.descriptionField?.text = document[Constants.postFields.description] as? String
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.adjustTextFieldWhenEditing()
    }
    
    @objc func setDesiredlocationClicked(){
        
        UserDefaults.standard.setValue("expectedLocation", forKey: "locationType")
        let sb:UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let initialBoard = sb.instantiateViewController(withIdentifier: "MapVC") as! MapViewController
        self.present(initialBoard, animated: true, completion: nil)
    }

    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPostChange(_ sender: Any) {
        if validateFields(){
            var data = [String: Any]()
            let budgetStr   = budgetText?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let budget      = Int(budgetStr)
            let description = descriptionField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            data[Constants.postFields.budget]      = budget
            data[Constants.postFields.description] = description
            postOperation.updatePostDocument(pid: pid, data: data){result in
                let alert = UIAlertController()
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                if result{
                    alert.title = "Successfully changed your post."
                }else{
                    alert.title = "Fail to change your post."
                }
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func validateFields() -> Bool{
        let description: String = descriptionField?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
       
        let budget     : String = budgetText?.text?.trimmingCharacters(in: .whitespacesAndNewlines)          ?? ""
        
        let desiredLocation: String = expectedLocationLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if description.count < 10{
            return false
        }
        if description == "" || budget == "" || desiredLocation == ""{
            return false
        }
        if (NumberFormatter().number(from: budget) == nil){
            return false
        }
        return true
    }

}
