//
//  PhotoEntity.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation

class PhotoEntity {
    var albumId: Int
    var id: Int
    var title: String
    var urlString: String
    var thumbURLString : String
    
    init(photoDict: [String:Any]) {
        albumId = photoDict["albumId"] as? Int ?? -1
        id = photoDict["id"] as? Int ?? -1
        title = photoDict["title"] as? String ?? ""
        urlString = photoDict["url"] as? String ?? ""
        thumbURLString = photoDict["thumbnailUrl"] as? String ?? ""
    }
}

class AlbumEntity {
    var userId: Int
    var id: Int
    var title: String
    var photos: [PhotoEntity]?=nil
    
    init(albumDict: [String:Any]) {
        id = albumDict["id"] as? Int ?? -1
        userId = albumDict["userId"] as? Int ?? -1
        title = albumDict["title"] as? String ?? ""
    }
}

class PostEntity {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    var comments: [CommentEntity]?=nil
    var userService = UserService()
    var author: UserEntity {
        return UserService.users.filter { $0.id == self.userId }.first!
    }
    
    init(postDict: [String:Any]) {
        userId = postDict["userId"] as? Int ?? -1
        id = postDict["id"] as? Int ?? -1
        title = postDict["title"] as? String ?? ""
        body = postDict["body"] as? String ?? ""
    }
    
}

class CommentEntity {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
    var parentPost: PostEntity {
        return UserService.posts.filter { $0.id == self.postId }.first!
    }
    var author: UserEntity {
        return UserService.users.filter { $0.id == self.parentPost.author.id }.first!
    }
    
    convenience init(commentDict: [String:Any]) {
        let postId = commentDict["postId"] as? Int ?? -1
        let id = commentDict["id"] as? Int ?? -1
        let name = commentDict["title"] as? String ?? ""
        let email = commentDict["email"] as? String ?? ""
        let body = commentDict["body"] as? String ?? ""
        self.init(postId: postId, id: id, name: name, email: email, body: body)
    }
    
    init(postId: Int, id: Int, name: String, email: String, body: String) {
        self.postId = postId
        self.id     = id
        self.name   = name
        self.email  = email
        self.body   = body
    }
}
