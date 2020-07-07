//
//  StatsManager.swift
//  JSON
//
//  Created by Tymoteusz Pasieka on 05/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
//import FirebaseDatabase


//MARK: - StateController

protocol StateControllerProtocol {
       func setState(state: StateController)
   }

class StateController {
      var statisticsListViewModel: StatiscsListViewModel = StatiscsListViewModel()
  }

//MARK: - Statistics netowrking manager


enum NetworkError: Error {
    case domainError
    case decodingError
    case connectionError
    case firebaseError
}

struct Resource<T:Decodable> {
    let url: URL
    init(for typeOfData: DataType) {
        self.url = URL(string:"https://coronavirus-tracker-api.herokuapp.com/" + typeOfData.rawValue)!
    }
}

final class StatisticsManager {
    
    func loadStats<T>(resources: Resource<T>, completion: @escaping (Result<T,NetworkError>) -> Void) {
        print("startLoading")
        URLSession.shared.dataTask(with: resources.url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.domainError))
            } else if let data = data {
                 print("response: \(response)")
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                   
                    completion(.failure(.connectionError))
                    return
                }
               
                print("data: \(data)")
                print(resources.url)
                if let result = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
 
  
   
}

//MARK: - send data to firebase

extension StatisticsManager {
    func sendToFirebase(data: [String : Any], position: Int) {
        
//        let firebaseRef: DatabaseReference = Database.database().reference().child("statistics")
//        firebaseRef.childByAutoId().setValue(data)
    }
}








