//
//  FirebaseManager.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 03/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FirebaseManagerDelegate {
    func didFetchDataFromFirebase(data: [HospitalFacility])
    func didAddNewPoiToFirebase(poi: HospitalFacility)
}

struct FirebaseManager {
    private let ref: DatabaseReference! = Database.database().reference()
    private var hospitalFacilityRef: DatabaseReference! {
        return ref.child("healthFacility")
    }
    
    private var statisticsRef: DatabaseReference! {
        return ref.child("statistics")
    }
    
    var delegate: FirebaseManagerDelegate?
    
    var healthFacilities: [HospitalFacility] = []
    
    
    func createPoiForHospital(for hospital: [String: Any]){
       
        hospitalFacilityRef.childByAutoId().setValue(hospital) { (error, reference) in
            if error != nil {
                print(error!)
            } else {
                let newHospital = HospitalFacility(firebaseDict: hospital, keyValue: reference.key!)
                if let _ = self.delegate {
                    self.delegate?.didAddNewPoiToFirebase(poi: newHospital)
                }
            }
            
        }
        
    }
    
    func reportAFacility(for key: String) {
        hospitalFacilityRef.child(key).child("confirmed").setValue(false)
    }
    
    func fetchFacilities() {
        
        hospitalFacilityRef.observeSingleEvent(of: .value) { (snapshot) in
            
            if let facilities = snapshot.value as? [String : Any] {
                var facilitiesArray: [HospitalFacility] = []
                for facility in facilities {
                    if let safeFacility = facility.value as? [String: Any] {
                        facilitiesArray.append(HospitalFacility(firebaseDict: safeFacility, keyValue: facility.key))
                    }
                    
                }
                if let safeDelegate = self.delegate {
                    safeDelegate.didFetchDataFromFirebase(data: facilitiesArray)
                }
            }
            
        }
    
    }


    
}
