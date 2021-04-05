//
//  String.swift
//  aerie
//
//  Created by Gitjillian on 2021/2/28.
//  Copyright © 2021 Yejing Li. All rights reserved.
//  String extension -- used for capitialize the first letter

import Foundation


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    static func safeEmail(emailAddress: String) -> String {
            var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
}
