//
//  Post.swift
//  aerie
//
//  Created by 液晶宝宝 on 2021/1/13.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation

struct Post{
    
    var pid: String
    var uid: String
    var description: String
    var timestamp:   Date
    var budget:      Int
    
    var dictionary: [String: Any]{
        return[Constants.postFields.pidField:     pid,
               Constants.postFields.uidField:     uid,
               Constants.postFields.description:  description,
               Constants.postFields.timeStamp:    timestamp,
               Constants.postFields.budget   :    budget
        ]
    }
}
