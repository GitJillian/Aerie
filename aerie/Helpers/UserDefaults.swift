//
//  UserDefaults.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/11.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
extension UserDefaults{
    static func contains(_ key: String) -> Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
