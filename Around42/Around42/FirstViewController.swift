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



class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segBar: UISegmentedControl!
    var locationManager: CLLocationManager!
	var pointPin: CGPoint!
	var arrayPlaces: NSMutableArray = []
	
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // MARK: Map
        let location = CLLocationCoordinate2D(latitude: 48.8965899, longitude: 2.3185)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
		mapView.mapType = .Hybrid
		mapView.showsUserLocation = true
		mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "dropPin:"))
		
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
	
	func addPin(place: Place) {
		let location = CLLocationCoordinate2D(latitude: place.lat_, longitude: place.lon_)
		let pinAnnot = MKPointAnnotation()
		pinAnnot.setCoordinate(location)
		pinAnnot.title = place.title_
		pinAnnot.subtitle = place.subTitle_
		
//		let pinDrop = MKPinAnnotationView(annotation: pinAnnot, reuseIdentifier: "pin")
//		pinDrop.animatesDrop = true
		
		mapView.addAnnotation(pinAnnot)
	}
	
	var newPinTitleField: UITextField!
	var newPinSubTitleField: UITextField!
	
	func addPlace(alert: UIAlertAction!) {
		var location = mapView.convertPoint(pointPin, toCoordinateFromView: self.mapView)
		var aPlace = Place(titlePinAnnotation: newPinTitleField.text,
			subTitleAnnotation: newPinSubTitleField.text,
			latitude: location.latitude,
			longitude: location.longitude)
		addPin(aPlace)
		places.append(aPlace)
	}
	
	func dropPin(gesture: UIGestureRecognizer) {
		if gesture.state != UIGestureRecognizerState.Began {
			return
		}
		
		pointPin = gesture.locationInView(self.view)
		
		var alert: UIAlertController = UIAlertController(title: "Ajouter un lieu", message: "Ajouter une description", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "Ajouter", style: UIAlertActionStyle.Default, handler: addPlace))
		alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
			textField.placeholder = "Nom du lieu"
			self.newPinTitleField = textField
		}
		alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
			textField.placeholder = "Description du lieu"
			self.newPinSubTitleField = textField
		}
		self.presentViewController(alert, animated: true, completion: nil)
		
//		var point: CGPoint = gesture.locationInView(self.view)
//		addPlace(point)
	}
	
}

