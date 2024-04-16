//
//  BackgroundMapView.swift
//  GachMap
//
//  Created by 이수현 on 4/16/24.
//

import SwiftUI
import MapKit

// CLLocationCoordinate2D를 감싸는 IdentifiableCoordinate 구조체 정의
struct IdentifiableLocation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var categoryData : CategoryData
}

struct pinItem {
    var image : String
    var color : Color
}

// CoreLocationEx, Category, [CategoryData]을 받아야 함 
struct BackgroundMapView : View {
    
    var categoryPinItem = ["건물" : pinItem(image: "building.fill", color: Color.blue),
                        "흡연구역" : pinItem(image: "skis.fill", color: Color.green),
                        "편의시설" : pinItem(image: "skis.fill", color: Color.green)] as [String : Any]// 카테고리 추가
    
    var category : String
    var locations : [IdentifiableLocation]
    @ObservedObject var coreLocation : CoreLocationEx
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4507128, longitude: 127.13045), latitudinalMeters: 700,
                                           longitudinalMeters: 700)
    
    // category에 따라 바꿔줘야 됨
    @State var pinImage : String
    @State var pinColor : Color
    
    @State var isARStart = false    // AR 캠퍼스 둘러보기 버튼 실행 유무
    
    init(category : String, locations: [CategoryData], coreLocation: CoreLocationEx) {
        self.category = category
        self.locations = locations.map{IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: $0.placeLatitude, longitude: $0.placeLongitude), categoryData : $0)}
        self.coreLocation = coreLocation
        
        // 핀 이미지, 백그라운드 색 설정
        if let pinItem = categoryPinItem[category] as? pinItem {
              self.pinImage = pinItem.image
              self.pinColor = pinItem.color
          } else {
              self.pinImage = "building.fill" // 기본 이미지
              self.pinColor = Color.blue // 기본 색상
       }
        
    }
    
    var body: some View {
        ZStack(alignment : .bottomTrailing){
            Map(coordinateRegion: $region, showsUserLocation: true,  annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button {
                        region = MKCoordinateRegion(center: location.coordinate,
                                                    latitudinalMeters: 150,
                                                    longitudinalMeters: 150)
                        // 카드 뷰 띄우는 함수 추가해야 함
                   } label: {
                       VStack {
                           ZStack{
                               Circle()
                                   .frame(width: 20, height: 20)
                                   .foregroundColor(pinColor)
                                   
                               Image(systemName: pinImage)
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 10, height: 10)
                                   .foregroundColor(.white)
                           }
    //                       Text(location.categoryData.placeName)
    //                           .font(.system(size: 12))
    //                           .foregroundColor(.black)
    //                           .bold()
                       }
                   }

               }
            } // end of Map
            .edgesIgnoringSafeArea(.bottom)
            
            VStack(spacing: 0){
                Button(action: {
                    // AR 캠퍼스 둘러보기 기능 추가해야 함
                    isARStart.toggle()
                },
                       label: {Text("AR")})
                .frame(width: 45, height: 50)
                .foregroundColor(.gray)
                .bold()
                
                Divider().background(.gray) // 중앙선

                Button(action: {
                    // 버튼을 누를 때 현재 위치를 중심으로 지도의 중심을 설정하는 함수 호출
                    setRegionToUserLocation()
                }, label: {Image(systemName: "location")})
                .frame(width: 45, height: 50)
                .foregroundColor(.gray)
                .bold()
                
            }
            .frame(width: 45, height: 100)
            .background(.white)
            .cornerRadius(15)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 20)) // bottomTrailing 마진 추가
        }
        
    }
    // 현재 위치를 기반으로 지도의 중심을 설정하는 함수
    func setRegionToUserLocation() {
        if let userLocation = coreLocation.location {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            self.region = region
        }
    }
}


