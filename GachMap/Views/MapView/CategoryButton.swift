//
//  CategoryButton.swift
//  GachMap
//
//  Created by 원웅주 on 5/6/24.
//

import SwiftUI
import Alamofire


struct CategoryButton: View {
//    @ObservedObject var viewModel: BuildingMarkerViewModel

    let categoryToKorean: [String: String] = [
        "BUILDING": "건물",
        "SMOKING": "흡연구역",
        "FOOD": "음식점",
        "CAFE": "카페",
        "CONV": "편의점",
        "WELFARE": "복지시설",
        "PRINT": "인쇄",
        "BUSSTOP": "무당이 정류장"
    ]
    
    @Binding var locations: [BuildingMarkerData]
    @Binding var selectedCategory : String
    var category: String

    var body: some View {
        // 버튼
        Button(action: {
//            if let placeCat = BuildingCategory(rawValue: category) {
//                viewModel.getBuildingMarker(placeCategory: placeCat.rawValue) {
//                    self.locations = $0 // 클로저가 새 데이터를 제공한다고 가정
//                }
//            } 
            getBuildingMarker(placeCategory: category)
            selectedCategory = category
            print("category : \(category)")
            
        }, label: {
            HStack {
                Image("gachonMark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 13, alignment: .leading)
                    .padding(.leading)
                
                Text(categoryToKorean[category] ?? "")
                    .font(.system(size: 15))
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
    }
    
    
    // 카테고리 별 건물 목록 가져오기
    func getBuildingMarker(placeCategory: String) {
        
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/\(placeCategory)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: BuildingMarkerResponse.self) { response in
                print("Response: \(response)")
                switch response.result {
                case .success(let value):
                    print("getBuildingMarker - Success")
                    print(value.data)
                    
                    if(value.success == true) {
                        print("카테고리 별 건물 목록 가져오기 성공")
                        // data에 담긴 정보를 넘겨줘야돼
                        // self.buildingDatas = value.data
                        locations = value.data
                        
                    } else {
                        print("카테고리 별 건물 목록 가져오기 실패")
                    }
                    
                case .failure(let error):
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

//#Preview {
//    CategoryButton()
//}


//class BuildingMarkerViewModel: ObservableObject {
//    @Published var buildingDatas: [BuildingMarkerData] = []
//    
//    // 카테고리 별 건물 목록 가져오기
//    func getBuildingMarker(placeCategory: String, completion: @escaping ([BuildingMarkerData]) -> Void) {
//        
//        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/\(placeCategory)")
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
//                        // data에 담긴 정보를 넘겨줘야돼
//                        // self.buildingDatas = value.data
//                        completion(value.data)
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
//}
