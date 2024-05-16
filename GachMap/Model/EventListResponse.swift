//
//  EventListResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/16/24.
//

import Foundation

struct EventListResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: EventData?
}

struct EventData: Decodable {
    var eventList: [EventList]
}

struct EventList: Decodable {
    var eventId: Int
    var eventName: String
    var eventLink: String
    var eventInfo: String
    var eventImagePath: String
}

//"data": {
//  "eventList": [
//    {
//      "eventId": 1,
//      "eventName": "가천대학교 축구리그",
//      "eventLink": "https://www.instagram.com/p/C4zwuIOv4ga/?utm_source=ig_web_copy_link&igsh=MzRlODBiNWFlZA==",
//      "eventInfo": "새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]",
//      "eventImagePath": "http://ceprj.gachon.ac.kr:60002/image/SoccerEvent.png"
//    },

//{
//    "success": true,
//    "property": 200,
//    "message": "요청 성공",
//    "data": {
//        "eventList": [
//            {
//                "eventId": 1,
//                "eventName": "감만세 이벤트",
//                "eventLink": "https://www.instagram.com/p/CuWLEouB1em/?img_index=1",
//                "eventInfo": "감만세 쥐잡는 날은 언제까지?",
//                "eventImagePath": "http://localhost:60002/images/mainImageSample.png"
//            },
//            {
//                "eventId": 2,
//                "eventName": "힙플페",
//                "eventLink": "https://www.instagram.com/p/CuWLEouB1em/?img_index=1",
//                "eventInfo": "힙플페 가야겠제?",
//                "eventImagePath": "http://localhost:60002/images/mainImageSample.png"
//            }
//        ]
//    }
//}
//
//{
//    "success": false,
//    "property": 404,
//    "message": "찾을 수 없음",
//    "data": null
//}
