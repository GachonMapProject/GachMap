//
//  ARImageRequest.swift
//  GachMap
//
//  Created by 이수현 on 5/17/24.
//

import Foundation

struct ARImageResponse : Decodable {
    var success: Bool
    var property: Int
    var message: String
    var data: [ARInfo]?
}


struct ARInfo : Decodable {
    var arImagePath : String?
    var placeId : Int
    var placeLatitude : Double
    var placeLongitude : Double
    var placeAltitude : Double
    var buildingHeight : Double?
}


//{
//    "success": true,
//    "property": 200,
//    "message": "요청 성공",
//    "data": [
//                        { //placeId 0인건 근처 노드 위치 정보, arImagePath도 ""로 간다.
//                            "arImagePath" : "",
//                              "placeId" : 0,
//                              "placeLatitude" : 123.123,
//                            "placeLongitude" : 123.123,
//                                "placeAltitude" : 123.123,
//                              "buildingHeight" : 0.0
//                            },
//    
//    //얘들은 DB정보 없어서 Path랑 Height null로 갈 가능성 농후.
//                        {
//                            "arImagePath" : "ceprj.gachon.ac.kr:60002~",
//                              "placeId" : 1,
//                              "placeLatitude" : 123.123,
//                            "placeLongitude" : 123.123,
//                                "placeAltitude" : 123.123,
//                              "buildingHeight" : 1243.123
//                            },
