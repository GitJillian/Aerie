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
    private var email:String!
    lazy var menuBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "line.horizontal.3.decrease")?.withRenderingMode(.alwaysOriginal),style:.done,target:self,action: #selector(didTapMenu))
    private var menu : SideMenuNavigationController?
    private var profileController = ProfileViewController()
    private var ownPostController = OwnPostViewController()
    private var signoutController = SignOutViewController()
    
    @IBOutlet weak var NameField: UILabel!
    
    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        self.navigationController?.navigationBar.isTranslucent = true
        
        
        let tabBar = self.tabBarController as! HomeViewController
        self.email = tabBar.email
        self.NameField.text = tabBar.userName
        
        Styler.setBackgroundWithColor(self.view, Constants.Colors.tiffany)
        menuBarButtonItem.tintColor = Constants.Colors.white
        let menuList = MenuListController(with:SideMenuItem.allCases)
        menuList.delegate = self
        self.menu = SideMenuNavigationController(rootViewController: menuList)
        // making menu for the left side on User Home view
        self.menu?.leftSide = true
        menuBarButtonItem.tintColor = Constants.Colors.white
        //navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        self.menu?.setNavigationBarHidden(true, animated: false)
        
        self.navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        SideMenuManager.default.leftMenuNavigationController = self.menu
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        self.addChildControllers()
        
        
            
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
