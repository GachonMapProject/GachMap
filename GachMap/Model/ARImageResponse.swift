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
    var arImagePath : String
    var placeId : Int
    var placeLatitude : Double
    var placeLongitude : Double
    var plaecAltitude : Double
    var buildingHeight : Double
}


//"success": true,
// "property": 200,
// "message": "요청 성공",
// "data": [
//                     {
//                         "arImagePath" : "ceprj.gachon.ac.kr:60002~",
//                           "placeId" : 1,
//                           "placeLatitude" : 123.123,
//                         "placeLongitude" : 123.123,
//                             "placeAltitude" : 123.123,
//                           "buildingHeight" : 1243.123
//                         },
