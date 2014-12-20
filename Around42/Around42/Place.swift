//
//  Place.swift
//  Around42
//
//  Created by swift on 20/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

import UIKit

class Place: NSObject {
   
    var title_: String
    var subTitle_: String
    var lat_: Double
    var lon_: Double
    
    init (titlePinAnnotation title: String, subTitleAnnotation subTitle:String, latitude lat: Double, longitude lon: Double) {
//        super.init()
        title_ = title
        subTitle_ = subTitle
        lat_ = lat
        lon_ = lon
    }
}
