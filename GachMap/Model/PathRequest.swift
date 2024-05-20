//
//  PathRequest.swift
//  GachMap
//
//  Created by 이수현 on 5/17/24.
//

import Foundation

struct PathRequest: Encodable {
    var latitude : Double?
    var longitude : Double?
    var altitude : Double?
    var placeId : Int?
    var isDepartures : Bool 
}


//{
//    "latitude" : 37.44966, //nullable
//    "longitude" : 127.12693, //nullable
//    "altitude" : 55.3, //nullable
//    "placeId" : null, //Integer nullable
//    "isDepartures" : true //NotNull, 주는 정보가 출발지인 경우 true
//}
