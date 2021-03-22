//
//  Array.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/20.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}
