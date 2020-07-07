////
//  StatisticData.swift
//  JSON
//
//  Created by Tymoteusz Pasieka on 05/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

//
//  StatisticsData.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 29/02/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation

struct StatisticsData: Codable {
    let confirmed: Confirmed
    let recovered: Recovered
    let deaths: Deaths
    
}

protocol DataTypeForModel {
    var latest: Int { get }
    var locations: [Locations] { get }
}

struct Confirmed: Codable {
    let latest: Int
    let locations: [Locations]
    
    
}
struct Recovered: Codable{
    let latest: Int
    let locations: [Locations]
}
struct Deaths: Codable {
    let latest: Int
    let locations: [Locations]
}

struct Locations: Codable {
    let coordinates: Coordinates
    let country: String
   // let history: [String : Int]
    let latest: Int
    let province: String
}

struct Coordinates: Codable {
    let lat: String
    let long: String
}



