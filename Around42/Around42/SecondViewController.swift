//
//  SecondViewController.swift
//  Around42
//
//  Created by Yaneël Barbier on 19/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tvListMap: UITableView!
    var arrayPlaces: NSMutableArray = []
    var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvListMap.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)

        if let path = NSBundle.mainBundle().pathForResource("Places", ofType: "plist"){
            arrayPlaces = NSMutableArray(contentsOfFile: path)!
            
//            Place(titlePinAnnotation: arrayPlaces[0]["title"], subTitleAnnotation: arrayPlaces[0]["subTitle"], latitude: arrayPlaces[0]["lat"], longitude: arrayPlaces[0]["lon"])
            println(arrayPlaces[0])
        }
        
        createArrayPlaces()
        println(places[0].lon_)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPlaces.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(places[indexPath.row].title_)
//        println("\(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel.text = arrayPlaces[indexPath.row]["title"] as? String
        return cell
    }
    
    func createArrayPlaces() {
        
        for item in arrayPlaces {
            var aPlace = Place(titlePinAnnotation: item["title"] as String,
                                subTitleAnnotation: item["subTitle"] as String,
                                latitude: item["lat"] as Double,
                                longitude: item["lon"] as Double)
            places.append(aPlace)
        }
    }
}

