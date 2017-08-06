//
//  PostCommentCell.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol PostCommentable {
    func didPressReplyButton(for comment: CommentEntity)
}

class PostCommentCompleteCell : PostCommentCell {
    
    @IBOutlet weak var commenterImage: FriendProfileImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var commentReplyButton: DFBasicClearButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellType = .complete
    }
    
    var replyingComment: CommentEntity!
    var delegate: PostCommentable?
//    var indexPath: IndexPath!
    
    @IBAction func pressedReplyButton(_ sender: Any) {
        delegate?.didPressReplyButton(for: self.replyingComment)
    }
    
    func configureCell(with comment: CommentEntity, and delegate: PostCommentable) {
        
        if let url = comment.author.avatarThumbURL {
            self.commenterImage.imageFromServerURL(urlString: url)
        }
        self.replyingComment = comment
        self.body.text = comment.body
    }
    
}

class PostCommentCell : UITableViewCell {
    
    enum CommentCellType : Int {
        
        case complete = 0
        case compose
    }
    
    var cellType: CommentCellType = .compose
    var cellIndexPath: IndexPath = IndexPath(row: 0, section: 0)
}
