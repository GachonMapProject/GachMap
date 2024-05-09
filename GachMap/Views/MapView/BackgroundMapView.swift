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

// CLLocationCoordinate2D를 감싸는 IdentifiableCoordinate 구조체 정의
struct IdentifiableLocation: Identifiable {
    var id = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
    var markerData: BuildingMarkerData
}

struct pinItem {
    var image : String
    var color : Color
}

// CoreLocationEx, Category, [CategoryData]을 받아야 함 
struct BackgroundMapView : View {
    
    // 카테고리 추가
    
    @Binding var selecetedCategory : String
    var locations : [IdentifiableLocation]
    @ObservedObject var coreLocation : CoreLocationEx

    @State var region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4507128, longitude: 127.13045), latitudinalMeters: 700, longitudinalMeters: 700))

    
    // category에 따라 바꿔줘야 됨
    @Binding var pinImage : String
    @Binding var pinColor : Color
    
    @State var selectedItem : String? // 마커 선택시 id
    
    @State var isARStart = false    // AR 캠퍼스 둘러보기 버튼 실행 유무
    
    init(selecetedCategory: Binding<String>, locations: [BuildingMarkerData], coreLocation: CoreLocationEx, pinImage :Binding<String>, pinColor : Binding<Color>) {
        _selecetedCategory = selecetedCategory // Binding 속성에 직접 바인딩
        self.locations = locations.map{IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: $0.placeLatitude, longitude: $0.placeLongitude), markerData: $0)}
        self.coreLocation = coreLocation
        _pinColor = pinColor
        _pinImage = pinImage
    }
    
    var body: some View {
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
                }
            }
            .onChange(of: selecetedCategory){
                region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4507128, longitude: 127.13045), latitudinalMeters: 700, longitudinalMeters: 700))
                print(pinImage, pinColor)
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
            }
           
        }
        
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



