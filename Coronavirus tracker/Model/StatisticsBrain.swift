//
//  StatisticsBrain.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 01/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation



struct StatisticsBrain {
    var confirmed: [StatisticsModel] = []
    var recovered: [StatisticsModel] = []
    var deaths: [StatisticsModel] = []
    var healthPoi: [HospitalFacility] = []
    
    var confirmedForCountry: [StatisticsModel] {
        let joined = joinCountries(for: confirmed).sorted(by: {$0.latest > $1.latest})
        
        return joined
    }
    
    var recoveredForCountry: [StatisticsModel] {
           let joined = joinCountries(for: recovered).sorted(by: {$0.latest > $1.latest})
           return joined
    }
    var deathsForCountry: [StatisticsModel] {
              let joined = joinCountries(for: deaths).sorted(by: {$0.latest > $1.latest})
              return joined
    }
    mutating func removePoi(for key: String) {
        let filteredPoi = healthPoi.filter({$0.key != key})
        healthPoi = filteredPoi
    }
    

    
    
    
    func joinCountries(for data: [StatisticsModel]) ->  [StatisticsModel] {
        
        let sortedByCountries = data.sorted(by: {$0.country.countryName > $1.country.countryName})
        var countries: [StatisticsModel] = []
        var countriesName: [String] = []
        for country in sortedByCountries {
            if !countriesName.contains(country.country.countryName) {
                countriesName.append(country.country.countryName)
                countries.append(country)
            } else {
                if countries.last != nil {
                    countries[countries.count - 1].increaseLatest(by: country.latest)
                    countries[countries.count - 1].increaseDayChange(by: country.lastChange)
                }
            }
            
        }
        return countries
    }
    
}


//MARK: - extension Date


