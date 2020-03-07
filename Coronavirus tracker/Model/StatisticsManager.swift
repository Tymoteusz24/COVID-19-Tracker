//
//  StatsManager.swift
//  JSON
//
//  Created by Tymoteusz Pasieka on 05/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import Firebase

protocol StatisticManagerDelegate {
    func didFailUpdate(error: Error)
    mutating func didUpdateStatistis(_ stats: StatisticsManager, statsData: ([StatisticsModel],[StatisticsModel],[StatisticsModel]))
}

struct StatisticsManager {
    
    
    private var statsUrl = "https://coronavirus-tracker-api.herokuapp.com/"
    
    var delegate: StatisticManagerDelegate?
    
    
     func fetchStats(of type: DataType) {
        let url = statsUrl + type.rawValue
       performReuest(with: url, of: type)
        print("fetch")
        
    }
    
     func performReuest(with urlString: String, of type:DataType) {
        if let url = URL(string: urlString) {
            print("perform")
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    if let safeDelegate = self.delegate {
                        safeDelegate.didFailUpdate(error: error!)
                    }
                    return
                } else if let safeData = data {
                    if let result = self.parseJSON(safeData) {
                        if var safeDelegate = self.delegate {
                            safeDelegate.didUpdateStatistis(self, statsData: result)
                        }
                    }
                    
                }
                
            }
            task.resume()
        }
     }
    
    func parseJSON(_ statisticsData: Data) -> ([StatisticsModel],[StatisticsModel],[StatisticsModel])?  {
        let decoder = JSONDecoder()
        do {
            print("start decoding")
             let decodedData = try decoder.decode(StatisticsData.self, from: statisticsData)
            var (confirmed, recoverd, deaths) : ([StatisticsModel],[StatisticsModel],[StatisticsModel]) = ([],[],[])
            for type in DataType.allCases {
                switch type {
                case .Confirmed:
                    confirmed = parseJSONByType(for: decodedData.confirmed, of: type)
                case .Recovered:
                    recoverd = parseJSONByType(for: decodedData.recovered, of: type)
                case .Deaths:
                    deaths = parseJSONByType(for: decodedData.deaths, of: type)
                default:
                    print("")
                }
                
            }
            
            return (confirmed, recoverd, deaths)
        } catch {
          print("cantDecoded \(error)")
            return nil
        }
    }
    
    func parseJSONByType(for data: DataTypeForModel, of type: DataType) -> [StatisticsModel] {
        var statistics: [StatisticsModel] = []
        var decodedData = data
        switch type {
        case .Confirmed:
            decodedData = data as! Confirmed
        case .Recovered:
            decodedData = data as! Recovered
        case .Deaths:
            decodedData = data as! Deaths
        default:
            print("error")
        }
        
        statistics.append(StatisticsModel(country: Country(countryName: NSLocalizedString("Global", comment: "Global"), provinceName: "", latitude: 0.0, longitude: 0.0), dataType: type, lastChange: 0, history: [:], latest: decodedData.latest))
        let locations = decodedData.locations
        var globalDayChange = 0
        var i = 0
        for location in locations {
            let dayChange = calculateDayChange(history: location.history)
            globalDayChange += dayChange
            let stasticModelToAppend = StatisticsModel(country: Country(countryName: location.country, provinceName: location.province, latitude: Double(location.coordinates.lat) ?? nil, longitude: Double(location.coordinates.long) ?? nil), dataType: type, lastChange: dayChange, history: location.history, latest: location.latest)
            statistics.append(stasticModelToAppend)
            sendToFirebase(data: stasticModelToAppend.returnString(), position: i)
            i += 1
        }
        
        statistics[0].increaseDayChange(by: globalDayChange)
        sendToFirebase(data: statistics[0].returnString(), position: i)
       
         return statistics
    }
  
    
    func returnFormattedDate(for date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date) - 2000
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let formattedDate = ("\(month)/\(day)/\(year)")
        return formattedDate
    }
    
    
    func calculateDayChange(history: [String: String]) -> Int {
        
        let yesterday = returnFormattedDate(for: Date().dayBefore)
        let twoDayBefore = returnFormattedDate(for: Date().twoDayBefore)
        var value = 0
        if let yesterdayValue = history[yesterday], let twoDayValue = history[twoDayBefore] {
            value = (Int(yesterdayValue) ?? 0) - (Int(twoDayValue) ?? 0)
        }
        return value
    }
    
   
}

//MARK: - send data to firebase

extension StatisticsManager {
    func sendToFirebase(data: [String : Any], position: Int) {
        
        let firebaseRef: DatabaseReference = Database.database().reference().child("statistics")
        firebaseRef.childByAutoId().setValue(data)
    }
}








