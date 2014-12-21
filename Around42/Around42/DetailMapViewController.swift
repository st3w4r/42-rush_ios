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

class DetailMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate {

    var place_ : Place?
    var locationManager: CLLocationManager!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var tableViewDetail: UITableView!
//    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(place_?.lat_)
        // MARK: Location
//        mapView = MKMapView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2.5))
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
        addPin(place_!)
        subTitle.text = place_!.subTitle_
        
        
//        tableViewDetail.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
//        tableViewDetail.tableHeaderView = mapView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /*println(scrollView.contentOffset.y)
        
        var originY:CGFloat = -scrollView.contentOffset.y
        var sizeH:CGFloat = self.mapView.bounds.size.height
        self.mapView.frame = CGRectMake(0,originY, self.mapView.bounds.size.width, sizeH)
        */
//        mapView.frame = CGRectMake(0, scrollView.contentOffset.y-100, mapView.frame.width, mapView.frame.height)
        
//        mapView.frame = CGRectMake(0, scrollView.contentOffset.y / 2, self.view.bounds.width, self.view.bounds.height/2.5)
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

    @IBAction func accessMap(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
        (self.tabBarController?.selectedViewController as FirstViewController).locatePoint(place_!.lat_, longitude: place_!.lon_)
    }
}
