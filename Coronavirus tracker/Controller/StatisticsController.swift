//
//  StatisticsController.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 28/02/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit

class StatisticsController: UIViewController {
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var recoverdedLabel: UILabel!
    @IBOutlet weak var mortalityLabel: UILabel!
    
    @IBOutlet weak var recovChangeLabel: UILabel!
    @IBOutlet weak var deathsChangeLable: UILabel!
    @IBOutlet weak var confChangeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        self.view.backgroundColor = K.Colors.darkBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    
    func updateUI(for row: Int, statisticBrain: StatisticsBrain) {
        
        
        DispatchQueue.main.async {
            let confirmed = statisticBrain.confirmedForCountry[row]
            let recovered = statisticBrain.recoveredForCountry[row]
            let deaths = statisticBrain.deathsForCountry[row]
            self.confirmedLabel.text = "\(confirmed.latest)"
            self.recoverdedLabel.text = "\(recovered.latest)"
            self.deathsLabel.text = "\(deaths.latest)"
            self.confChangeLabel.text = "(+\(confirmed.lastChange))"
            self.deathsChangeLable.text = "(+\(deaths.lastChange))"
            self.recovChangeLabel.text = "(+\(recovered.lastChange))"
            let mortality = (Float(deaths.latest)/Float(confirmed.latest)) * 100.0
            print(" mor \(mortality)")
            self.mortalityLabel.text = String(format: "%.1f", mortality) + "%"
            
            self.countryPicker.reloadAllComponents()
               }
    }
    
}




//MARK: - UIPickerViewDelegateAndDataSource
  
extension StatisticsController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       if let tabBar = tabBarController as? CoronaTabBarController
       {
        return tabBar.statisticsBrain.confirmedForCountry.count
       } else {
        return 0
        }
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      let label = (view as? UILabel) ?? UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = K.Fonts.pickerFont

        if let tabBar = tabBarController as? CoronaTabBarController
        {
            label.text = tabBar.statisticsBrain.confirmedForCountry[row].country.countryName
        }

      return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let tabBar = tabBarController as? CoronaTabBarController {
            updateUI(for: row, statisticBrain: tabBar.statisticsBrain)
        }
        
        //updaye labels
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        return NSAttributedString(string: countries[row], attributes: [NSForegroundColorAttributeName:UIColor.white])
//
//    }
    
    
    
      
      
      
  }
