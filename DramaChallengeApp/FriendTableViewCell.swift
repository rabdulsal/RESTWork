//
//  FriendTableViewCell.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class FriendTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    func configureContactCell(friend: UserEntity) {
        contactNameLabel.text = "\(friend.name)"
//        if let iData = contact.imageData {
//            contactImageView.image = UIImage(data: iData)
//            contactImageView.roundedCorners()
//        }
    }
}
