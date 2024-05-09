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
    case building = "BUILDING" // 건물
    case smoking = "SMOKING" // 흡연구역
    case food = "FOOD" // 음식점
    case cafe = "CAFE" // 카페
    case conv = "CONV" // 편의점
    case werfare = "WELFARE" // 복지시설
    case print = "PRINT" // 인쇄
    case busstop = "BUSSTOP" // 무당이 정류장
}

struct MapTabView: View {
    
    // 검색창 활성화
    @State private var showLocationSearchView: Bool = false
    
    //@State private var buildingMarkers: [BuildingMarkerData] = []
    @State var locations: [BuildingMarkerData] = []
    
    //var buildingDatas: [BuildingMarkerData]
    
    // CoreLocationEx, Category, [CategoryData]을 받아야 함
    
    @ObservedObject var coreLocation = CoreLocationEx()
    @State var category = "BUILDING" // 선택한 카테고리 넘겨주기
//    var locations = [CategoryData(placeId: 1, placeName: "1-1", placeLatitude: 37.4508817, placeLongitude: 127.1274769, placeSummary: "Sum"),
//                        CategoryData(placeId: 2, placeName: "1-2", placeLatitude: 37.4506271, placeLongitude: 127.1274554, placeSummary: "Sum"),
//                        CategoryData(placeId: 3, placeName: "1-3", placeLatitude: 37.45062308, placeLongitude: 127.1276374, placeSummary: "Sum"),
//                        CategoryData(placeId: 4, placeName: "1-4", placeLatitude: 37.45048746, placeLongitude: 127.1280814, placeSummary: "Sum")
//    ]
    
    //var locations: [BuildingMarkerData] = []
    
//    var locations = [BuildingMarkerData(placeName: buildingDatas.placeName, placeLatitude: buildingDatas.placeLatitude, placeLongitude: buildingDatas.placeLongitude)]
    
    // data의 개수만큼 ForEach
    
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
//                                CategoryButton(viewModel: BuildingMarkerViewModel(), locations: $locations, category: category.rawValue)
                                CategoryButton(locations: $locations, category: category.rawValue)
//                                    .onTapGesture {
//                                        selectedCategory = category
//                                        print("selectedCategory : \(String(describing: selectedCategory))")
//                                    }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.top, 20)
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
                    SearchMainView(showLocationSearchView: $showLocationSearchView)
                } else {
                    SearchMainBar()
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

//#Preview {
//    MapTabView()
//}
