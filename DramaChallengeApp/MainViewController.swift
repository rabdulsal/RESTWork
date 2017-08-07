//
//  MainViewController.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/2/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit

class MainViewController: UIViewController {
    
    enum MainPageSections : Int {
        case friends = 0
        case topPosts
        case topPhotos
        
        static var count : Int {
            return topPhotos.rawValue + 1
        }
    }
    
    enum MainPageIdentifiers : String {
        case friends          = "FriendsCellID"
        case topPosts         = "PostCellID"
        case photoDetailSegue = "PhotoDetailSegue"
    }
    
    enum MainPageVCIDs : String {
        case friendDashboard = "FriendDashboardViewControllerID"
        case postDetail = "PostDetailsVCID"
        case allPosts = "AllPostsVCID"
        case photoDetail = "PhotoDetailID"
    }
    
    fileprivate var selectedPhoto: PhotoEntity!
    
    @IBOutlet weak var friendsTableView: UITableView! {
        didSet {
            friendsTableView.delegate = self
            friendsTableView.dataSource = self
            friendsTableView.estimatedRowHeight = 137
            friendsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        UserService.dataUpdatedCallback = {
            self.reloadView()
        }
        friendsTableView.register(UINib(nibName: "PostsFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomFooter")
        UserService.loadAllData()
        // Location
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.dramaFeverRed()]
        let photoDetailVC = navVC.viewControllers.first as! PhotoDetailViewController
        photoDetailVC.photo = selectedPhoto
    }
    
    func reloadView() {
        friendsTableView.reloadData()
    }
}

extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MainPageSections.init(rawValue: indexPath.section) else { return }
        
        switch section {
        case .friends, .topPhotos: return
        case .topPosts:
            
            let post = UserService.top3FriendPosts[indexPath.row]
            self.pushToPostDetailView(post: post)
        }
    }
}

extension MainViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainPageSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MainPageSections(rawValue: section) else { return 0 }
        
        switch section {
        case .friends, .topPhotos: return 1
        case .topPosts: return UserService.top3FriendPosts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = MainPageSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .friends:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCarouselCellID") as! FriendsCarouselTableCell
            let friends = UserService.users
            cell.configureCarousel(with: friends, and: self)
            return cell
        case .topPosts:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainPageIdentifiers.topPosts.rawValue) as! AbbreviatedPostCell
            let post = UserService.top3FriendPosts[indexPath.row]
            
            cell.configureView(with: post, and: self)
            return cell
        case .topPhotos:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCarouselCellID") as! PhotosCarouselTableCell
            let photos = UserService.top10FriendPhotos
            cell.configureCarousel(with: photos, and: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = MainPageSections.init(rawValue: indexPath.section) else { return 0.0 }
        
        switch section {
        case .friends: return 132
        case .topPosts: return 137
        case .topPhotos: return 100
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = MainPageSections.init(rawValue: section) else { return nil }
        
        switch section {
        case .friends: return "Friends"
        case .topPosts: return "Friends' Top Posts"
        case .topPhotos: return "Friends' Top Photos" // TODO: Change to Your Top Photos
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let section = MainPageSections(rawValue: section) else { return 0 }
        
        switch section {
        case .friends: return 0
        case .topPosts, .topPhotos: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let _section = MainPageSections(rawValue: section) else { return nil }
        
        switch _section {
        case .friends: return nil
        case .topPosts, .topPhotos:
            let footerView = friendsTableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomFooter") as! PostsFooterView
            footerView.delegate = self
            footerView.tag = section
            return footerView
        }
    }
}

extension MainViewController : FriendCarouselSelectable {
    func didSelectFriend(friend: UserEntity) {
        pushToFriendDashboard(friend: friend)
    }
}

extension MainViewController : AbbreviatedPostViewDelegate {
    func didPressMoreButton(post: PostEntity) {
        pushToPostDetailView(post: post)
    }
}

extension MainViewController : PostsFooterViewSelectable {
    func didSelectSeeAll(for section: Int) {
        guard let _section = MainPageSections(rawValue: section) else { return }
        
        switch _section {
        case .friends: break
        case .topPosts: pushToMapView() // Go to PostsListVC
        case .topPhotos: pushToMapView() // Go to PhotosListVC
        }
    }
}

extension MainViewController : PhotoCarouselSelectable {
    
    func selectedPhoto(photo: PhotoEntity) {
        self.selectedPhoto = photo
        performSegue(withIdentifier: MainPageIdentifiers.photoDetailSegue.rawValue, sender: nil)
    }
}

fileprivate extension MainViewController {
    
    func pushToPostDetailView(post: PostEntity) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postDetailVC = storyboard.instantiateViewController(withIdentifier: MainPageVCIDs.postDetail.rawValue) as! PostDetailsViewController
        postDetailVC.post = post
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    func pushToFriendDashboard(friend: UserEntity) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let friendDashVC = storyboard.instantiateViewController(withIdentifier: MainPageVCIDs.friendDashboard.rawValue) as! FriendDashboardViewController
        friendDashVC.friend = friend
        navigationController?.pushViewController(friendDashVC, animated: true)
    }
    
    func pushToMapView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyboard.instantiateViewController(withIdentifier: "MapVCID") as! MapsViewController
//        mapVC.friend = makeFriendGeoAnnotations()
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func makeFriendGeoAnnotations() -> [MKAnnotation] {
        var annotations = [MKAnnotation]()
        for friend in UserService.users {
            if let address = friend.address { annotations.append(address) }
        }
        return annotations
    }
}

