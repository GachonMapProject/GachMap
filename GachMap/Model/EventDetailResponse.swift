//
//  EventDetailResponse.swift
//  GachMap
//
//  Created by 이수현 on 4/16/24.
//

import Foundation

struct EventDetailResponse : Decodable {
    var success: Bool
    var message: String
    var property: Int
    var data: EventDetail
}

struct EventDetail: Decodable {
    var eventDto : EventDto
    var eventLocationDto : [EventLocationDto]
    
}

struct EventDto : Decodable {
    var eventId : Int
    var eventName : String
    var eventStartDate : Date   // 타입 확실히 하기 (설계서에 타입이 안 나옴)
    var eventEndate : Date
    var eventLink : String
    var eventInfo : String
    var imageData : Data    //이미지는 데이터 타입으로 바꿔줘야 함?
}

struct EventLocationDto : Decodable {
    var eventPlaceName : String
    var eventLatitiude : Double
    var eventLongitude : Double
    var eventAltitude : Double
}
