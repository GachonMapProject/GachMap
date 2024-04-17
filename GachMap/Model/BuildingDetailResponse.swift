//
//  BuildingDetailResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/17/24.
//

import Foundation

struct BuildingDetailResponse : Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: [BuildingDetailData]
}

struct BuildingDetailData : Decodable {
    var placeName : String
    var placeSummary : String
    var placeLongitude : Double
    var placeLatitude : Double
    var floorInfo : [FloorInfo]
}

struct FloorInfo : Decodable {
    var floor : String
    var floorInfo : String
}



//전송방향 : IN
//{
// }
//전송방향 : OUT
//{
//   "success" : true,
//   "message" : “건물 층 정보 전송 완료(이미지 파일 헤더 확인)”,
//   "property" : 200,
//   “data" :
//     [
//        {
//          "placeName" : "AI공학관",
//          "placeSummary" : "기술의 진보 그 집합체",
//          "placeLongitude" : 34.15253,
//          "placeLatitude" : 157.12524
//        }
//        {
//          “buildingFloor” : 1F,
//          “buildingInfo” : “학생회실”,
//        },
//        ...
//            
//     ]
//}
