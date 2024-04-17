//
//  EventListResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/16/24.
//

import Foundation

struct EventListResponse : Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: [EventList]
}

struct EventList: Decodable {
    var eventId : Int
    var eventName : String
    var eventLink : String
    var eventInfo : String
    var imageData : Data    //이미지는 데이터 타입으로 바꿔줘야 함?
    
}

