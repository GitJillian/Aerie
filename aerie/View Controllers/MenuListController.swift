//
//  MenuListController.swift
//  aerie
//
//  Created by jillianli on 2021/2/22.
//  Copyright © 2021 Yejing Li. All rights reserved.
//  Controlls Three menu items, including Profile, Setting, Sign Out 

import Foundation
import UIKit
protocol MenuControllerDelegate{
    func didSelectMenuItem(ItemName:SideMenuItem)
}
enum SideMenuItem: String, CaseIterable{
    case profile  = "Profile"
    case yourPost = "Your Post"
    case signOut  = "Sign Out"
    case back     = "Back"
}
class MenuListController: UITableViewController{
    
    public var delegate:MenuControllerDelegate?
    
    private let MenuItems : [SideMenuItem]
    
    init(with MenuItems:[SideMenuItem]){
        self.MenuItems = MenuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:"cell")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Constants.Colors.white
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return MenuItems.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuItems[indexPath.row].rawValue
        cell.textLabel?.textColor = Constants.Colors.tiffany
        cell.backgroundColor = Constants.Colors.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        //Relate to delegate about menu item selection
        let selectedItem = MenuItems[indexPath.row]
        delegate?.didSelectMenuItem(ItemName: selectedItem)
    }
    
}
