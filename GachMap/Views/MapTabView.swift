//
//  MapTabView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapTabView: View {
//
//    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 37.4507128, longitude: 127.13045),
//        span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
//    )
//    
//    @State private var myLocation: CLLocationCoordinate2D =
//    CLLocationCoordinate2D(latitude: 37.4507128, longitude: 127.13045)
//    
    // CoreLocationEx, Category, [CategoryData]을 받아야 함
    
    @ObservedObject var coreLocation = CoreLocationEx()
    var category = "흡연구역"
    var locations = [CategoryData(placeId: 1, placeName: "1-1", placeLatitude: 37.4508817, placeLongitude: 127.1274769, placeSummary: "Sum"),
                        CategoryData(placeId: 2, placeName: "1-2", placeLatitude: 37.4506271, placeLongitude: 127.1274554, placeSummary: "Sum"),
                        CategoryData(placeId: 3, placeName: "1-3", placeLatitude: 37.45062308, placeLongitude: 127.1276374, placeSummary: "Sum"),
                        CategoryData(placeId: 4, placeName: "1-4", placeLatitude: 37.45048746, placeLongitude: 127.1280814, placeSummary: "Sum")
    ]
    
    var body: some View {
        
        ZStack() {
            BackgroundMapView(category: category, locations: locations, coreLocation: coreLocation)
                .ignoresSafeArea()
            /// 지도
            /// (coordinateRegion: $region, showsUserLocation: true)
//            Map {
//                Marker("가천관", systemImage: "building.fill", coordinate: .gachon)
//                    .tint(.blue)
//                Marker("비전타워", systemImage: "building.fill", coordinate: .visiontower)
//                    .tint(.blue)
//                Marker("법과대학", systemImage: "building.fill", coordinate: .law)
//                    .tint(.blue)
//                Marker("공과대학1", systemImage: "building.fill", coordinate: .eng1)
//                    .tint(.blue)
//                Marker("공과대학2", systemImage: "building.fill", coordinate: .eng2)
//                    .tint(.blue)
//                Marker("한의과대학", systemImage: "building.fill", coordinate: .kmed)
//                    .tint(.blue)
//                Marker("예술･체육대학1", systemImage: "building.fill", coordinate: .ape1)
//                    .tint(.blue)
//                Marker("예술･체육대학2", systemImage: "building.fill", coordinate: .ape2)
//                    .tint(.blue)
//                Marker("AI관", systemImage: "building.fill", coordinate: .ai)
//                    .tint(.blue)
//                Marker("바이오나노대학", systemImage: "building.fill", coordinate: .bionano)
//                    .tint(.blue)
//                Marker("중앙도서관", systemImage: "building.fill", coordinate: .mainlib)
//                    .tint(.blue)
//                Marker("전자정보도서관", systemImage: "building.fill", coordinate: .eilib)
//                    .tint(.blue)
//                Marker("대학원･(원격)평생교육원", systemImage: "building.fill", coordinate: .gschool)
//                    .tint(.blue)
//                Marker("교육대학원", systemImage: "building.fill", coordinate: .eduschool)
//                    .tint(.blue)
//                Marker("바이오나노연구원", systemImage: "building.fill", coordinate: .bnresearch)
//                    .tint(.blue)
//                Marker("산학협력관1", systemImage: "building.fill", coordinate: .industry)
//                    .tint(.blue)
//                Marker("학생회관", systemImage: "building.fill", coordinate: .hak)
//                    .tint(.blue)
//                Marker("반도체대학", systemImage: "building.fill", coordinate: .su)
//                    .tint(.blue)
//                Marker("제1학생생활관", systemImage: "building.fill", coordinate: .dorm1)
//                    .tint(.blue)
//                Marker("제2학생생활관", systemImage: "building.fill", coordinate: .dorm2)
//                    .tint(.blue)
//                Marker("제3학생생활관", systemImage: "building.fill", coordinate: .dorm3)
//                    .tint(.blue)
//                Marker("글로벌센터", systemImage: "building.fill", coordinate: .global)
//                    .tint(.blue)
//                
//                Marker("반도체대학 흡연구역", systemImage: "skis.fill", coordinate: .ITskz1)
//                    .tint(.green)
//                Marker("글로벌센터 흡연구역", systemImage: "skis.fill", coordinate: .ITskz2)
//                    .tint(.green)
//                Marker("공과대학2 흡연구역", systemImage: "skis.fill", coordinate: .GDskz)
//                    .tint(.green)
//                Marker("예술･체육대학2 흡연구역", systemImage: "skis.fill", coordinate: .ARTskz)
//                    .tint(.green)
//                Marker("산학협력관1 흡연구역", systemImage: "skis.fill", coordinate: .SHskz)
//                    .tint(.green)
//                Marker("중앙도서관 흡연구역", systemImage: "skis.fill", coordinate: .LIBskz)
//                    .tint(.green)
//                Marker("AI관 흡연구역", systemImage: "skis.fill", coordinate: .AIskz)
//                    .tint(.green)
//                Marker("운동장 흡연구역", systemImage: "skis.fill", coordinate: .GRskz)
//                    .tint(.green)
//                Marker("제1학생생활관 흡연구역", systemImage: "skis.fill", coordinate: .DORskz)
//                    .tint(.green)
//            }
//            .ignoresSafeArea()
            
            VStack {
                // 검색창
                HStack {
                    Image("gachonMark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 33, height: 24, alignment: .leading)
                        .padding(.leading)
                    
                    Text("검색")
                        .font(.title3)
                        .foregroundColor(Color(.gray))
                    
                    Spacer()
                } // end of HStack (검색창)
                .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(radius: 7, x: 2, y: 2)
                )
                .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        // 버튼 1
                        Button(action: {}, label: {
                            HStack {
                                Image("gachonMark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 18, height: 13, alignment: .leading)
                                    .padding(.leading)
                                
                                Text("건물")
                                    .padding(.trailing)
                                    .foregroundColor(.black)
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                        .preference(key: WidthPreferenceKey.self, value: geometry.size.width) }
                                    )
                            }
                            .frame(height: 30)
                            .contentShape(.capsule)
                            .background(
                                Capsule()
                                    .fill(Color(UIColor.systemBackground))
                            )
                        }) // end of Button 1
                        
                        // 버튼 2
                        Button(action: {}, label: {
                            HStack {
                                Image("gachonMark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 18, height: 13, alignment: .leading)
                                    .padding(.leading)
                                
                                Text("무당이 정류장")
                                    .padding(.trailing)
                                    .foregroundColor(.black)
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                        .preference(key: WidthPreferenceKey.self, value: geometry.size.width) }
                                    )
                            }
                            .frame(height: 30)
                            //.contentShape(.capsule)
                            .background(
                                Capsule()
                                    .fill(Color(UIColor.systemBackground))
                            )
                        }) // end of Button 2
                        
                        // 버튼 2
                        Button(action: {}, label: {
                            HStack {
                                Image("gachonMark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 18, height: 13, alignment: .leading)
                                    .padding(.leading)
                                
                                Text("음식점")
                                    .padding(.trailing)
                                    .foregroundColor(.black)
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                        .preference(key: WidthPreferenceKey.self, value: geometry.size.width) }
                                    )
                            }
                            .frame(height: 30)
                            .contentShape(.capsule)
                            .background(
                                Capsule()
                                    .fill(Color(UIColor.systemBackground))
                            )
                        }) // end of Button 2
                        
                        // 버튼 3
                        Button(action: {}, label: {
                            HStack {
                                Image("gachonMark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 18, height: 13, alignment: .leading)
                                    .padding(.leading)
                                
                                // 보건실,
                                Text("복지시설")
                                    .padding(.trailing)
                                    .foregroundColor(.black)
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                        .preference(key: WidthPreferenceKey.self, value: geometry.size.width) }
                                    )
                            }
                            .frame(height: 30)
                            .contentShape(.capsule)
                            .background(
                                Capsule()
                                    .fill(Color(UIColor.systemBackground))
                            )
                        }) // end of Button 3
                        
                        // 버튼 4
                        Button(action: {}, label: {
                            HStack {
                                Image("gachonMark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 18, height: 13, alignment: .leading)
                                    .padding(.leading)
                                
                                Text("흡연구역")
                                    .padding(.trailing)
                                    .foregroundColor(.black)
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                        .preference(key: WidthPreferenceKey.self, value: geometry.size.width) }
                                    )
                            }
                            .frame(height: 30)
                            .contentShape(.capsule)
                            .background(
                                Capsule()
                                    .fill(Color(UIColor.systemBackground))
                            )
                        }) // end of Button 4
                        
                        // 버튼 3
                        // ...
                        
                    }
                    .padding(.leading, 20)
                    .padding(.top, 7)
                    .padding(.trailing, 20)
                }
                
                
