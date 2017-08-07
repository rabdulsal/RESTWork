//
//  PhotoDetailViewController.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailViewController : UIViewController {
    
    @IBOutlet weak var photoTitle: DFTitleLabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: PhotoEntity!
    
    
    @IBAction func pressedCloseButton(_ sender: Any) {
        dismissSelf()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.dramaFeverGrey()
        self.photoTitle.text = photo.title.uppercased()
        self.photoImageView.imageFromServerURL(urlString: photo.urlString)
    }
}
