//
//  SearchMapControllerViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/16.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchMapControllerDelegate: AnyObject{
    func searchMapController(_ vc: SearchMapController, didSelectLocationWith location: Location?)
}
class SearchMapController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: SearchMapControllerDelegate?
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Set Your Location"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        view.addSubview(field)
        view.addSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
        field.delegate = self
        self.hideKeyboardWhenTappedElseWhere()
    }
    
    private let field : UITextField = {
        let field = UITextField()
        field.placeholder = "Enter location"
        field.layer.cornerRadius = 9
        field.backgroundColor = .tertiarySystemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height: 50))
        field.leftViewMode = .always
        return field
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cells.normalCell)
        return table
    }()
    
    var locations = [Location]()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x:10, y:10, width: label.frame.size.width, height: label.frame.size.height)
        field.frame = CGRect(x:10, y:20 + field.frame.size.height, width: view.frame.size.width-20, height:50)
        let tableY: CGFloat = field.frame.origin.y + field.frame.size.height + 5
        tableView.frame = CGRect(x:0, y:tableY, width: view.frame.size.width, height: view.frame.size.height-tableY)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        if let text = field.text, !text.isEmpty {
            LocationManager.shared.findLocations(with: text) { [weak self] locations in
                DispatchQueue.main.async{
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cells.normalCell, for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .secondarySystemBackground
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.textLabel?.textColor = UIColor(named: "hintText")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //notify map controller to show pin at selected place
        let place = locations[indexPath.row]
        
        
        delegate?.searchMapController(self,
                                      didSelectLocationWith: place)
        var placeToDict : [String: Any] = [String: Any]()
        placeToDict["title"] = place.title
        
        placeToDict["locationDict"] = place.locationDict
        var field : String = ""
        var message: String = ""
        let setLocationType = UserDefaults.standard.value(forKey: "locationType") as! String
        if setLocationType == "userLocation"{
            field   = Constants.userFields.locationStr
            message = Constants.Texts.setLocation
        }
        else{
            field   = Constants.postFields.expectedLocation
            message = Constants.Texts.setExpectedLocation
        }
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {action in
            
            let uid = UserDefaults.standard.value(forKey: "uid") as! String
            
                let userOperation = UserOperation()
                userOperation.updateUserDocument(uid: uid, data: [field: placeToDict]){ result in
                    if !result{
                        return
                    }
                }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        ))
        self.present(alert, animated: true, completion: nil)
        
        }
    
}
