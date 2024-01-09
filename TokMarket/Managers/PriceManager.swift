//
//  PriceManager.swift
//  TokMarket
//
//  Created by KNG on 7.01.24.
//

import Foundation
import Alamofire

class PriceManager {
    class func fetchEnergyPrices(completion: @escaping (_ error: Error?) -> Void) {
        AF.request("https://seahorse-app-ehbvv.ondigitalocean.app/prices", method: .get)
            .responseDecodable(of: [EnergyPrice].self) { response in
                if let error = response.error {
                    print(error.localizedDescription)
                    completion(error)
                }
                
                guard let energyPryces = response.value else {
                    completion(nil)
                    return
                }
                let realm = LocalDataManager.realm
                realm.beginWrite()
                
                for energyPrice in energyPryces {
                    try? realm.create(EnergyPrice.self, value: energyPrice , update: .modified)
                }
                try? realm.commitWrite()
                completion(nil)
            }
    }
}
