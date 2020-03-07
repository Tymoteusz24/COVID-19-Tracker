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
  // 1.
  static let minimumReviewWorthyActionCount = 4

  static func requestReviewIfAppropriate() {
    let defaults = UserDefaults.standard
    let bundle = Bundle.main

    // 2.
    var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)

    // 3.
    actionCount += 1

    // 4.
    defaults.set(actionCount, forKey: .reviewWorthyActionCount)
    
    print("\(actionCount)")

    // 5.
    guard actionCount >= minimumReviewWorthyActionCount else {
      return
    }

    // 6.
    let bundleVersionKey = kCFBundleVersionKey as String
    let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
    let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)

    // 7.
    guard lastVersion == nil || lastVersion != currentVersion else {
      return
    }

    // 8.
    SKStoreReviewController.requestReview()

    // 9.
    defaults.set(0, forKey: .reviewWorthyActionCount)
    defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
  }
}


