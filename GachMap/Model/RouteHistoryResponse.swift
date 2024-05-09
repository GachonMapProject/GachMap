//
//  RouteHistoryResponse.swift
//  GachMap
//
//  Created by 원웅주 on 5/7/24.
//

import Foundation

struct RouteHistoryResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [RouteHistoryData]
}

struct RouteHistoryData: Decodable {
    var historyId: Int
    var userId: Int
    var totalTime: String
    var createDt: String
    var arrivals: String
    var departures: String
    var satisfactionRoute: String
    var satisfactionTime: String
}
