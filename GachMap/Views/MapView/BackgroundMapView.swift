//
//  BackgroundMapView.swift
//  GachMap
//
//  Created by 이수현 on 4/16/24.
//

//case BUILDING = "건물"
//case SMOKING = "흡연구역"
//case FOOD = "음식점"
//case CAFE = "카페"
//case CONV = "편의점"
//case WELFARE = "복지시설"
//case PRINT = "인쇄"
//case BUSSTOP = "무당이 정류장"

import SwiftUI
import MapKit
import Alamofire

// CLLocationCoordinate2D를 감싸는 IdentifiableCoordinate 구조체 정의
struct IdentifiableLocation: Identifiable {
    var id : Int
    var coordinate: CLLocationCoordinate2D
    var markerData: BuildingMarkerData
}

struct pinItem {
    var image : String
    var color : Color
}

// CoreLocationEx, Category, [CategoryData]을 받아야 함 
struct BackgroundMapView : View {
    
    @Binding var showSheet : Bool
    // 카테고리 추가
    @Binding var selecetedCategory : String
    var locations : [IdentifiableLocation]
    @EnvironmentObject var coreLocation : CoreLocationEx

    @State var region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4507128, longitude: 127.13045), latitudinalMeters: 700, longitudinalMeters: 700))

    
    // category에 따라 바꿔줘야 됨
    @Binding var pinImage : String
    @Binding var pinColor : Color
    
    @State var selectedItem : Int? // 마커 선택시 id
    @State var showDetalView = false
    
    @State var selectedPlaceId = -1
    @State var selectedPlaceName = ""
    @State var selectedPlaceSummary = ""
    @State var selectedImagePath = ""
    
    @State var isBuilding = false
    
    
    @State var isARStart = false    // AR 캠퍼스 둘러보기 버튼 실행 유무
    
    @GestureState private var isTapOutside: Bool = false    // 탭 제스처
    
    init(showSheet :Binding<Bool>, selecetedCategory: Binding<String>, locations: [BuildingMarkerData], pinImage :Binding<String>, pinColor : Binding<Color>) {
        _showSheet = showSheet
        _selecetedCategory = selecetedCategory // Binding 속성에 직접 바인딩
        self.locations = locations.map{IdentifiableLocation(id : $0.placeId, coordinate: CLLocationCoordinate2D(latitude: $0.placeLatitude, longitude: $0.placeLongitude), markerData: $0)}
//        self.coreLocation = coreLocation
        _pinColor = pinColor
        _pinImage = pinImage
    }
    
    var body: some View {
        ZStack(alignment : .bottom){
            ZStack(alignment : .topTrailing){
                Map(position: $region, selection: $selectedItem){
                    UserAnnotation() // 사용자 현재 위치
                    ForEach(locations){ location in
                        Marker(location.markerData.placeName, systemImage: pinImage, coordinate: location.coordinate)
                            .tint(pinColor)
                    }
                }
                .onChange(of: selectedItem){
                    //                print("selectedItem : \(String(describing: selectedItem))")
                    if selectedItem != nil {
                        let location = locations.filter{$0.id == selectedItem}
                        let region = MKCoordinateRegion(center: location[0].coordinate,
                                                        latitudinalMeters: 200,
                                                        longitudinalMeters: 200)
                        self.region = MapCameraPosition.region(region)
                        
                        // 뷰 띄우기
                        if selecetedCategory == "BUILDING" {
                            isBuilding = true
                        }else{
                            isBuilding = false
                        }
                        selectedPlaceId = location[0].markerData.placeId
                        selectedPlaceName = location[0].markerData.placeName
                        selectedPlaceSummary = location[0].markerData.placeSummary
                        selectedImagePath = location[0].markerData.mainImagePath ?? ""
                        showSheet = false
                        showDetalView = true
                        
                        
                    }
                }
                .onChange(of: selecetedCategory){ category in
                    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4507128, longitude: 127.13045), latitudinalMeters: 700, longitudinalMeters: 700)
                    withAnimation(.easeInOut (duration : 1.0)){
                        self.region = MapCameraPosition.region(region)
                    }
                    
                    showSheet = true
                    showDetalView = false
                }
                .onDisappear(){
                    showSheet = false
                }
                
                VStack{
                    //                Spacer()
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
                        }, label: {Image(systemName: "scope")})
                        .frame(width: 45, height: 50)
                        .foregroundColor(.gray)
                        .bold()
                        
                        Divider().background(.gray) // 중앙선
                        
                        Button(action: {
                            // 버튼을 누를 때 기존 지도 중심으로 설정
                            withAnimation(.easeInOut(duration: 1.0)){
                                region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4507128, longitude: 127.13045), latitudinalMeters: 700, longitudinalMeters: 700))
                            }
                        }, label: {Image(systemName: "graduationcap")})
                        .frame(width: 45, height: 50)
                        .foregroundColor(.gray)
                        .bold()
                        
                    }
                    .frame(width: 45, height: 150)
                    .background(.white)
                    .cornerRadius(15)
                    .padding(EdgeInsets(top: 200, leading: 0, bottom: 0, trailing: 20))  // bottomTrailing 마진 추가
                    Spacer()
                } // end of VStack
            } // end of ZStack(alignment : .topTrailing)
            if showDetalView {
                SearchSpotDetailCard(placeId : selectedPlaceId, placeName: selectedPlaceName, placeSummary: selectedPlaceSummary, mainImagePath: selectedImagePath, inCategory: true, isBuilding : isBuilding)
                    .padding(.bottom, 100)
                
            }
        } // end of ZStack
        .gesture(
            TapGesture()
                .onEnded { _ in
                    self.showDetalView = false
                    self.showSheet = true
                }
                .updating($isTapOutside) { value, state, _ in
                    state = true
                }
        )
        
    }
    // 현재 위치를 기반으로 지도의 중심을 설정하는 함수
    func setRegionToUserLocation() {
        if let userLocation = coreLocation.location {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
            
            // 애니메이션 추가 
            withAnimation(.easeInOut(duration: 1.0)){
                self.region = MapCameraPosition.region(region)
            }
        }
    }
}



