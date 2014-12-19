//
//  FirstViewController.swift
//  Around42
//
//  Created by swift on 19/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 48.896581, longitude: 2.318376)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let pinAnnot = MKPointAnnotation()
        pinAnnot.setCoordinate(location)
        pinAnnot.title = "Ecole 42"
        pinAnnot.title = "Born2Code"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

