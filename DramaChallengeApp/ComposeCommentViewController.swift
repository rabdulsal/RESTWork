//
//  ComposeCommentViewController.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/6/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol CommentComposable {
    func didFinishComposing(comment: CommentEntity, indexPath: IndexPath)
}

class ComposeCommentViewController : UIViewController {
    
    @IBOutlet weak var replyToLabel: DFReplyToLabel!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var donebutton: UIBarButtonItem!
    
    
    var originalComment: CommentEntity!
    var composedComment: CommentEntity?
    var indexPath: IndexPath!
    var delegate: CommentComposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.dramaFeverGrey()
        replyToLabel.text = "In reply to \(originalComment.author.name)"
        replyTextView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        replyTextView.becomeFirstResponder()
        donebutton.isEnabled = !replyTextView.text.isEmpty
    }
    
    
    @IBAction func pressedCloseButton(_ sender: Any) {
        dismissSelf()
    }
    
    @IBAction func pressedDoneButton(_ sender: Any) {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let gUser = appDelegate.globalUser else { return }
        
        self.composedComment = CommentEntity(
            postId: originalComment.parentPost.id,
            id: PostsService.baseCommentID + 1,
            name: "\(gUser)'s Comment",
            email: "a@b.com",
            body: replyTextView.text,
            author: gUser)
        delegate?.didFinishComposing(comment: self.composedComment!, indexPath: self.indexPath)
        dismissSelf()
    }
}

extension ComposeCommentViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty == false {
            donebutton.isEnabled = true
        }
    }
}

fileprivate extension ComposeCommentViewController {
    
    func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
