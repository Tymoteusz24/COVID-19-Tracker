//
//  K.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 28/02/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import UIKit


struct K {
    
    struct Fonts {
        private static let montserratRegular = "Montserrat-Regular"
        static let pickerFont = UIFont(name: montserratRegular, size: 22.0)
    }
    
    static let diagnoseSegue = "diagnoseScore"
    static let rateCountUserDefaults = "rateCount"
    
    struct Colors {
        static let red = #colorLiteral(red: 0.6509803922, green: 0.01176470588, blue: 0.1843137255, alpha: 1)
        static let black = #colorLiteral(red: 0.003921568627, green: 0.1098039216, blue: 0.1490196078, alpha: 1)
        static let purple = #colorLiteral(red: 0.6509803922, green: 0.1764705882, blue: 0.3490196078, alpha: 1)
        static let darkBlue = #colorLiteral(red: 0.003921568627, green: 0.1803921569, blue: 0.2509803922, alpha: 1)
    }
}
