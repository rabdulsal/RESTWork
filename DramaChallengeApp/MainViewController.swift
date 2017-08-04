//
//  MainViewController.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/2/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    
    enum MainPageSections : Int {
        case friends = 0
        case topPosts
        
        static var count : Int {
            return topPosts.rawValue + 1
        }
    }
    
    enum MainPageCellIDs : String {
        case friends = "FriendsCellID"
        case topPosts = "PostCellID"
    }
    
    enum MainPageVCIDs : String {
        case friendDashboard = "FriendDashboardViewControllerID"
        case postDetail = "PostDetailsVCID"
        case allPosts = "AllPostsVCID"
    }
    
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
        UserService.loadAllData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadView() {
        friendsTableView.reloadData()
    }
}

extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = MainPageSections.init(rawValue: indexPath.section) else { return }
        
        switch section {
        case .friends: return
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
        case .friends: return 1
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
            let cell = tableView.dequeueReusableCell(withIdentifier: MainPageCellIDs.topPosts.rawValue) as! AbbreviatedPostCell
            let post = UserService.top3FriendPosts[indexPath.row]
            
            cell.configureView(with: post, and: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = MainPageSections.init(rawValue: indexPath.section) else { return 0.0 }
        
        switch section {
        case .friends: return 132
        case .topPosts: return 137
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = MainPageSections.init(rawValue: section) else { return nil }
        
        switch section {
        case .friends: return "Your Friends"
        case .topPosts: return "Top Friends' Posts"
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
}

