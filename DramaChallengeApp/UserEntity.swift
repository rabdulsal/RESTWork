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
    var email: String?=nil
    var address: AddressEntity?=nil
    var phone: String?=nil
    var website: String?=nil
    var company: CompanyEntity?=nil
    var albums: [AlbumEntity]?=nil {
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
    
    // TODO: Place DramaFever info for all ??
    
    convenience init(userJSON: [String : Any]) {
        let id = userJSON["id"] as? Int ?? -1
        let name = userJSON["name"] as? String ?? ""
        let username = userJSON["username"] as? String ?? ""
        let email = userJSON["email"] as? String ?? ""
        let addyJSON = userJSON["address"] as? [String:Any] ?? [:]
        let address = AddressEntity(title: name, addyJSON: addyJSON)
        let phone = userJSON["phone"] as? String ?? ""
        let website = userJSON["website"] as? String ?? ""
        let compJSON = userJSON["company"] as? [String:Any] ?? [:]
        let company = CompanyEntity(compJSON: compJSON)
        self.init(id: id, name: name, username: username, email: email, address: address, phone: phone, website: website, company: company)
    }
    
    init(
        id: Int,
        name: String,
        username: String,
        email: String?=nil,
        address: AddressEntity?=nil,
        phone: String?=nil,
        website: String?=nil,
        company: CompanyEntity?=nil)
    {
        self.id         = id
        self.name       = name
        self.username   = username
        self.email      = email
        self.address    = address
        self.phone      = phone
        self.website    = website
        self.company    = company
    }
}

class AddressEntity : NSObject, MKAnnotation {
    var title: String?
    var street: String
    var suite: String?=nil
    var city: String
    var zipcode: String
    var geoSpot: GeoSpot
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    convenience init(title: String, addyJSON: [String:Any]) {
//        self.title = title
        let street = addyJSON["street"] as? String ?? ""
        let suite = addyJSON["Apt. 556"] as? String ?? ""
        let city = addyJSON["city"] as? String ?? ""
        let zipcode = addyJSON["zipcode"] as? String ?? ""
        let geoSpot = GeoSpot(json: addyJSON)
        let coordinate = CLLocationCoordinate2DMake(geoSpot.latitude, geoSpot.longitude)
        let subtitle = "\(street) \(suite) \(city) \(zipcode)"
        self.init(title: title, street: street, suite: suite, city: city, zipcode: zipcode, geoSpot: geoSpot, subtitle: subtitle, coordinate: coordinate)
    }
    
    init(
        title: String,
        street: String,
        suite: String?=nil,
        city: String,
        zipcode: String,
        geoSpot: GeoSpot?=nil,
        subtitle: String?=nil,
        coordinate: CLLocationCoordinate2D?)
    {
        self.title = title
        self.street = street
        self.suite = suite ?? ""
        self.city = city
        self.zipcode = zipcode
        let geoSpot = geoSpot ?? GeoSpot(lat: "41.8834239", long: "-87.6324041")
        self.geoSpot = geoSpot
        self.coordinate = coordinate ?? CLLocationCoordinate2DMake(geoSpot.latitude, geoSpot.longitude)
        super.init()
        self.subtitle = subtitle ?? "\(self.street) \(self.city) \(self.zipcode)"
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
    
    convenience init(json: [String:Any]) {
        let geo = json["geo"] as? [String:Any] ?? [:]
        let lat = geo["lat"] as? String ?? "", lon = geo["lng"] as? String ?? ""
        self.init(lat: lat, long: lon)
    }
    
    init(lat: String, long: String) {
        self.latitude = Double(lat) ?? 0
        self.longitude = Double(long) ?? 0
    }
}
