//
//  AbbreviatedPostCell.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class AbbreviatedPostCell : UITableViewCell {
    
    @IBOutlet weak var postView: AbbreviatedPostView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureView(with post: PostEntity, and delegate: AbbreviatedPostViewDelegate) {
        postView.delegate = delegate
        postView.titleLabel.text = post.title.uppercased()
        postView.bodyLabel.text = post.body
        postView.post = post
    }
    
}
