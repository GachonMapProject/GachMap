//
//  SatisfactionRequest.swift
//  GachMap
//
//  Created by 이수현 on 5/12/24.
//

import Foundation

struct SatisfactionRequest: Encodable {
    var userId: Int64?
    var guestId: Int64?
    var departures : Int
    var arrivals : Int
    var satisfactionRoute : String
    var satisfactionTime : String
    var temperature : Double
    var rainPrecipitation : Double
    var rainPrecipitationProbability : Int
    var timeList : [TimeList]?
}

struct TimeList : Encodable{
    var firstNodeId : Int
    var secondNodeId : Int
    var time : Int
}


//{
//
//            "userId": 574163367434699508,
//            "guestId" : ~~.
//            // "totalTime": "00:11:40", -> 내가 계산
//            "arrivals": "AI공학관 1층 흡연장 정문", ->nodeId로 온다.
//            "departures": "AI공학관 흡연장 코너", ->nodeId로 온다.
//            "satisfactionRoute": 5,
//            "satisfactionTime": 5
//            temperature; double
//            rainPrecipitation; double
//            rainPrecipitationProbability; Integer
//            배열로
//            timeList : [
//               {firstNodeId : , secondNodeId : , time},
//               {nodeId : , nodeId : , time},
//               {nodeId : , nodeId : , time},
//            ]
//           
//        },
