//
//  EnergyPrice.swift
//  TokMarket
//
//  Created by KNG on 7.01.24.
//

import RealmSwift

class EnergyPrice: Object, Decodable {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var date: String?
    @Persisted var hourlyData: List<HourlyData>
    
    enum CodingKeys: String, CodingKey {
        case _id
        case date
        case hourlyData
    }
}

class HourlyData: Object, Decodable {
    @Persisted var time: String
    @Persisted var data: HourlyInfo?
    
    
    enum CodingKeys: String, CodingKey {
        case time
        case data
    }
}

class HourlyInfo: Object, Decodable {
    @Persisted var eur: Double
    @Persisted var bgn: Double
    @Persisted var volume: Double
    
    enum CodingKeys: String, CodingKey {
        case eur
        case bgn
        case volume
    }
}
