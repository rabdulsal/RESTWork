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
    
    var users = [UserEntity]()
    var albums = [AlbumEntity]()
    var photos = [PhotoEntity]()
    var posts = [PostEntity]()
    var comments = [CommentEntity]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        loadAllData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Posts
    func getPostsRequest(completion: ((_ albums: [PostEntity])->Void)?) {
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            var posts = [PostEntity]()
            if let json = response.result.value as? [[String:Any]] {
                for postsDict in json {
                    let post = PostEntity(postDict: postsDict)
                    posts.append(post)
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            if let cmpltn = completion {
                cmpltn(posts)
            }
        }
    }
    
    // Comments
    func getCommentsRequest(completion: ((_ comments: [CommentEntity])->Void)?=nil) {
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            var comments = [CommentEntity]()
            if let json = response.result.value as? [[String:Any]] {
                for commentsDict in json {
                    let comment = CommentEntity(commentDict: commentsDict)
                    comments.append(comment)
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            if let cmpltn = completion {
                cmpltn(comments)
            }
        }
    }
    
    // Users
    func getUsersRequest(completion: ((_ albums: [UserEntity])->Void)?=nil) {
        Alamofire.request("https://jsonplaceholder.typicode.com/users").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            var users = [UserEntity]()
            if let json = response.result.value as? [[String:Any]] {
                print("JSON: \(json)") // serialized json response
                for userDict in json {
                    let user = UserEntity(userJSON: userDict)
                    users.append(user)
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            if let cmpltn = completion {
                cmpltn(users)
            }
        }
    }
    
    // Albums
    func getAlbumsRequest(completion: ((_ albums: [AlbumEntity])->Void)?=nil) {
        Alamofire.request("https://jsonplaceholder.typicode.com/albums").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            var albums = [AlbumEntity]()
            if let json = response.result.value as? [[String:Any]] {
                for albumDict in json {
                    let album = AlbumEntity(albumDict: albumDict)
                    albums.append(album)
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            if let cmpltn = completion {
                cmpltn(albums)
            }
        }
    }
    
    //Photos
    func getPhotosRequest(completion: ((_ photos: [PhotoEntity])->Void)?=nil) {
        Alamofire.request("https://jsonplaceholder.typicode.com/photos").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            var photos = [PhotoEntity]()
            if let json = response.result.value as? [[String:Any]] {
                for photoDict in json {
                    let photo = PhotoEntity(photoDict: photoDict)
                    photos.append(photo)
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            if let cmpltn = completion {
                cmpltn(photos)
            }
        }
    }
    
    func loadAllData() {
        self.getUsersRequest { (users) in
            self.users = users
            self.getAlbumsRequest(completion: { (albums) in
                self.albums = albums
                self.getPhotosRequest(completion: { (photos) in
                    self.photos = photos
                    self.getPostsRequest(completion: { (posts) in
                        self.posts = posts
                        self.getCommentsRequest(completion: { (comments) in
                            self.comments = comments
                            
                            print("Users count:", self.users.count)
                            print("Albums count:", self.albums.count)
                            print("Photos count:", self.photos.count)
                            print("Posts count:", self.posts.count)
                            print("Comments count:", self.comments.count)
                            self.friendsTableView.reloadData()
                        })
                    })
                })
            })
        }
    }
}

extension FriendsViewController : UITableViewDelegate {
    
}

extension FriendsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellID") as! FriendTableViewCell
        let friend = self.users[indexPath.row]
        
        cell.configureContactCell(friend: friend)
        return cell
    }
}

