//
//  SatisfactionResponse.swift
//  GachMap
//
//  Created by 이수현 on 6/5/24.
//

import Foundation
struct SatisfactionResponse : Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [SatisfactionData]?
}

struct SatisfactionData : Decodable {
    var historyId : Int
    var userId : Int64
}


//{
//    "success": true,
//    "property": 200,
//    "message": "요청 성공",
//    "data": {
//             "historyId": 2,
//           "userId": 574163367434699508
//}
//
//{
//    "success": false,
//    "property": 404,
//    "message": "찾을 수 없음",
//    "data": null
//}
