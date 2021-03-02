//
//  UITabBarController.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/1.
//  Copyright © 2021 Yejing Li. All rights reserved.
//  return the index of chosen tab bar item

import Foundation
import UIKit

extension UITabBarController {
    func getSelectedTabIndex() -> Int? {
        if let selectedItem = self.tabBar.selectedItem {
            return self.tabBar.items?.firstIndex(of: selectedItem)
        }
        return nil
    }
}
