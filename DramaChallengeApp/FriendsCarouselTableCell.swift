//
//  FriendsCarouselTableCell.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/4/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol FriendCarouselSelectable {
    func didSelectFriend(friend: UserEntity)
}

class FriendsCarouselTableCell : UITableViewCell {
    
    @IBOutlet weak var carousel: UICollectionView! {
        didSet {
            carousel.delegate = self
            carousel.dataSource = self
        }
    }
    
    var friends: [UserEntity]!
    var delegate: FriendCarouselSelectable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.dramaFeverGrey()
    }
    
    func configureCarousel(with friends: [UserEntity], and delegate: FriendCarouselSelectable) {
        self.friends = friends
        self.delegate = delegate
        carousel.reloadData()
    }
}

extension FriendsCarouselTableCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let friend = friends[indexPath.row]
        delegate?.didSelectFriend(friend: friend)
    }
}

extension FriendsCarouselTableCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionCellID", for: indexPath) as! FriendsCarouselCollectionCell
        let friend = friends[indexPath.row]
        cell.friendImageView.imageFromServerURL(urlString: friend.avatarThumbURL!)
        return cell
    }
}
