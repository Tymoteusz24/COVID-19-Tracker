//
//  VC+Alert+Extension.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 24/06/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func createYesNoAlert(title: String, message: String, completionHandler: @escaping (()->Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Refresh", comment: "Yes"), style: .default, handler: { (action: UIAlertAction!) in
            completionHandler()
        }))
 
        
        present(alert, animated: true, completion: nil)
    }
    
}
