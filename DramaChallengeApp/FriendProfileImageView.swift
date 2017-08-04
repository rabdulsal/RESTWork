//
//  FriendProfileImageView.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/4/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class FriendProfileImageView : UIImageView {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = layer.frame.width / 2
        clipsToBounds = true
    }
}
