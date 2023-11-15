//
//  Model.swift
//  StocksApp
//
//  Created by user243757 on 10/16/23.
//

import Foundation

struct ResultSet : Codable {
    var count :Int
    var pages : Int
    var results :  [Results]
}

struct Results : Codable {
    var name :String
    var performanceId : String
    
}

typealias StockData = [String :StockDataValue]

struct StockDataValue : Codable{
    var lastPrice : LastPrice
}
struct LastPrice : Codable {
    var value : Double
}

//typealias StockData = [String : PerformanceData]
//
//struct PerformanceData : Codable {
//    var lastprice : LastPrice
//}
//
//struct LastPrice :Codable {
//    var value : Double
//   }





