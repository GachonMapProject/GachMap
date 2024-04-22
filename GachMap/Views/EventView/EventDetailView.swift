//
//  EventDetailView.swift
//  GachMap
//
//  Created by 이수현 on 4/16/24.
//

import SwiftUI
import MapKit

// CLLocationCoordinate2D를 감싸는 IdentifiableCoordinate 구조체 정의
struct IdentifiableCoordinate: Identifiable {
    var id = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
    var placeName : String
}


struct EventDetailView: View {
    let eventDetail : [EventDetail]
    let eventCoordinate : [IdentifiableCoordinate] // 행사 위치의 좌표들
    @State var destination : IdentifiableCoordinate
    
    @State var region : MapCameraPosition
    @State var isSearch = false
    @State var selectedItem : String? // 마커 선택시 id
    
    init(eventDetail : [EventDetail]){
        self.eventDetail = eventDetail
        self.eventCoordinate = eventDetail.map{
            IdentifiableCoordinate(coordinate: CLLocationCoordinate2D(latitude: $0.eventLatitude, longitude: $0.eventLongitude),
                                   placeName: $0.eventPlaceName)
        }
        self.destination = eventCoordinate[0]
 
        let region = MKCoordinateRegion(center: eventCoordinate[0].coordinate,
                                         latitudinalMeters: 200,
                                         longitudinalMeters: 200)
        self.region = MapCameraPosition.region(region)
    }

    var body: some View {
        NavigationStack {
            VStack{
                ZStack(alignment : .top){
                    Map(position: $region, selection: $selectedItem){
                        ForEach(eventCoordinate){ event in
                            Marker(event.placeName, systemImage: "party.popper.fill", coordinate: event.coordinate)
                                .tint(.red)
                        }
                    }
                    .onChange(of: selectedItem){
                        if  !eventCoordinate.filter({$0.id == selectedItem}).isEmpty {
                            let event = eventCoordinate.filter{$0.id == selectedItem}[0]
                            let region = MKCoordinateRegion(center: event.coordinate,
                                                             latitudinalMeters: 200,
                                                             longitudinalMeters: 200)
                            self.region = MapCameraPosition.region(region)
                            destination = event
                        }
                    }
                    
                    HStack{
                        VStack{
                            Image(.gachonMark)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                        .frame(width: 60, height: 60)
                       
                        
                        Text(destination.placeName)
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .bold()
                        Spacer()
                    }
                    .background(.white)
                    .frame(height: 50)
                    .cornerRadius(20)
                    .shadow(radius: 7, x: 2, y: 2)
                    .padding()
                    
                    VStack{
                        Spacer()
                        // 검색창으로 넘길 때, destination의 정보를 같이 넘겨줘야 됨
                        Button(action: {
                            isSearch = true
                            
                        }, label: {
                            Text("도착지 설정")
                                .font(.system(size: 16))
                                .bold()
                        })
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(Capsule()
                        .fill(Color(UIColor.systemBlue)))
                        .shadow(radius: 7, x: 2, y: 2)
                        .padding()
                    }
                } // end of ZStack
                
            } // end of VStack
        
            // 검색창으로 넘길 때, destination의 정보를 같이 넘겨줘야 됨
            NavigationLink(destination: Text("검색뷰 : \(destination.placeName) \n 위치 : \(destination.coordinate.latitude), \(destination.coordinate.longitude)"), isActive: $isSearch) {
                EmptyView()
            }
//            .navigationTitle(eventDetail[0].eventName)
        } // end of NavigationView
    }
}


//#Preview {
//
//    EventDetailView(eventDetail: EventDetail(eventDto: EventDto(eventId: 1, eventName: "가천대학교 축구 리그", eventStartDate: Date(), eventEndate: Date(), eventLink: "www.naver.com", eventInfo: "가천대에서 축구 리그가 열려요", imageData: Data()), eventLocationDto: [
//        EventLocationDto(eventPlaceName: "반도체 대학 정문", eventLatitiude: 37.4508817, eventLongitude: 127.1274769, eventAltitude: 50.23912),
//        EventLocationDto(eventPlaceName: "광장계단 근처", eventLatitiude: 37.45048746, eventLongitude: 127.1280814, eventAltitude: 50.23912),
//        EventLocationDto(eventPlaceName: "반도체대학 코너", eventLatitiude: 37.4506271, eventLongitude: 127.1274554, eventAltitude: 50.23912)
//    ]))
//}
