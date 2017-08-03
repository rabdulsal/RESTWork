//
//  FriendsViewController.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/2/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import UIKit
import Alamofire

class FriendsViewController: UIViewController {

    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var userService = UserService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        userService.dataUpdatedCallback = {
            self.reloadView()
        }
        userService.loadAllData()
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

extension FriendsViewController : UITableViewDelegate {
    
}

extension FriendsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userService.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellID") as! FriendTableViewCell
        let friend = self.userService.users[indexPath.row]
        
        cell.configureContactCell(friend: friend)
        return cell
    }
}

