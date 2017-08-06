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
        
        replyToLabel.text = "In reply to \(originalComment.author.name)"
        replyTextView.delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        replyTextView.becomeFirstResponder()
        donebutton.isEnabled = !replyTextView.text.isEmpty
    }
    
    
    @IBAction func pressedCloseButton(_ sender: Any) {
        dismissSelf()
    }
    
    @IBAction func pressedDoneButton(_ sender: Any) {
        
        // Construct Comment
        self.composedComment = CommentEntity(
            postId: originalComment.parentPost.id,
            id: 101,
            name: "Rashad's Comment",
            email: "a@b.com",
            body: "This is a test updated comment")
        // Fire Delegate
        delegate?.didFinishComposing(comment: self.composedComment!, indexPath: self.indexPath)
        // Close VC
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
