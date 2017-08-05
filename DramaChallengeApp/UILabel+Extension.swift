//
//  UILabel+Extension.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/5/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class DFHeroLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont.ralewayExtraBold(24)
    }
}

class DFTitleLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont.ralewayBold(20)
    }
}

class DFSubTitleLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont.ralewayHeavy(18)
    }
}

class DFBasicContentLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont.ralewayRegular(14)
    }
}

class DFAuthorLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont.ralewayLight(14)
    }
}

class DFCommentContentLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont.ralewayLight(12)
    }
}
