//
//  PostVC.swift
//  aerie
//
//  Created by Gitjillian on 2021/1/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
import SwiftUI
class PostVC: BaseVC{
    
    var email:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        init_interface()
    }
    
    func init_interface(){
        Styler.setBackgroundWithColor(self.view, Constants.Colors.tiffany)
    }
    
}
