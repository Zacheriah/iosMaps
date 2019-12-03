//
//  Marker.swift
//  inClass12
//
//  Created by Wayman, Zacheriah on 4/19/19.
//  Copyright © 2019 Wayman, Zacheriah. All rights reserved.
//

import Foundation

class Marker{
    
    var long :Double
    var lat :Double
    
    init() {
        long = 0.0
        lat = 0.0
    }
    
    init(long: Double, lat: Double) {
        self.long = long
        self.lat = lat
    }
}
