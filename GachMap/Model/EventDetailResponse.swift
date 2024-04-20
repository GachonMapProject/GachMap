//
//  EventDetailResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/16/24.
//

import Foundation

struct EventDetailResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [EventDetail]?
}

struct EventDetail: Decodable {
    var eventInfoId: Int
    var eventCode: Int
    var eventName: String
    var eventPlaceName: String
    var eventLatitude: Double
    var eventLongitude: Double
    var eventAltitude: Double
}



//{
//    "success": true,
//    "property": 200,
//    "message": "요청 성공",
//    "data": [
//        {
//            "eventInfoId": 1,
//            "eventCode": 1,
//            "eventName": "감만세 이벤트",
//            "eventPlaceName": "반도체대학 흡연구역",
//            "eventLatitude": 37.45067585, //Double
//            "eventLongitude": 127.1270395, //Double
//            "eventAltitude": 75.28107668 //Double
//        },
//        {
//            "eventInfoId": 2,
//            "eventCode": 1,
//            "eventName": "감만세 이벤트",
//            "eventPlaceName": "중앙도서관 흡연구역 입구",
//            "eventLatitude": 37.45254053, //Double
//            "eventLongitude": 127.1323531, //Double
//            "eventAltitude": 83.5  //Double
//        },
//        {
//            "eventInfoId": 3,
//            "eventCode": 1,
//            "eventName": "감만세 이벤트",
//            "eventPlaceName": "예술대학 흡연구역",
//            "eventLatitude": 37.4522509, //Double
//            "eventLongitude": 127.12966, //Double
//            "eventAltitude": 74.0 //Double
//        }
//    ]
//}
//
//{
//    "success": false,
//    "property": 404,
//    "message": "찾을 수 없음",
//    "data": null
//}
