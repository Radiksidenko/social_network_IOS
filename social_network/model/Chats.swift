//
//  Chats.swift
//  social_network
//
//  Created by Radomyr Sidenko on 31.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import Foundation
import UIKit

class Chats {
    var id: String!
    var nameChat: String?
    var chatPhoto: UIImage?
    
    init(chatId: String, nameChaValuet: String, chatPhotoValue: UIImage!) {
        id = chatId
        nameChat = nameChaValuet
        chatPhoto = chatPhotoValue
    }
}
