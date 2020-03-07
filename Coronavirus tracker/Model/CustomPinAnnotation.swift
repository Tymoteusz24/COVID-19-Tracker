//
//  CustomPinAnnotation.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 03/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit
import MapKit

class CustomPinAnnotation: MKPointAnnotation {
    
    let dataType: AnnotationType
    let keyForFirebase: String?
    var size = 1
    
    var imageSize: String {
        if size < 200 {
            return "Smaller"
        } else if size < 1000 {
            return ""
        } else {
            return "Bigger"
        }
    }
    
    var imageName: String {
        switch dataType {
        case .Confirmed:
            return "coronaIcon" + imageSize
        case .Deaths:
            return "coronaIcon"
        case .HealthPoi:
            return "healthFacility"
        default:
            return "Unknown"
        }
    }
    
    
    
    init(type: AnnotationType, of size: Int, for key: String?) {
        self.keyForFirebase = key
        self.dataType = type
        self.size = size
    }
    
    
    
}
