//
//  MenuListController.swift
//  aerie
//
//  Created by Gitjillian on 2021/2/22.
//  Copyright © 2021 Yejing Li. All rights reserved.
//  Controlls Three menu items, including Profile, Setting, Sign Out 

import Foundation
import UIKit
protocol MenuControllerDelegate{
    func didSelectMenuItem(ItemName:SideMenuItem)
}

//enumerate items with strings
enum SideMenuItem: String, CaseIterable{
    case profile  = "Profile"
    case yourPost = "Your Post"
    case signOut  = "Sign Out"
    case back     = "Home"
}


class MenuListController: UITableViewController{
    
    public var delegate:MenuControllerDelegate?
    
    private let MenuItems : [SideMenuItem]
    
    init(with MenuItems:[SideMenuItem]){
        self.MenuItems = MenuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:"basicStyle")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //initializing the view and tableView
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 50,left: 5,bottom: 0,right: 0)
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor(named:"menuBack")
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return MenuItems.count
    }
    
    // setting cells respectively
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cellName = MenuItems[indexPath.row].rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        
        cell.textLabel?.text = cellName
        cell.textLabel?.textColor = UIColor(named:"menuFont")
        cell.backgroundColor      = UIColor(named:"menuBack")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        //Relate to delegate about menu item selection
        let selectedItem = MenuItems[indexPath.row]
        delegate?.didSelectMenuItem(ItemName: selectedItem)
    }
    
}
