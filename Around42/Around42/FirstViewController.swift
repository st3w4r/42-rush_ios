//
//  FirstViewController.swift
//  Around42
//
//  Created by Yaneël Barbier on 19/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segBar: UISegmentedControl!
    var locationManager: CLLocationManager!
	
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // MARK: Map
        let location = CLLocationCoordinate2D(latitude: 48.8965899, longitude: 2.3185)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let pinAnnot = MKPointAnnotation()
        pinAnnot.setCoordinate(location)
        pinAnnot.title = "Ecole 42"
        pinAnnot.subtitle = "Born2Code"
        mapView.addAnnotation(pinAnnot)
        mapView.mapType = .Hybrid
        mapView.showsUserLocation = true
        
        // MARK: Location
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLDistanceFilterNone
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        println("\(locations.last)")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        locationManager.startUpdatingLocation()
        println("Change authorization")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError
        error: NSError!) {
            println("Error while updating location " + error.localizedDescription);
    }
    
    @IBAction func trackMode(sender: AnyObject) {
        println("location requested");
        if (locationManager?.location? != nil) {
            let lat = locationManager.location.coordinate.latitude
            let lon = locationManager.location.coordinate.longitude
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let span = MKCoordinateSpanMake(0.001, 0.001)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    @IBAction func modeMap(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex {
        case 0 :
            mapView.mapType = .Standard
        case 1 :
            mapView.mapType = .Satellite
        default :
            mapView.mapType = .Hybrid
        }
        
    }
}

