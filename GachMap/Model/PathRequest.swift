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
    
    var userId : Int64?
    var guestId : Int64?
    var temperature : Double
    var precipitation : Double
    var precipitationProbability : Int
    
    
    
}


//{
//    "latitude" : 37.44966, //nullable
//    "longitude" : 127.12693, //nullable
//    "altitude" : 55.3, //nullable
//    "placeId" : null, //Integer nullable
//    "isDepartures" : true, //NotNull, 주는 정보가 출발지인 경우 true
//    
//        // 추가
//    "userId" : 5521235216126, //Long nullable
//  "guestId" : 1, //Integer nullable
//  "temperature" : 23.4, //Double NotNull
//  "precipitation" : 35.4, // Double NotNull;
//  "precipitationProbability" : 17 //Integer NotNull  ;
//}
