//
//  PoiModel.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 03/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation

class PoiModel {
    let name: String
    let coordinates: PoiCoordinates
    let confirmed: Bool
    var key: String
    var dictionary: [String : Any] {
        return ["name" : self.name, "confirmed" : self.confirmed, "coordinates" : ["latitude": self.coordinates.lat, "longitude": self.coordinates.long]]
    }
    
    init(poiName: String, coor: PoiCoordinates, conf: Bool, keyValue: String) {
        self.name = poiName
        self.confirmed = conf
        self.coordinates = coor
        self.key = keyValue
    }
    
    init(firebaseDict: [String : Any], keyValue: String) {
        self.key = keyValue
        self.name = (firebaseDict["name"] as? String) ?? "Unknown"
        self.confirmed = (firebaseDict["confirmed"] as? Bool) ?? false
        if let coord = firebaseDict["coordinates"] as? [String : NSNumber] {
            self.coordinates = PoiCoordinates(lat: coord["latitude"] ?? 0.0, long: coord["longitude"] ?? 0.0)
        } else {
            self.coordinates = PoiCoordinates(lat: 0.0 as NSNumber, long: 0.0 as NSNumber)
        }
    }
    
}

struct PoiCoordinates {
    let lat: NSNumber
    let long: NSNumber
}

class HospitalFacility: PoiModel {
    
}


