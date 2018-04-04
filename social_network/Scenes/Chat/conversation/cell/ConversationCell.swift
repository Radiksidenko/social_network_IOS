//
//  ConversationCell.swift
//  social_network
//
//  Created by Radomyr Sidenko on 04.04.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
class ConversationCell: UICollectionViewCell {
    @IBOutlet weak var lastMessege: UILabel!
    @IBOutlet weak var lastMessegeDate: UILabel!
    
    func setup(with lastMessegeText: String, at data: String){
        lastMessege.text = lastMessegeText
        debugPrint("///////////////")
        debugPrint(lastMessegeText)
        lastMessegeDate.text = data
    }
}

