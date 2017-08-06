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
    func didFinishComposing(comment: CommentEntity)
}


class ComposeCommentViewController : UIViewController {
    
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var donebutton: UIBarButtonItem!
    
    
    var originalComment: CommentEntity!
    var composedComment: CommentEntity?
    var delegate: CommentComposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
    }

    
    @IBAction func pressedCloseButton(_ sender: Any) {
        dismissSelf()
    }
    
    @IBAction func pressedDoneButton(_ sender: Any) {
        dismissSelf()
    }
}

fileprivate extension ComposeCommentViewController {
    
    func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
