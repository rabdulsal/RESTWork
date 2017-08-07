//
//  MapsViewController.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/5/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import MapKit

class MapsViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var friend: UserEntity!
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    // set initial location in Honolulu
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    
    override func viewDidLoad() {
        self.mapView.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { mapView.showsUserLocation = true }
        
        let location = friend.address!.coordinate
        let geoSpot = CLLocation(latitude: location.latitude, longitude: location.longitude)
        centerMapOnLocation(location: geoSpot)
        mapView.addAnnotations([friend.address!])
    }
    
    @IBAction func pressedCloseButton(_ sender: Any) {
        dismissSelf()
    }
    
    
}

extension MapsViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? AddressEntity {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let button = UIButton(type: .detailDisclosure)
                button.addTarget(self, action: #selector(MapsViewController.makePhoneLabelCallable), for: .touchUpInside)
                view.rightCalloutAccessoryView = button as UIView
                view.image = #imageLiteral(resourceName: "df-logo-flame")
            }
            return view
        }
        return nil
    }
}

fileprivate extension MapsViewController {
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func makePhoneLabelCallable() {
        if let url = URL(string: "telprompt:\(self.friend.phone!)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
