//
//  FriendDashboardViewController.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit

class FriendDashboardViewController : UIViewController {
    
    enum DashboardSections : Int {
        case topPosts = 0
        case topPhotos
        
        static var count : Int {
            return topPhotos.rawValue + 1
        }
    }
    
    enum DashboardIdentifiers : String {
        case friends          = "FriendsCellID"
        case topPosts         = "PostCellID"
        case photoDetail      = "PhotoDetailSegue"
        case photosCarouselID = "PhotosCarouselCellID"
        case postDetailsID    = "PostDetailsVCID"
        case mapVCSegue       = "MapVCSegue"
    }
    
    @IBOutlet weak var profileImageView: FriendProfileImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.ralewayBold(20)
        }
    }
    @IBOutlet weak var dashboardTableView: UITableView! {
        didSet {
            dashboardTableView.delegate = self
            dashboardTableView.dataSource = self
        }
    }
    
    
    var friend: UserEntity!
    var posts = [PostEntity]()
    var selectedPhoto: PhotoEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = friend.name
        profileImageView.imageFromServerURL(urlString: friend.avatarURL!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifier = segue.identifier,
            let _segue = DashboardIdentifiers(rawValue: identifier) else { return }
        
        switch _segue {
        case .photoDetail:
            let navVC = segue.destination as! UINavigationController
            navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.dramaFeverRed()]
            let photoDetailVC = navVC.viewControllers.first as! PhotoDetailViewController
            photoDetailVC.photo = selectedPhoto
        case .mapVCSegue:
            let navVC = segue.destination as! UINavigationController
            navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.dramaFeverRed()]
            let friendMapVC = navVC.viewControllers.first as! MapsViewController
            friendMapVC.friend = friend
        default: break
        }
    }
    
    @IBAction func pressedActionButton(_ sender: Any) {
        performSegue(withIdentifier: DashboardIdentifiers.mapVCSegue.rawValue, sender: nil)
    }
    
}

extension FriendDashboardViewController : UITableViewDelegate {
    
}

extension FriendDashboardViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DashboardSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = DashboardSections(rawValue: section) else { return 0 }
        
        switch section{
        case .topPosts: return 3
        case .topPhotos: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = DashboardSections(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .topPosts: return 137
        case .topPhotos: return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = DashboardSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .topPosts:
            let cell = tableView.dequeueReusableCell(withIdentifier: DashboardIdentifiers.topPosts.rawValue) as! AbbreviatedPostCell
            let post = friend.posts![indexPath.row]
            
            cell.configureView(with: post, and: self)
            return cell
        case .topPhotos:
            let cell = tableView.dequeueReusableCell(withIdentifier: DashboardIdentifiers.photosCarouselID.rawValue) as! PhotosCarouselTableCell
            let photos = self.friend.photos!
            cell.configureCarousel(with: photos, and: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = DashboardSections(rawValue: section) else { return nil }
        
        switch section {
        case .topPosts: return "\(self.friend.name)'s Top Posts"
        case .topPhotos: return "\(self.friend.name)'s Top Photos"
        }
    }
}

extension FriendDashboardViewController : AbbreviatedPostViewDelegate {
    func didPressMoreButton(post: PostEntity) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postDetailVC = storyboard.instantiateViewController(withIdentifier: DashboardIdentifiers.postDetailsID.rawValue) as! PostDetailsViewController
        postDetailVC.post = post
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}

extension FriendDashboardViewController : PhotoCarouselSelectable {
    
    func selectedPhoto(photo: PhotoEntity) {
        selectedPhoto = photo
        performSegue(withIdentifier: DashboardIdentifiers.photoDetail.rawValue, sender: nil)
    }
}

