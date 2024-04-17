//
//  BuildingListResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/17/24.
//

import Foundation

struct BuildingListResponse : Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: [BuildingListData]
    
}

struct BuildingListData : Decodable {
    var buildingCode : Int
    var buildingName : String
}


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