//                // AR, 현재 위치 버튼
//                HStack {
//                    Spacer()
//                    VStack {
//                        Spacer()
//                        
//                        Button("AR") {
//                            
//                        }
//                        // end of AR Button
//                        
//                        Spacer()
//                        
//                        Divider()
//                        
//                        Spacer()
//                        
//                        Button("위치") {
//                            let manager = CLLocationManager()
//                            manager.desiredAccuracy = kCLLocationAccuracyBest
//                            manager.requestWhenInUseAuthorization()
//                            manager.startUpdatingLocation()
//                            
//                            let latitude = manager.location?.coordinate.latitude
//                            let longitude = manager.location?.coordinate.longitude
//                            
//                            region = MKCoordinateRegion (
//                                center: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!),
//                                span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
//                            )
//                        } // end of location Button
//                        
//                        Spacer()
//                    }
//                    .frame(width: 49.0, height: UIScreen.main.bounds.width - 290)
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(Color(UIColor.systemBackground))
//                            .shadow(radius: 7, x: 2, y: 2)
//                    )
//                    .padding(.top)
//                    .padding(.trailing)
//                } // end of HStack (AR, 현재 위치 버튼)
                
                Spacer()
                
            }
        }
        
    }
}

struct WidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension CLLocationCoordinate2D {
    static let gachon = CLLocationCoordinate2D(latitude: 37.4504, longitude: 127.1299)
    static let visiontower = CLLocationCoordinate2D(latitude: 37.4496, longitude: 127.1273)
    static let law = CLLocationCoordinate2D(latitude: 37.4492, longitude: 127.1275)
    static let eng1 = CLLocationCoordinate2D(latitude: 37.4516, longitude: 127.128)
    static let eng2 = CLLocationCoordinate2D(latitude: 37.4493, longitude: 127.1285)
    static let kmed = CLLocationCoordinate2D(latitude: 37.45, longitude: 127.1287)
    static let ape1 = CLLocationCoordinate2D(latitude: 37.4522, longitude: 127.1288)
    static let ape2 = CLLocationCoordinate2D(latitude: 37.4517, longitude: 127.1297)
    static let ai = CLLocationCoordinate2D(latitude: 37.4553, longitude: 127.134)
    static let bionano = CLLocationCoordinate2D(latitude: 37.4527, longitude: 127.1295)
    static let mainlib = CLLocationCoordinate2D(latitude: 37.4524, longitude: 127.1331)
    static let eilib = CLLocationCoordinate2D(latitude: 37.4508, longitude: 127.1287)
    static let gschool = CLLocationCoordinate2D(latitude: 37.4527, longitude: 127.1301)
    static let eduschool = CLLocationCoordinate2D(latitude: 37.4519, longitude: 127.1317)
    static let bnresearch = CLLocationCoordinate2D(latitude: 37.4499, longitude: 127.1281)
    static let industry = CLLocationCoordinate2D(latitude: 37.4495, longitude: 127.1296)
    static let su = CLLocationCoordinate2D(latitude: 37.451, longitude: 127.1272)
    static let hak = CLLocationCoordinate2D(latitude: 37.4532, longitude: 127.1344)
    static let dorm1 = CLLocationCoordinate2D(latitude: 37.4564, longitude: 127.1354)
    static let dorm2 = CLLocationCoordinate2D(latitude: 37.4562, longitude: 127.1346)
    static let dorm3 = CLLocationCoordinate2D(latitude: 37.4559, longitude: 127.1332)
    static let global = CLLocationCoordinate2D(latitude: 37.4519, longitude: 127.1272)
    
    static let ITskz1 = CLLocationCoordinate2D(latitude: 37.450705, longitude: 127.127088)
    static let ITskz2 = CLLocationCoordinate2D(latitude: 37.451489, longitude: 127.127255)
    static let GDskz = CLLocationCoordinate2D(latitude: 37.449199, longitude: 127.128001)
    static let ARTskz = CLLocationCoordinate2D(latitude: 37.451523, longitude: 127.129532)
    static let SHskz = CLLocationCoordinate2D(latitude: 37.4498, longitude: 127.1294)
    static let LIBskz = CLLocationCoordinate2D(latitude: 37.452441, longitude: 127.132681)
    static let AIskz = CLLocationCoordinate2D(latitude: 37.455288, longitude: 127.133055)
    static let GRskz = CLLocationCoordinate2D(latitude: 37.455843, longitude: 127.134886)
    static let DORskz = CLLocationCoordinate2D(latitude: 37.456, longitude: 127.1355)
}

#Preview {
    MapTabView()
}
