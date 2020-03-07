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

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var dayBeforeYesterday: Date { return Date().twoDayBefore }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var twoDayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
}

struct StatisticsData: Codable {
    let confirmed: Confirmed
    let recovered: Recovered
    let deaths: Deaths
    
}

protocol DataTypeForModel {
    var latest: Int { get }
    var locations: [Locations] { get }
}

struct Confirmed: Codable, DataTypeForModel {
    let latest: Int
    let locations: [Locations]
    
    
}
struct Recovered: Codable, DataTypeForModel {
    let latest: Int
    let locations: [Locations]
}
struct Deaths: Codable, DataTypeForModel {
    let latest: Int
    let locations: [Locations]
}

struct Locations: Codable {
    let coordinates: Coordinates
    let country: String
    let history: [String : String]
    let latest: Int
    let province: String
}

struct Coordinates: Codable {
    let lat: String
    let long: String
}



