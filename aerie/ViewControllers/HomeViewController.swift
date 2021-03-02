//
//  HomeViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/6.
//  Copyright Yejing Li. All rights reserved.

import UIKit
import FirebaseAuth
import Firebase
import SideMenu

class HomeViewController: UITabBarController {
    
    var email:String = ""
    var userName:String = ""
    
    //tab bar and tab bar items
    @IBOutlet weak var homeBar: UITabBar!
    private var UserTab: UITabBarItem!
    private var PostTab: UITabBarItem!
    private var ChatTab: UITabBarItem!
    //three view controllers
    private var UserViewControl: UserVC!
    private var PostViewControl: PostVC!
    private var ChatViewControl: ChatVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UserViewControl = UserVC()
        self.PostViewControl = PostVC()
        self.ChatViewControl = ChatVC()
        let leftSwipe  = UISwipeGestureRecognizer(target: self, action: #selector(detectSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(detectSwipes(_:)))
        leftSwipe.direction  = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        self.tabBarController?.delegate = self
        
        setTabBar()
    }
    
    //when user swipes the screen from left to right, we need to switch the tab bar view
    @objc func detectSwipes(_ sender:UISwipeGestureRecognizer){
        let currentIndex = getSelectedTabIndex()!
        
        if sender.direction == .left {
            if currentIndex != 0{
                selectedIndex = (currentIndex - 1)
            }
        }
        else if sender.direction == .right{
            if currentIndex != 2{
                selectedIndex = (currentIndex + 1)
            }
        }
    }
    
    //initializing tab bars
    func setTabBar(){
        
        self.UserTab = (self.homeBar.items?[0])! as UITabBarItem
        self.PostTab = (self.homeBar.items?[1])! as UITabBarItem
        self.ChatTab = (self.homeBar.items?[2])! as UITabBarItem
                
        self.UserTab.title = "Home"
        self.PostTab.title = "Discover"
        self.ChatTab.title = "Chat"
        }
    }


extension HomeViewController : UITabBarControllerDelegate {
    private func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, toVC: UIViewController) -> UIViewControllerAnimatedTransitioning{
        return TabAnimationView()
    }
}
