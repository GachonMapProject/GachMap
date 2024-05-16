//
//  ResultSelectView.swift
//  GachMap
//
//  Created by 원웅주 on 5/8/24.
//

// 검색 결과 선택 화면

import SwiftUI
import MapKit
import Alamofire

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

extension SearchDetailData {
    static var defaultData: SearchDetailData {
        return SearchDetailData(placeName: "기본 위치", placeLatitude: 37.4508, placeLongitude: 127.1292, placeSummary: "기본 요약", placeId: 0, mainImagePath: "gachonMark")
    }
}

class DetailResultViewModel: ObservableObject {
    
    @Published var detailResults: SearchDetailData
    var placeId: Int
    
//    lazy var places: [Place] = [
//            Place(name: detailResults.placeName, coordinate: CLLocationCoordinate2D(latitude: detailResults.placeLatitude, longitude: detailResults.placeLongitude))
//        ]
    
    init(placeId: Int) {
        self.placeId = placeId
        self.detailResults = SearchDetailData.defaultData
        getSearchResult()
    }
    
    // 키워드 상세 정보 가져오기
    func getSearchResult() {
        
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/find/\(placeId)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: SearchDetailResponse.self) { response in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    if(value.success == true) {
                        print("건물 상세정보 가져오기 성공")
                        print(url)
                        self.detailResults = value.data
                    } else {
                        print("건물 상세정보 가져오기 실패")
                    }
                    
                case .failure(let error):
                    // 서버 연결 실패할 때도 검색 결과 없음 표시
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

struct ResultSelectView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var detailViewModel: DetailResultViewModel
    
//    @Environment(\.dismiss) private var dismiss
//    @ObservedObject var detailViewModel: DetailResultViewModel
//    
//    let locationCoordinate: [Place]
//    @State var destination: Place
//    
//    @State var region: MKCoordinateRegion
//    @State private var selectedResult: MKMapItem?
//    
//    init(detailViewModel: DetailResultViewModel) {
//        self._detailViewModel = ObservedObject(initialValue: detailViewModel)
//        self._region = State(initialValue: MKCoordinateRegion(
//            center: CLLocationCoordinate2D(
//                latitude: detailViewModel.detailResults.placeLatitude,
//                longitude: detailViewModel.detailResults.placeLongitude),
//            span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
//        ))
//    }
    
    var body: some View {
        NavigationView {
            // 경도: Long, 위도: Lati
            ZStack {
                // coordinateRegion: .constant(region)
//                Map(position: $region, selection: $selectedResult) {
//                    Marker(detailViewModel.detailResults.placeName,
//                           coordinate: CLLocationCoordinate2D(latitude: detailViewModel.detailResults.placeLatitude,
//                                                              longitude: detailViewModel.detailResults.placeLongitude))
//                }
                
//                Map(coordinateRegion: $region, annotationItems: detailViewModel.places) { place in
//                    MapMarker(coordinate: place.coordinate, tint: .gachonSky)
//                }
//                .ignoresSafeArea()
                
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: detailViewModel.detailResults.placeLatitude, longitude: detailViewModel.detailResults.placeLongitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))),
                    annotationItems: [Place(name: detailViewModel.detailResults.placeName, coordinate: CLLocationCoordinate2D(latitude: detailViewModel.detailResults.placeLatitude, longitude: detailViewModel.detailResults.placeLongitude))]) { place in
                    MapMarker(coordinate: place.coordinate, tint: .gachonSky)
                }
                .ignoresSafeArea()
                
                // 검색창 및 카드뷰
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation(.spring()) {
                                dismiss()
                            }
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.black)
                                // .frame(width: 33, alignment: .leading)
                                .padding(.leading)
                        })
                        
                        Text(detailViewModel.detailResults.placeName)
                            .font(.title3)
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(radius: 7, x: 2, y: 2)
                    )
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    SearchSpotDetailCard(placeId: detailViewModel.detailResults.placeId, placeName: detailViewModel.detailResults.placeName, placeSummary: detailViewModel.detailResults.placeSummary, mainImagePath: detailViewModel.detailResults.mainImagePath, inCategory : false, isBuilding: false)
                        //.padding(.bottom)
                }
                // 검색창 및 카드뷰 끝
                
            } // end of ZStack
        }
        .navigationBarBackButtonHidden()
        
    }

}

#Preview {
    ResultSelectView(detailViewModel: DetailResultViewModel(placeId: 121))
}
