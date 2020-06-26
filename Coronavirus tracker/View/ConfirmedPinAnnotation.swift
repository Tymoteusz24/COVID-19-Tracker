//
//  CustomPinAnnotation.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 03/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit
import MapKit

protocol PinProtocol {
    var imageName: String {get}
    func configure()
}


class ConfirmedPinAnnotation: MKPointAnnotation, PinProtocol {
    
    // properties
    private var statisticViewModel: StatisticsViewModel

    var imageName: String {
           let dataType = statisticViewModel.type
           switch dataType {
           case .confirmed:
               return "coronaIcon" + imageSize
           default:
               return "healthFacility"
           }
       }
    
   private var imageSize: String {
        let size = statisticViewModel.latestNumber
        if size < 10000 {
            return "Smaller"
        } else if size < 100000 {
            return ""
        } else {
            return "Bigger"
        }
    }
    
    //initialisers
    
    init(viewModel: StatisticsViewModel) {
         self.statisticViewModel = viewModel
     }
    
   // func
    
    func configure() {
        self.title = statisticViewModel.name + " : \(statisticViewModel.latestNumber)"
        self.coordinate = CLLocationCoordinate2D(latitude: Double(statisticViewModel.coordinates.lat)!, longitude: Double(statisticViewModel.coordinates.long)!)
    }
    
}

class HealthFacilityAnnotation: MKPointAnnotation, PinProtocol {
    var imageName = "healthFacility"
    private var healthFacility: HealthFacility
    
    init(healthFacility: HealthFacility) {
        self.healthFacility = healthFacility
    }
    
    func configure() {
        self.title = healthFacility.name
        self.coordinate = CLLocationCoordinate2D(latitude: healthFacility.coordinates.longitude, longitude: healthFacility.coordinates.longitude)
    }
    
}
