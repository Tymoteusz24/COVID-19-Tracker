//
//  StatisticsViewModel.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 23/06/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation

class StatiscsListViewModel {
    private var confirmedList = [StatisticsViewModel]()
    private var recoveredList = [StatisticsViewModel]()
    private var deathsList = [StatisticsViewModel]()
    
    
    var numberOfRowsInComponent: Int {
        return confirmedList.count
    }
    
    
    func populateListViewModels(with data: StatisticsData) {
        
        let confirmed = data.confirmed.locations.sorted(by: {$0.country<$1.country})
        let recovered = data.recovered.locations.sorted(by: {$0.country<$1.country})
        let deaths = data.deaths.locations.sorted(by: {$0.country<$1.country})
        
        self.confirmedList = joinCountries(for: confirmed, globalNumber: data.confirmed.latest)
        self.recoveredList = joinCountries(for: recovered, globalNumber: data.recovered.latest)
        self.deathsList = joinCountries(for: deaths, globalNumber: data.deaths.latest)
    }
    
    private func joinCountries(for locations: [Locations], globalNumber: Int) -> [StatisticsViewModel]{
        let viewModels = locations.map({StatisticsViewModel(type: .confirmed, name: $0.country , latestNumber: $0.latest, coordinates: $0.coordinates)})
        var tempViewModels = [StatisticsViewModel]()
        let type = viewModels.first?.type ?? .confirmed
        let globalViewModel = StatisticsViewModel(type: type, name: "Global", latestNumber: globalNumber, coordinates: Coordinates(lat: "0.0", long: "0.0"))
        tempViewModels.append(globalViewModel)
    
        for viewModel in viewModels {
            let lastIndexOfArray = tempViewModels.count - 1
            if tempViewModels[lastIndexOfArray].name == viewModel.name {
                tempViewModels[lastIndexOfArray].increaseLatestNumber(for: viewModel.latestNumber)
            } else {
                tempViewModels.append(StatisticsViewModel(type: type, name: viewModel.name, latestNumber: viewModel.latestNumber, coordinates: viewModel.coordinates))
            }
        }
        return tempViewModels
    }
    
}
//MARK: - Extension - ViewModel for StatisticViewController

extension StatiscsListViewModel {
    
    var returnConfirmedCasesViewModels: [StatisticsViewModel] {
        return self.confirmedList
    }
    
    func getCountryNameForRow(_ row: Int) -> String {
        return self.confirmedList[row].name
    }
    
    func returnViewModeForRow(_ row: Int,and type: DataType) -> StatisticsViewModel {
        switch type {
        case .confirmed, .all:
            return confirmedList[row]
        case .deaths:
            return deathsList[row]
        case .recovered:
            return recoveredList[row]
       
        }
        
    }
    
    func returnStringMortalityForCountry(name: String) -> String {
         if let deaths = self.deathsList.first(where: {$0.name == name})?.latestNumber,
          let recovered = self.recoveredList.first(where: {$0.name == name})?.latestNumber {
             let mortality: Float = Float(deaths)/Float(recovered) * 100.0
             print("deaths: \(deaths) for, revovered: \(recovered) for ")
             return String(format: "%.1f", mortality) + "%"
         } else {
             return ""
         }
     }

}

struct StatisticsViewModel {
    let type: DataType
      let name: String
      var latestNumber: Int
    let coordinates: Coordinates
    
}

extension StatisticsViewModel {
    mutating func increaseLatestNumber(for amount: Int ) {
        self.latestNumber += amount
    }
}

enum DataType: String {
    case confirmed,deaths,recovered, all
}
