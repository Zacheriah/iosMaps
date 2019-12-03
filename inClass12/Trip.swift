//
//  Trips.swift
//  inClass12
//
//  Created by Wayman, Zacheriah on 4/17/19.
//  Copyright © 2019 Wayman, Zacheriah. All rights reserved.
//

import Foundation

class Trip{
    var name :String?
    var markers = [Marker]()
    var id :String?
    var markercount :Int?
    init(){
        self.name = ""
        self.id = ""
        self.markercount = 0
    }
    
    init(id: String, name: String, marker: Marker) {
        self.name = name
        self.id = id
        self.markers.append(marker)
    }
}

class Marker{
    
    var long :Double?
    var lat :Double?
    
    init() {
        
    }
    
    init(long: Double, lat: Double) {
        self.long = long
        self.lat = lat
    }
}

