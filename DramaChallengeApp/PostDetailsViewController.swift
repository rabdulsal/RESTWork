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
    
    @IBOutlet weak var authorImage: UIImageView!
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
    
    fileprivate var reuseIdentifiers = ["PostBodyCellID","CommentCellID"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTitleLabel.text = post.title
//        postAuthorLabel.text = post.author.name
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
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifiers[0]) as! PostContentCell
            cell.postBodyLabel.text = post.body
            return cell
        case .comments:
            if let comments = post.comments {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifiers[1]) as! PostCommentCell
                let comment = comments[indexPath.row]
                    cell.body.text = comment.body
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
}
