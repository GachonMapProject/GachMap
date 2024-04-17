//
//  GachMapApp.swift
//  GachMap
//
//  Created by 원웅주 on 4/15/24.
//

import SwiftUI

@main
struct GachMapApp: App {
    var body: some Scene {
        WindowGroup {
//            EventDetailView(eventDetail: EventDetail(eventDto: EventDto(eventId: 1, eventName: "가천대학교 축구 리그", eventStartDate: Date(), eventEndate: Date(), eventLink: "www.naver.com", eventInfo: "가천대에서 축구 리그가 열려요", imageData: Data()), eventLocationDto: [
//                EventLocationDto(eventPlaceName: "반도체 대학 정문", eventLatitiude: 37.4508817, eventLongitude: 127.1274769, eventAltitude: 50.23912),
//                EventLocationDto(eventPlaceName: "광장계단 근처", eventLatitiude: 37.45048746, eventLongitude: 127.1280814, eventAltitude: 50.23912),
//                EventLocationDto(eventPlaceName: "반도체대학 코너", eventLatitiude: 37.4506271, eventLongitude: 127.1274554, eventAltitude: 50.23912)
//            ]))
            BuildingDetailView()
        }
    }
}
