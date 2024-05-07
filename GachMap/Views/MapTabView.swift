//
//  MapTabView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Alamofire

enum BuildingCategory: String, CaseIterable {
    case BUILDING = "건물"
    case SMOKING = "흡연구역"
    case FOOD = "음식점"
    case CAFE = "카페"
    case CONV = "편의점"
    case WELFARE = "복지시설"
    case PRINT = "인쇄"
    case BUSSTOP = "무당이 정류장"
}

struct MapTabView: View {
    // 검색창 활성화
    @State private var showLocationSearchView: Bool = false
    
    @State private var selectedCategory: BuildingCategory?
    @State private var buildingMarkers: [BuildingMarkerData] = []
    
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
    
//    ForEach(buildingMarkers) { markerData in
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: markerData.latitude, longitude: markerData.longitude)
//        annotation.title = markerData.placeName
//        
//        mapView.addAnnotation(annotation)
//    }
    
    // 카테고리 별 건물 목록 가져오기
//    private func getBuildingMarker() {
//        guard let placeCategory = selectedCategory,
//              let url = URL(string: "https://8eac-58-121-110-235.ngrok-free.app/map/\(placeCategory)")
//        else {
//            print("Invalid URL")
//            return
//        }
//        
//        AF.request(url, method: .get)
//            .validate()
//            .responseDecodable(of: BuildingMarkerResponse.self) { response in
//                print("Response: \(response)")
//                switch response.result {
//                case .success(let value):
//                    print(value)
//                    
//                    if(value.success == true) {
//                        print("카테고리 별 건물 목록 가져오기 성공")
//                        // self.placeName = value.data.placeName
//                        
//                    } else {
//                        print("카테고리 별 건물 목록 가져오기 실패")
//                    }
//                    
//                case .failure(let error):
//                    print("서버 연결 실패")
//                    print(url)
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//    }
    
    var body: some View {
        
        
        ZStack() {
            BackgroundMapView(category: category, locations: locations, coreLocation: coreLocation)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    // 카테고리 버튼
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(BuildingCategory.allCases, id: \.self) { category in
                                CategoryButton(category: category.rawValue)
                                    .onTapGesture {
                                        selectedCategory = category
                                    }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.top, 7)
                        .padding(.trailing, 20)
                    } // end of ScrollView of 카테고리 버튼
                }
                .padding(.top, 60)
                
                Spacer()
            }
            
            VStack {
                // 검색창
                /// 방법 1: sheet로 띄우기
    //                SearchMainView()
    //                    .onTapGesture {
    //                        showLocationSearchView.toggle()
    //                    }
    //                    .fullScreenCover(isPresented: $showLocationSearchView) {
    //                        LocationSearchView(showLocationSearchView: $showLocationSearchView)
    //                    }
                
                /// 방법 2: binding으로 화면 전환 넘기기
                if showLocationSearchView {
                    LocationSearchView(showLocationSearchView: $showLocationSearchView)
                } else {
                    SearchMainView()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showLocationSearchView.toggle()
                            }
                        }
                }
                // end of 검색창
                
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
