//
//  MapBrain.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 04/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import MapKit


enum AnnotationType {
    case Confirmed
    case Deaths
    case Recovered
    case Quarranteen
    case HealthPoi
    
}

struct MapBrain {
    var tabBar: CoronaTabBarController?
    
    func addAnnotationForStats(statisticType: AnnotationType) -> [CustomPinAnnotation]? {
        print("add annot")
        if let safeTabBar = tabBar {
            var pinsToReturn: [CustomPinAnnotation] = []
            var locations: [StatisticsModel] = []
            switch statisticType {
            case .Confirmed:
                print("conf \(safeTabBar.statisticsBrain.confirmed)")
                locations = safeTabBar.statisticsBrain.confirmed
                //remove global data
                locations.removeFirst()
                break
            case .Deaths:
                locations = safeTabBar.statisticsBrain.deaths
                locations.removeFirst()
                break
            case .Recovered:
                locations = safeTabBar.statisticsBrain.recovered
                locations.removeFirst()
                break
            case .Quarranteen:
                // implementation for new data from firebase
                locations = []
                break
            default :
                print("Wrong Poi: anotherCase")
                break
                
            }
            
            
            for location in locations {
                let pin = CustomPinAnnotation(type: statisticType, of: location.latest, for: nil)
                print("AddPin")
                pin.title = "\(statisticType) \(location.latest)"
                pin.coordinate = CLLocationCoordinate2D(latitude: location.country.latitude ?? 3.21, longitude: location.country.longitude  ?? 3.12)
                pinsToReturn.append(pin)
            }
            return pinsToReturn
        }
       return nil
    }
    

//
//     func addAnnotationsForPoi() {
//        if let safeTabBar = tabBar
//         if let tabBar = tabBarController as? CoronaTabBarController {
//             let poiLocations = tabBar.statisticsBrain.healthPoi
//             for location in poiLocations {
//                 if location.confirmed {
//                     let pin = CustomPinAnnotation(image: "healthFacility", key: location.key)
//                     pin.title = "\(location.name)"
//                     pin.coordinate = CLLocationCoordinate2D(latitude: Double(location.coordinates.lat) ?? 3.21, longitude: Double(location.coordinates.long)  ?? 3.12)
//                                    mapView.addAnnotation(pin)
//                 }
//
//             }
//             
//         }
//     }
//    
    
}
