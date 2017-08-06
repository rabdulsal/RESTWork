//
//  PostDetailsViewController.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class PostDetailsViewController : UIViewController {
    
    enum PostSections : Int {
        case content = 0
        case comments
        
        static var count : Int {
            return comments.rawValue + 1
        }
    }
    
    enum Identifiers : String {
        case postBodyID       = "PostBodyCellID"
        case commentCellID    = "CommentCellID"
        case composeCommentID = "CommentComposeIdentifier"
    }
    
    @IBOutlet weak var authorImage: FriendProfileImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            commentsTableView.delegate = self
            commentsTableView.dataSource = self
            commentsTableView.estimatedRowHeight = 200
            commentsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var post: PostEntity!
    
    fileprivate var replyingComment: CommentEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = post.author.avatarThumbURL {
            authorImage.imageFromServerURL(urlString: url)
        }
        postTitleLabel.text = post.title.uppercased()
        postAuthorLabel.text = post.author.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.dramaFeverRed()]
        let composeCommentVC = navVC.viewControllers.first as! ComposeCommentViewController
        composeCommentVC.delegate = self
        composeCommentVC.originalComment = replyingComment!
    }
    
}

extension PostDetailsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = PostSections(rawValue: indexPath.section) else { return 0.0 }
        
        switch section {
        case .content: return UITableViewAutomaticDimension
        case .comments:
            guard let _ = post.comments else { return 0.0 }
            return UITableViewAutomaticDimension
        }
    }
}

extension PostDetailsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = PostSections(rawValue: section) else { return 0 }
        
        switch section {
        case .content: return 1
        case .comments:
            return self.post.comments?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = PostSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .content:
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.postBodyID.rawValue) as! PostContentCell
            cell.postBodyLabel.text = post.body
            return cell
        case .comments:
            if let comments = post.comments {
                let c = tableView.dequeueReusableCell(withIdentifier: Identifiers.commentCellID.rawValue) as! PostCommentCompleteCell
                c.delegate = self
                c.cellIndexPath = indexPath
                let comment = comments[indexPath.row]
                c.configureCell(with: comment, and: self)
                return c
            } else {
                return UITableViewCell()
            }
        }
    }
}

extension PostDetailsViewController : PostCommentable {
    
    func didPressReplyButton(for comment: CommentEntity) {
        
        replyingComment = comment
        performSegue(withIdentifier: Identifiers.composeCommentID.rawValue, sender: nil)
    }
}

extension PostDetailsViewController : CommentComposable {
    func didFinishComposing(comment: CommentEntity) {
        //
    }
}
