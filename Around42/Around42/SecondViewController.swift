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
//    var arrayPlaces: NSMutableArray = []
//    var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tvListMap.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tvListMap.delegate = self
        
//        // MARK: Plist
//        if let path = NSBundle.mainBundle().pathForResource("Places", ofType: "plist"){
//            arrayPlaces = NSMutableArray(contentsOfFile: path)!
//        }
//        createArrayPlaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(places[indexPath.row].title_)
        performSegueWithIdentifier("ShowDetailMap", sender: indexPath)
//        self.tabBarController?.selectedIndex = 0
//        (self.tabBarController?.selectedViewController as FirstViewController).locatePoint(places[indexPath.row].lat_, longitude: places[indexPath.row].lon_)
    
//        println("\(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            places.removeAtIndex(indexPath.row)
            tableView.reloadData()
            
            // MARK: Delete Plist
            let path = NSBundle.mainBundle().pathForResource("Places", ofType: "plist")
            var data = NSMutableArray()
            for aPlace in places {
                var tmp = ["title": aPlace.title_, "subTitle": aPlace.subTitle_, "lat": aPlace.lat_, "lon": aPlace.lon_]
                data.addObject(tmp)
            }
            data.writeToFile(path!, atomically: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetailMap" {
            var detailMap: DetailMapViewController = segue.destinationViewController as DetailMapViewController
            detailMap.navigationItem.title = places[(sender as NSIndexPath).row].title_
            detailMap.place_ = places[(sender as NSIndexPath).row]
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel.text = places[indexPath.row].title_
        return cell
    }
    

}

