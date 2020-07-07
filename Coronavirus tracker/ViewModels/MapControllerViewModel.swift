//
//  MapControllerViewModel.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 24/06/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import MapKit

struct MapControllerViewModel {
    
    var confirmedList: [StatisticsViewModel]
    var healthFacilitiesList: [HealthFacility]?
    
    func returnCustomPinAnnotaitonsForHealthFacilities() -> [HealthFacilityAnnotation] {

        guard let facilities = healthFacilitiesList else { return [] }
        
        let arrayToReturn: [HealthFacilityAnnotation] = facilities.map({
            let pin = HealthFacilityAnnotation(healthFacility: $0)
            pin.configure()
            return pin
        })
        return arrayToReturn
    }
    
    func returnCustomPinAnnotationsForConfirmedCases() -> [ConfirmedPinAnnotation] {
        
        let arrayToReturn: [ConfirmedPinAnnotation] = confirmedList.map({
            let pin = ConfirmedPinAnnotation(viewModel: $0)
            pin.configure()
            return pin
        })
        return arrayToReturn
    }
    
    func getRegionInMeter(segment number: Int) -> Double {
        if number == 0 {
            return 9000000.0
        } else if number == 1 {
            return 9000000.0
        } else {
            return 0.0
        }
    }
    
    
    mutating func removePoi(for key: String) {
//         let filteredPoi = healthPoi.filter({$0.key != key})
//         healthPoi = filteredPoi
     }
    

}

