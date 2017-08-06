//
//  AbbreviatedPostView.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol AbbreviatedPostViewDelegate {
    func didPressMoreButton(post: PostEntity)
}

class AbbreviatedPostView : UIView {
    
    @IBOutlet weak var titleLabel: DFSubTitleLabel! 
    @IBOutlet weak var bodyLabel: DFBasicContentLabel!
    @IBOutlet weak var moreButton: DFBasicClearButton!
    
    
    var contentView: UIView?
    var delegate: AbbreviatedPostViewDelegate?
    var post: PostEntity!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    // IBActions
    
    @IBAction func pressedMoreButton(_ sender: Any) {
        delegate?.didPressMoreButton(post: self.post)
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
