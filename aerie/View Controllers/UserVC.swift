//
//  UserVC.swift
//  aerie
//
//  Created by jillianli on 2021/1/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import SideMenu

class UserVC: UIViewController, MenuControllerDelegate{

    var users: [User] = []
    var email:String = ""
    var userName: String = ""
    
    private var menu : SideMenuNavigationController?
    private var profileController = ProfileViewController()
    private var ownPostController = OwnPostViewController()
    private var signoutController = SignOutViewController()
    
    @IBOutlet weak var NameField: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let userOperation = UserOperation()
        let tabBar = self.tabBarController as! HomeViewController
        self.email = tabBar.email
        Styler.setBackgroundWithColor(self.view, Constants.Colors.tiffany)
        userOperation.getUserName(email: self.email){(name) in
            self.NameField.text = name
        }
        let menuList = MenuListController(with:SideMenuItem.allCases)
        menuList.delegate = self
        menu = SideMenuNavigationController(rootViewController: menuList)
        // making menu for the left side on User Home view
        menu?.leftSide = true
        
        //set navigation bar invisible
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        addChildControllers()

    }
    
    //setting up all child controllers within side menu and add subviews accordingly
    private func addChildControllers(){
        
        addChild(profileController)
        addChild(ownPostController)
        addChild(signoutController)
        
        view.addSubview(profileController.view)
        view.addSubview(ownPostController.view)
        view.addSubview(signoutController.view)
        
        profileController.view.frame = view.bounds
        ownPostController.view.frame = view.bounds
        signoutController.view.frame = view.bounds
        
        profileController.didMove(toParent: self)
        ownPostController.didMove(toParent: self)
        signoutController.didMove(toParent: self)
        
        profileController.view.isHidden = true
        ownPostController.view.isHidden = true
        signoutController.view.isHidden = true
        
    }
    
    // if the button is on click or swiped, show menu
    @IBAction func didTapMenu(){
        present(menu!, animated: true, completion: nil)
        
    }
    
    func didSelectMenuItem(ItemName:SideMenuItem){
        menu?.dismiss(animated: true, completion:nil)
            title = ItemName.rawValue
            switch ItemName{
                case .profile:
                    profileController.view.isHidden = false
                    signoutController.view.isHidden = true
                    ownPostController.view.isHidden = true
                
                case .yourPost:
                    ownPostController.view.isHidden = false
                    profileController.view.isHidden = true
                    signoutController.view.isHidden = true
                    
                case .signOut:
                    signoutController.view.isHidden = false
                    profileController.view.isHidden = true
                    ownPostController.view.isHidden = true
                    
                case .back:
                    signoutController.view.isHidden = true
                    profileController.view.isHidden = true
                    ownPostController.view.isHidden = true
            }
            
        
    }
}
