//
//  StatisticsController.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 28/02/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit

import Foundation




class StatisticsController: UIViewController {
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var recoverdedLabel: UILabel!
    @IBOutlet weak var mortalityLabel: UILabel!
  
    private var statisticsListViewModel = StatiscsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        self.view.backgroundColor = K.Colors.darkBlue
    }
    
    //MARK: - Setup UI
    
    func setUpUI() {
        let selectedRow = countryPicker.selectedRow(inComponent: 0)
        self.confirmedLabel.text = "\(statisticsListViewModel.returnViewModeForRow(selectedRow, and: .confirmed).latestNumber)"
        self.deathsLabel.text = "\( statisticsListViewModel.returnViewModeForRow(selectedRow, and: .deaths).latestNumber)"
        self.recoverdedLabel.text = "\((statisticsListViewModel.returnViewModeForRow(selectedRow, and: .recovered).latestNumber))"
        self.mortalityLabel.text = statisticsListViewModel.returnStringMortalityForCountry(name: statisticsListViewModel.getCountryNameForRow(selectedRow))
        
        
        self.countryPicker.reloadAllComponents()
    }
    
    //MARK: - RequestReview
    
    override func viewDidAppear(_ animated: Bool) {
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    
}




//MARK: - UIPickerViewDelegateAndDataSource

extension StatisticsController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statisticsListViewModel.numberOfRowsInComponent
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = K.Fonts.pickerFont
        label.text = statisticsListViewModel.getCountryNameForRow(row)
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setUpUI()
    }
    
}


//MARK: - StateControll

// Updating viewmodels after network call in scene delegate

extension StatisticsController: StateControllerProtocol {
    func setState(state: StateController) {
        self.statisticsListViewModel = state.statisticsListViewModel
        setUpUI()
    }
    
  
}
