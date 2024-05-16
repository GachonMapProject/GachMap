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
    var userId: Int64
    var totalTime: Int
    var createDt: String
    var arrivals: String
    var departures: String
    var satisfactionRoute: Int
    var satisfactionTime: Int
}


//{
//  "historyId": 2,
//  "userId": 569153915064443400,
//  "totalTime": 0,
//  "createDt": "2024-05-16T19:25:37.992528",
//  "arrivals": "중앙도서관 옆문\n",
//  "departures": "AI공학관 정문",
//  "satisfactionRoute": 3,
//  "satisfactionTime": 3
//},
