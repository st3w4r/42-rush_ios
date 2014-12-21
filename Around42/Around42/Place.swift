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
    var images_: [String]
    var type_: String
    var desc_: String
    
    init (titlePinAnnotation    title: String,
        subTitleAnnotation      subTitle: String,
        latitude                lat: Double,
        longitude               lon: Double,
        imagesUrl               images: [String],
        typePlace               type: String,
        descriptionPlace        desc: String
        ) {

        title_      = title
        subTitle_   = subTitle
        lat_        = lat
        lon_        = lon
        images_     = images
        type_       = type
        desc_       = desc
    }
    
    func getImages () -> [String] {
        return images_
    }
}
