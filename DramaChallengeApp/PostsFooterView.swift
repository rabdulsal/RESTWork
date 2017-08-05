//
//  PostsFooterView.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/5/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol PostsFooterViewSelectable {
    func didSelectSeeAll()
}

class PostsFooterView : UITableViewHeaderFooterView {
    
    var delegate: PostsFooterViewSelectable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.dramaFeverGrey()
    }
    
    @IBAction func pressedSeeAllButton(_ sender: Any) {
        delegate?.didSelectSeeAll()
    }
    
}

