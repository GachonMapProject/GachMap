////
////  BackMapTest.swift
////  GachMap
////
////  Created by 이수현 on 4/16/24.
////
//
//import SwiftUI
//
//struct BackMapTest: View {
//    
//    // CoreLocationEx, Category, [CategoryData]을 받아야 함
//    @ObservedObject var coreLocation = CoreLocationEx()
//    var category = "건물"
//    var locations = [CategoryData(placeId: 1, placeName: "1-1", placeLatitude: 37.4508817, placeLongitude: 127.1274769, placeSummary: "Sum"),
//                        CategoryData(placeId: 2, placeName: "1-2", placeLatitude: 37.4506271, placeLongitude: 127.1274554, placeSummary: "Sum"),
//                        CategoryData(placeId: 3, placeName: "1-3", placeLatitude: 37.45062308, placeLongitude: 127.1276374, placeSummary: "Sum"),
//                        CategoryData(placeId: 4, placeName: "1-4", placeLatitude: 37.45048746, placeLongitude: 127.1280814, placeSummary: "Sum")
//    ]
//    
//    var body: some View {
//        BackgroundMapView(category: category, locations: locations, coreLocation: coreLocation) // MapTabView에 Map{} 대신 넣기
//        
//        // To Do: 
//    }
//}
//
//#Preview {
//    BackMapTest()
//}
