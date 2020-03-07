//
//  StatisticModel.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 29/02/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation

//modifyed
enum DataType: String, CaseIterable {
    case Confirmed = "confirmed"
    case Deaths = "deaths"
    case Recovered = "recoverd"
    case All = "all"
    
}


struct Country {
    let countryName: String
    let provinceName: String?
    let latitude: Double?
    let longitude: Double?
    
    //return dict
    
    var dict: [String : Any] {
        ["countryName" : countryName as String, "provinceName" : provinceName!, "latitude": latitude!, "longitude": longitude! as NSNumber]
    }
    
    
}

extension Country {
    init?(dict: [String:Any]) {
        guard let name = dict["countryName"] as? String,
            let province = dict["provinceName"] as? String,
            let lat = dict["latitude"] as? Double,
            let long = dict["longitude"] as? Double
            
            else {return nil}
        
        self.countryName = name
        self.provinceName = province
        self.latitude = lat
        self.longitude = long
        
        
    }
}

struct StatisticsModel {
    let country: Country
    let dataType: DataType
    var lastChange: Int
    var history: [String : String]?
    var latest: Int
    
    var returnPinImageName: String {
        if latest < 200 {
            return "coronaIconSmaller"
        } else if latest < 1000 {
            return "coronaIcon"
        } else {
            return "coronaIconBigger"
        }
    }
    
    mutating func increaseLatest(by number: Int) {
        latest += number
    }
    
    mutating func increaseDayChange(by number: Int) {
        lastChange += number
    }
    
    
    /// string return
    
    func returnString() -> [String: Any]{
        var dict : [String : Any] = [:]
        
        dict = ["country" : country.dict , "lastChange" : lastChange as NSNumber, "latest" : latest as NSNumber, "dataType" : dataType.rawValue as String]
        
        return dict
    }
    
}

extension StatisticsModel {
    init?(dict: [String : Any]) {
        guard let dataTypeDict = dict["dataType"] as? String,
            let lastChangeDict = dict["lastChange"] as? Int,
            let latestDict = dict["latest"] as? Int,
            let countryDict = dict["country"] as? [String : Any]
            else { return nil}
        
        guard let safeCountry = Country(dict: countryDict) else {return nil}
        guard let safeDataType = DataType(rawValue: dataTypeDict) else {return nil}
        
        self.country = safeCountry
        self.dataType = safeDataType
        self.lastChange = lastChangeDict
        self.latest = latestDict
    }
    
    
}


