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

var places: [Place] = []
var arrayPlaces: NSMutableArray = []

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
		
		// MARK: Plist
		if let path = NSBundle.mainBundle().pathForResource("Places", ofType: "plist"){
			arrayPlaces = NSMutableArray(contentsOfFile: path)!
		}
		createArrayPlaces()
		createPinsAnnotations()
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
	
	func locatePoint(latitude: Double, longitude: Double) {
		if (locationManager?.location? != nil) {
			let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			let span = MKCoordinateSpanMake(0.001, 0.001)
			let region = MKCoordinateRegion(center: location, span: span)
			mapView.setRegion(region, animated: true)
		}
	}
	
    @IBAction func trackMode(sender: AnyObject) {
        println("location requested");
        if (locationManager?.location? != nil) {
            let lat = locationManager.location.coordinate.latitude
            let lon = locationManager.location.coordinate.longitude
          locatePoint(lat, longitude: lon)
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
	
	// MARK: - Places
	func createArrayPlaces() {
		
		for item in arrayPlaces {
			var aPlace = Place(titlePinAnnotation: item["title"] as String,
				subTitleAnnotation: item["subTitle"] as String,
				latitude: item["lat"] as Double,
				longitude: item["lon"] as Double)
			places.append(aPlace)
		}
	}
	
	// MARK: Pin Annotation
	func createPinsAnnotations() {
		
		for place in places {
			let location = CLLocationCoordinate2D(latitude: place.lat_, longitude: place.lon_)
			let pinAnnot = MKPointAnnotation()
			pinAnnot.setCoordinate(location)
			pinAnnot.title = place.title_
			pinAnnot.subtitle = place.subTitle_
			mapView.addAnnotation(pinAnnot)
		}
	}
}

