//
//  Conversation.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/5.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import Foundation
struct Conversation {
    let id:   String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
