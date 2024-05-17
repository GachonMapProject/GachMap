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
    @Binding var showSearchView: Bool
    @Binding var showSheet : Bool
    
    let categoryPinItem = ["BUILDING" : pinItem(image: "building.fill", color: Color.blue),
                           "SMOKING" : pinItem(image: "flame.fill", color: Color.brown),
                           "FOOD": pinItem(image: "fork.knife", color: Color.orange),
                           "CAFE": pinItem(image: "cup.and.saucer.fill", color: Color.green),
                           "CONV": pinItem(image: "storefront.fill", color: Color.cyan),
                           "WELFARE": pinItem(image: "cross.fill", color: Color.pink),
                           "PRINT": pinItem(image: "printer.fill", color: Color.mint),
                           "BUSSTOP" : pinItem(image: "ladybug.fill", color: Color.red)] as [String : Any]
    
    // 검색창 활성화
    @State private var showLocationSearchView: Bool = false
    
    //@State private var buildingMarkers: [BuildingMarkerData] = []
    @State var locations: [BuildingMarkerData] = []
    // category에 따라 바꿔줘야 됨
    @State var pinImage : String = "building.fill"
    @State var pinColor : Color = Color.blue
    
    //var buildingDatas: [BuildingMarkerData]
    
    // CoreLocationEx, Category, [CategoryData]을 받아야 함
    
    @EnvironmentObject var coreLocation : CoreLocationEx
    @EnvironmentObject var globalViewModel : GlobalViewModel
    @State var category = "BUILDING" // 선택한 카테고리 넘겨주기
    @State var selecetedCategory = "BUILDING"
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
            BackgroundMapView(showSheet : $showSheet, selecetedCategory: $selecetedCategory, locations: locations, pinImage : $pinImage, pinColor : $pinColor)
                .ignoresSafeArea()
                .onChange(of: selecetedCategory){
                    // 핀 이미지, 백그라운드 색 설정
                    if let pinItem = categoryPinItem[$selecetedCategory.wrappedValue] as? pinItem { // selecetedCategory 속성에 접근할 때 .wrappedValue를 사용하여 값에 접근
                        print("category : \($selecetedCategory.wrappedValue)")
                        print("pinItem : \(pinItem)")
                        self.pinImage = pinItem.image
                        self.pinColor = pinItem.color
                    } else {
                        print("pinItem else: \($selecetedCategory.wrappedValue)")
                        self.pinImage = "building.fill" // 기본 이미지
                        self.pinColor = Color.blue // 기본 색상
                    }
                }
            
            VStack {
                HStack {
                    // 카테고리 버튼
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(BuildingCategory.allCases, id: \.self) { category in
//                                CategoryButton(viewModel: BuildingMarkerViewModel(), locations: $locations, category: category.rawValue)
                                CategoryButton(locations: $locations, selectedCategory: $selecetedCategory, category: category.rawValue)
//                                    .onTapGesture {
//                                        selectedCategory = category
//                                        print("selectedCategory : \(String(describing: selectedCategory))")
//                                    }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.top, 15)
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
//                if showLocationSearchView {
//                    SearchMainView(showLocationSearchView: $showLocationSearchView)
//                } else {
//                    SearchMainBar()
//                        .onTapGesture {
//                            withAnimation(.spring()) {
//                                // showLocationSearchView.toggle()
//                                showSearchView = true
//                            }
//                        }
//                }
                // end of 검색창
                SearchMainBar()
                    .onTapGesture {
                        showSearchView = true
                    }
                
                Spacer()
            }
            
            NavigationLink("", isActive: $globalViewModel.isARStart) {
                ARCampusView()
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarBackButtonHidden()
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
