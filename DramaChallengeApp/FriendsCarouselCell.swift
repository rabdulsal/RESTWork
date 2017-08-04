//
//  FriendsCarouselCell.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/4/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class FriendsCarouselTableCell : UITableViewCell {
    
    @IBOutlet weak var carousel: UICollectionView! {
        didSet {
            carousel.delegate = self
            carousel.dataSource = self
        }
    }
    
    var friends: [UserEntity]!
    
    func configureCarousel(with friends: [UserEntity]) {
        self.friends = friends
        
        carousel.reloadData()
    }
}

extension FriendsCarouselTableCell : UICollectionViewDelegate {
    
}

extension FriendsCarouselTableCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionCellID", for: indexPath) as! FriendsCarouselCollectionCell
        
        
        return cell
    }
}
