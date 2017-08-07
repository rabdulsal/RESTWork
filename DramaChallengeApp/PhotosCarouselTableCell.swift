//
//  PhotosCarouselTableCell.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/4/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoCarouselSelectable {
    func selectedPhoto(photo: PhotoEntity)
}

class PhotosCarouselTableCell : UITableViewCell {
    
    
    @IBOutlet weak var carousel: UICollectionView! {
        didSet {
            carousel.delegate = self
            carousel.dataSource = self
        }
    }
    
    var photos: [PhotoEntity]!
    var delegate: PhotoCarouselSelectable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCarousel(with photos: [PhotoEntity], and delegate: PhotoCarouselSelectable) {
        self.photos = photos
        self.delegate = delegate
        carousel.reloadData()
    }
}

extension PhotosCarouselTableCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = self.photos[indexPath.row]
        delegate?.selectedPhoto(photo: photo)
    }
}

extension PhotosCarouselTableCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCellID", for: indexPath) as! PhotosCarouselCollectionCell
        let photo = photos[indexPath.row]
        cell.photoImageView.imageFromServerURL(urlString: photo.thumbURLString)
        return cell
    }
}
