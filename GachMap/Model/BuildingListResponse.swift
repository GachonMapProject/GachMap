//
//  BuildingListResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/17/24.
//

import Foundation

struct BuildingListResponse: Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: BuildingData?
}

struct BuildingData: Decodable {
    var buildingList: [BuildingList]
}

struct BuildingList: Decodable {
    var placeId: Int
    var placeName: String
    var thumbnailImagePath: String?
}
//{
//    "success": true,
//    "property": 200,
//    "message": "요청 성공",
//    "data": {
//        "buildingList": [
//            {
//                "placeId": 1,
//                "placeName": "가천관",
//                "thumbnailImagePath": "http://localhost:60002/images/guachonguan.png"
//          }
//        ]
//    }
//}

//전송방향 : OUT
//{
//   "success" : true,
//   "message" : “캠퍼스 맵 리스트 전송 성공 (이미지 파일 헤더 확인)”,
//   "property" : 200,
//   “data" :
//     [
//        {
//          “buildingCode” : 1,
//          “buildingName” : “가천관”,
//        },
//        {
//          “buildingCode” : 2,
//          “buildingName” : “비전타워”,
//        },
//        ...
//        {
//          “buildingCode” : 10,
//          “buildingName” : “학생회관”,
//        },
//        {
//          “buildingCode” : 11,
//          “buildingName” : “AI공학관”,
//        },
//     ]
//}
