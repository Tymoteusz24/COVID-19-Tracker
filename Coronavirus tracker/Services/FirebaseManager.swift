//
//  FirebaseManager.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 03/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct FirebaseManager {
    private let db = Firestore.firestore()
    
    private var hospitalFacilityRef: CollectionReference {
        return db.collection("healthFacility")
    }
    
    func fetchHealhFacilities<T: Decodable> (model: T.Type, completion: @escaping ([T]?, NetworkError?) -> Void) {
        hospitalFacilityRef.getDocuments { (snapshot, error) in
            guard error == nil else { completion(nil,NetworkError.firebaseError) ; return}
            
            if let snapshot = snapshot {
                
                let res: [T?]? = snapshot.documents.map({
                    let document = $0
                    if let result = try? document.data(as: T.self) {return result}
                    return nil
                })
                
                guard let result = res as? [T] else {completion(nil, NetworkError.decodingError) ; return }
                completion(result, nil)
                
// ANOTHER IMPLEMENTATION
//                var tempData = [T]()
//                for document in snapshot.documents {
//                    
//                    let result = Result { try document.data(as: T.self) }
//                    switch result {
//                    case .success(let model):
//                        if let model = model {
//                            tempData.append(model)
//                        }
//                    case .failure(let error):
//                        completion(tempData, error)
//                    }
//                    
//                }
//                completion(tempData,nil)
                
            }
        }
    }
    
    func addHealthFacility(healthFacility: HealthFacility, completion: @escaping (NetworkError?) -> Void) {
        do {
            try hospitalFacilityRef.document().setData(from: healthFacility)
            completion(nil)
        } catch {
            completion(.decodingError)
        }
    }

}
