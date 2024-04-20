//
//  BuildingDetailResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/17/24.
//

import Foundation

struct BuildingDetailResponse : Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: BuildingDetailData?
}

struct BuildingDetailData : Decodable {
    var placeName : String
    var placeSummary : String
    var placeLongitude : Double
    var placeLatitude : Double
    var mainImagePath : String
    var buildingFloors : [buildingFloors]
}

struct buildingFloors : Decodable {
    var buildingFloor : String
    var buildingFloorInfo : String
}



//{
//    "success": true,
//    "property": 200,
//    "message": "요청 성공",
//    "data": {
//        "placeName": "가천관",
//        "placeSummary": "가천관 요약 샘플 데이터 입니다.",
//        "placeLatitude": 37.45050583, //Double
//        "placeLongitude": 127.1296082, //Double
//        "mainImagePath": "http://localhost:60002/images/mainImageSample.png",
//        "buildingFloors": [
//            {
//                "buildingFloor": "12F",
//                "buildingFloorInfo": "총장실"
//            },
//            {
//                "buildingFloor": "11F",
//                "buildingFloorInfo": "대학본부"
//            },
//            {
//                "buildingFloor": "11F",
//                "buildingFloorInfo": "산학협력단"
//            }
//        ]
//    }
//}
//
//
//{
//    "success": false,
//    "property": 404,
//    "message": "찾을 수 없음",
//    "data": null
//}



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
