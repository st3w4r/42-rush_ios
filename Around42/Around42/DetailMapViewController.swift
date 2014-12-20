//
//  DetailMapViewController.swift
//  Around42
//
//  Created by swift on 20/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var place_ : Place?
    var locationManager: CLLocationManager!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(place_?.lat_)
        // MARK: Location
        mapView.mapType = .Hybrid
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLDistanceFilterNone
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        locatePoint(self.place_!.lat_, longitude: place_!.lon_)
        mapView.mapType = .Hybrid
        addPin(place_!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func locatePoint(latitude: Double, longitude: Double) {
        if (locationManager?.location? != nil) {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpanMake(0.001, 0.001)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addPin(place: Place) {
        let location = CLLocationCoordinate2D(latitude: place.lat_, longitude: place.lon_)
        let pinAnnot = MKPointAnnotation()
        pinAnnot.setCoordinate(location)
        pinAnnot.title = place.title_
        pinAnnot.subtitle = place.subTitle_
        mapView.addAnnotation(pinAnnot)
    }

}
