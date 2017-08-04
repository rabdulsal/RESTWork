//
//  UserService.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import Alamofire

class UserService {
    
    static var users = [UserEntity]()
    static var albums = [AlbumEntity]()
    static var photos = [PhotoEntity]()
    static var posts = [PostEntity]()
    static var comments = [CommentEntity]()
    static var top3FriendPosts: [PostEntity] {
        var topPosts = [PostEntity]()
        for (idx, user) in self.users.enumerated() {
            if idx == 3 { break }
            if let posts = user.posts {
                 topPosts.append(posts.first!)
            }
        }
        return topPosts
    }
    static var dataUpdatedCallback: (()->Void)?
    
    static func loadAllData() {
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
                            
                            self.mergeAllData()
                        })
                    })
                })
            })
        }
    }
}

fileprivate extension UserService {
    // Posts
    static func getPostsRequest(completion: ((_ albums: [PostEntity])->Void)?) {
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON { response in
            
            var posts = [PostEntity]()
            if let json = response.result.value as? [[String:Any]] {
                for postsDict in json {
                    let post = PostEntity(postDict: postsDict)
                    posts.append(post)
                }
            }
            
            if let cmpltn = completion {
                cmpltn(posts)
            }
        }
    }
    
    // Comments
    static func getCommentsRequest(completion: ((_ comments: [CommentEntity])->Void)?=nil) {
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON { response in
            
            var comments = [CommentEntity]()
            if let json = response.result.value as? [[String:Any]] {
                for commentsDict in json {
                    let comment = CommentEntity(commentDict: commentsDict)
                    comments.append(comment)
                }
            }
            
            if let cmpltn = completion {
                cmpltn(comments)
            }
        }
    }
    
    // Users
    static func getUsersRequest(completion: ((_ albums: [UserEntity])->Void)?=nil) {
        Alamofire.request("https://jsonplaceholder.typicode.com/users").responseJSON { response in
            
            var users = [UserEntity]()
            if let json = response.result.value as? [[String:Any]] {
                print("JSON: \(json)") // serialized json response
                for userDict in json {
                    let user = UserEntity(userJSON: userDict)
                    users.append(user)
                }
            }
            if let cmpltn = completion {
                cmpltn(users)
            }
        }
    }
    
    // Albums
    static func getAlbumsRequest(completion: ((_ albums: [AlbumEntity])->Void)?=nil) {
        Alamofire.request("https://jsonplaceholder.typicode.com/albums").responseJSON { response in
            
            var albums = [AlbumEntity]()
            if let json = response.result.value as? [[String:Any]] {
                for albumDict in json {
                    let album = AlbumEntity(albumDict: albumDict)
                    albums.append(album)
                }
            }
            
            if let cmpltn = completion {
                cmpltn(albums)
            }
        }
    }
    
    //Photos
    static func getPhotosRequest(completion: ((_ photos: [PhotoEntity])->Void)?=nil) {
        Alamofire.request("https://jsonplaceholder.typicode.com/photos").responseJSON { response in
            
            var photos = [PhotoEntity]()
            if let json = response.result.value as? [[String:Any]] {
                for photoDict in json {
                    let photo = PhotoEntity(photoDict: photoDict)
                    photos.append(photo)
                }
            }
            
            if let cmpltn = completion {
                cmpltn(photos)
            }
        }
    }
    
    static func mergeAllData() {
        
        // Merge comments -> posts
        for post in self.posts {
            post.comments = comments.filter { $0.postId == post.id }
        }
        
        // Merge posts -> users
        for user in self.users {
            user.posts = self.posts.filter { $0.userId == user.id }
        }
        
        // Merge photos -> albums
        for album in self.albums {
            album.photos = self.photos.filter { $0.albumId == album.id }
        }
        
        // Merge albums -> users
        for user in self.users {
            user.albums = self.albums.filter { $0.userId == user.id }
        }
        
        if let callback = dataUpdatedCallback {
            print("Top Friend Posts count:", top3FriendPosts.count)
            callback()
        }
    }
}
