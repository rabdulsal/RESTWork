//
//  UserEntity.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/3/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import MapKit

class UserEntity {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: AddressEntity
    var phone: String
    var website: String
    var company: CompanyEntity
    var albums: [AlbumEntity]? {
        didSet {
            guard
                let photos = albums?.first?.photos,
                let url = photos.first?.urlString,
                let thumbURL = photos.first?.thumbURLString else { return }
            avatarURL = url
            avatarThumbURL = thumbURL
            
            var topPhotos = [PhotoEntity]()
            for (idx, photo) in photos.enumerated() {
                if idx == 10 { break }
                topPhotos.append(photo)
            }
            self.photos = topPhotos
        }
    }
    var posts: [PostEntity]?=nil
    var photos: [PhotoEntity]?
    var avatarURL: String?
    var avatarThumbURL: String?
    
    init(userJSON: [String : Any]) {
        self.id = userJSON["id"] as? Int ?? -1
        self.name = userJSON["name"] as? String ?? ""
        self.username = userJSON["username"] as? String ?? ""
        self.email = userJSON["email"] as? String ?? ""
        let addyJSON = userJSON["address"] as? [String:Any] ?? [:]
        self.address = AddressEntity(title: self.name, addyJSON: addyJSON)
        self.phone = userJSON["phone"] as? String ?? ""
        self.website = userJSON["website"] as? String ?? ""
        let compJSON = userJSON["company"] as? [String:Any] ?? [:]
        self.company = CompanyEntity(compJSON: compJSON)
    }
}

class AddressEntity : NSObject, MKAnnotation {
    var title: String?
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geoSpot: GeoSpot
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, addyJSON: [String:Any]) {
        self.title = title
        self.street = addyJSON["street"] as? String ?? ""
        self.suite = addyJSON["Apt. 556"] as? String ?? ""
        self.city = addyJSON["city"] as? String ?? ""
        self.zipcode = addyJSON["zipcode"] as? String ?? ""
        self.geoSpot = GeoSpot(json: addyJSON)
        self.subtitle = "\(street) \(suite) \(city) \(zipcode)"
        self.coordinate = CLLocationCoordinate2DMake(geoSpot.latitude, geoSpot.longitude)
    }
}

class CompanyEntity {
    var name: String
    var catchphrase: String
    var bs: String
    
    init(compJSON: [String:Any]) {
        self.name = compJSON["name"] as? String ?? ""
        self.catchphrase = compJSON["catchphrase"] as? String ?? ""
        self.bs = compJSON["bs"] as? String ?? ""
    }
}

class GeoSpot {
    
    var latitude: Double
    var longitude: Double
    
    init(json: [String:Any]) {
        let geo = json["geo"] as? [String:Any] ?? [:]
        let lat = geo["lat"] as? String ?? "", lon = geo["lng"] as? String ?? ""
        self.latitude = Double(lat) ?? 0
        self.longitude = Double(lon) ?? 0
    }
}
