//
//  ViewControllerExtension.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 03/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit


import StoreKit

enum AppStoreReviewManager {
    
    static let minimumReviewWorthyActionCount = 4
    
    static func requestReviewIfAppropriate() {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        
        actionCount += 1
        
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)
        
        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }
        
        
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)
        
        
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        
        SKStoreReviewController.requestReview()
        
        
        defaults.set(0, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
}


