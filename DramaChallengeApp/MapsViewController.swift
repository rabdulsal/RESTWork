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
    
    var friendGeoAnnotations = [MKAnnotation]()
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    // set initial location in Honolulu
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    
    override func viewDidLoad() {
        self.mapView.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { mapView.showsUserLocation = true }
        
        mapView.addAnnotations(friendGeoAnnotations)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let _location = mapView.userLocation.location {
//            centerMapOnLocation(location: _location)
//        }
    }
}

extension MapsViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? AddressEntity {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
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
}
