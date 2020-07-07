//
//  HealthFacility.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 25/06/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import UIKit
import MapKit

struct HealthFacility: Codable {
    let name: String
    let coordinates: GeoPoint
    
     init(name: String, coordinatesCCL: CLLocationCoordinate2D) {
        self.name = name
        print("init coord \(coordinatesCCL)")
        self.coordinates = GeoPoint(latitude: coordinatesCCL.latitude, longitude: coordinatesCCL.longitude)
    }
}



