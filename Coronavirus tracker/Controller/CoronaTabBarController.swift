//
//  CoronaTabBarController.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 28/02/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit



class CoronaTabBarController: UITabBarController {
    
  
    var statisticsBrain = StatisticsBrain()
    var firebaseManager = FirebaseManager()
    var statisticsManager = StatisticsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = K.Colors.red
        tabBar.barTintColor = .black
        
        firebaseManager.delegate = self
        statisticsManager.delegate = self
        print("didLoad")
    
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification
        , object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func willEnterForeground() {
        print("enterForeground")
        firebaseManager.fetchFacilities()
        //firebaseManager.fetchStatistics()
        statisticsManager.fetchStats(of: .All)
        showSpinner(onView: self.view)
    }

    
}

//MARK: - FirebaseDelegateManager

extension CoronaTabBarController:  FirebaseManagerDelegate, StatisticManagerDelegate {
    func didUpdateStatistis(_ stats: StatisticsManager, statsData: ([StatisticsModel], [StatisticsModel], [StatisticsModel])) {
        DispatchQueue.main.async {
            if let firstTab = self.viewControllers?[0] as? StatisticsController {
        (self.statisticsBrain.confirmed,self.statisticsBrain.recovered,self.statisticsBrain.deaths) = statsData
                firstTab.updateUI(for: firstTab.countryPicker.selectedRow(inComponent: 0), statisticBrain: self.statisticsBrain)
            firstTab.countryPicker.reloadAllComponents()
            self.removeSpinner()
            }
        }
    }
    
    
    
    
    func didFailUpdate(error: Error) {
        print(error)
    }
    
    
    func didFetchStatsFromFirebase(confirmed: [StatisticsModel], recovered: [StatisticsModel], deaths: [StatisticsModel]) {
        DispatchQueue.main.async {
            if let firstTab = self.viewControllers?[0] as? StatisticsController {
        (self.statisticsBrain.confirmed,self.statisticsBrain.recovered,self.statisticsBrain.deaths) = (confirmed,recovered,deaths)
            firstTab.updateUI(for: 0, statisticBrain: self.statisticsBrain)
            firstTab.countryPicker.reloadAllComponents()
            self.removeSpinner()
            }
        }
    }
    
    
    func didAddNewPoiToFirebase(poi: HospitalFacility) {
        if let secondTab = self.viewControllers?[1] as? MapBarController {
            self.statisticsBrain.healthPoi.append(poi)
            secondTab.updateUIForSControl(secondTab.typeOfMapSControl.selectedSegmentIndex)
        }
    }
    

    
    func didFetchDataFromFirebase(data: [HospitalFacility]) {
        DispatchQueue.main.async {
        self.statisticsBrain.healthPoi = data
        print("data: \(self.statisticsBrain.healthPoi.count)")
        }
    }
    
    
}


