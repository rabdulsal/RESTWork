//
//  UIButton+Extension.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/5/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class DFBasicClearButton : UIButton {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        tintColor = UIColor.dramaFeverRed()
        titleLabel?.font = UIFont.ralewayRegular(14)
    }
}
