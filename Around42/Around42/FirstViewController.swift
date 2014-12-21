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
var zoomValue: Double! {
	get {
		var value = NSUserDefaults.standardUserDefaults().objectForKey("zoom") as? Double
		if value == nil {
			return 0.01
		}
		return value
	}
	set (newValue){
		NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "zoom")
		NSUserDefaults.standardUserDefaults().synchronize()
	}
}


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
        let span = MKCoordinateSpanMake(zoomValue, zoomValue)
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
	
	override func viewWillAppear(animated: Bool) {
		mapView.removeAnnotations(mapView.annotations)
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
			let span = MKCoordinateSpanMake(zoomValue, zoomValue)
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
							longitude: item["lon"] as Double,
							imagesUrl: item["images"] as [String],
							typePlace: item["type"] as String,
							descriptionPlace: item["description"] as String)
			
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
			self.mapView.addAnnotation(pinAnnot);
			var anView:MKAnnotationView = mapView(self.mapView, viewForAnnotation: pinAnnot)
		}
	}
	
	func addPin(place: Place) {
		let location = CLLocationCoordinate2D(latitude: place.lat_, longitude: place.lon_)
		let pinAnnot = MKPointAnnotation()
		pinAnnot.setCoordinate(location)
		pinAnnot.title = place.title_
		pinAnnot.subtitle = place.subTitle_
		self.mapView.addAnnotation(pinAnnot);
		var anView:MKAnnotationView = mapView(self.mapView, viewForAnnotation: pinAnnot)
//        anView.image = UIImage(named: "Location")
	}

	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		if annotation is MKUserLocation {
			return nil
		}
		let reuseId = "pin"
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.animatesDrop = true
			if (annotation.title == "San Francisco") {
				pinView!.pinColor = .Purple
			}
			pinView!.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "Next"))
		} else {
			pinView!.annotation = annotation
        }
        return pinView
    }

    
    
    
    
	var newPinTitleField: UITextField!
	var newPinSubTitleField: UITextField!
	
	func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
		var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "calloutTapped:")
		view.addGestureRecognizer(tapGesture)
	}
	
	func calloutTapped(sender :UITapGestureRecognizer)
	{
		var view = sender.view as MKAnnotationView
		var annotation: MKAnnotation = view.annotation
		if annotation.isKindOfClass(MKPointAnnotation) {
			var detailMap = DetailMapViewController()
//			detailMap.place_.
			presentViewController(detailMap, animated: true, completion: nil)
			
//            self.prepareForSegue(<#segue: UIStoryboardSegue#>, sender: <#AnyObject?#>)
//			self.performSegueWithIdentifier("annotationDetailSegue", sender: annotation)
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "annotationDetailSegue" {
			let detailMap = segue.destinationViewController as DetailMapViewController
		}
	}
	
    func addPlace(alert: UIAlertAction!) {
		if newPinTitleField.text != "" && newPinSubTitleField.text != ""
		{
		var location = mapView.convertPoint(pointPin, toCoordinateFromView: self.mapView)
		var aPlace = Place(titlePinAnnotation: newPinTitleField.text,
						subTitleAnnotation: newPinSubTitleField.text,
						latitude: location.latitude,
						longitude: location.longitude,
						imagesUrl: [],
						typePlace: "place",
						descriptionPlace: ""
						)
		addPin(aPlace)
		places.append(aPlace)
		
		// MARK: Add Plist
		let path = NSBundle.mainBundle().pathForResource("Places", ofType: "plist")
		var data = NSMutableArray(contentsOfFile: path!)
		var tmp = ["title": aPlace.title_,
					"subTitle": aPlace.subTitle_,
					"lat": aPlace.lat_,
					"lon": aPlace.lon_,
					"images": aPlace.images_,
					"type": aPlace.type_,
					"description": aPlace.desc_]
		data?.addObject(tmp)
		data?.writeToFile(path!, atomically: true)
		}
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
	}

}

