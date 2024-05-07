//
//  CategoryButton.swift
//  GachMap
//
//  Created by 원웅주 on 5/6/24.
//

import SwiftUI
import Alamofire

struct CategoryButton: View {
    
    let category: String
    
    // 카테고리 별 건물 목록 가져오기
    private func getBuildingMarker(placeCategory: String) {
//        let placeCategory = BuildingCategory(rawValue: category)
        
        guard let url = URL(string: "https://8eac-58-121-110-235.ngrok-free.app/map/\(placeCategory)")
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
                    print(value)
                    
                    if(value.success == true) {
                        print("카테고리 별 건물 목록 가져오기 성공")
                        // data에 담긴 정보를 넘겨줘야돼
                        
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
    
    var body: some View {
        // 버튼 1
        Button(action: {
            if let placeCat = BuildingCategory(rawValue: category) {
                getBuildingMarker(placeCategory: placeCat.rawValue)
            }
            
        }, label: {
            HStack {
                Image("gachonMark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 13, alignment: .leading)
                    .padding(.leading)
                
                Text(category)
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
}

//#Preview {
//    CategoryButton()
//}
