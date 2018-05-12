//
//  Post.swift
//  social_network
//
//  Created by Radomyr Sidenko on 12.05.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var userPhoto: UIImage?
    var usernickname: String!
    var message: String!
    var postPhoto: UIImage?
    
    init(userPhotoValue: UIImage!, usernicknameValue: String, messageValue: String, postPhotoValue: UIImage!) {
        userPhoto = userPhotoValue
        usernickname = usernicknameValue
        message = messageValue
        postPhoto = postPhotoValue
    }
}
