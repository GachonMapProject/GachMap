//
//  FavTabView.swift
//  MoodangMapTest
//
//  Created by 원웅주 on 2/29/24.
//

import SwiftUI
import Alamofire


struct BuildingTabView: View {
    
    @State var apiConnection = false
    @State private var searchText = ""
    @State var buildingList : [BuildingList] = [
       BuildingList(placeId: 0, placeName: "가천관", thumbnailImagePath: ""),
//        BuildingListData(buildingCode: 2, buildingName: "비전타워"),
//        BuildingListData(buildingCode: 3, buildingName: "학생회관"),
    ]

    @State private var selection: UUID? // 리스트 선택
    //        let data = [globalBuilding]
    let titles = ["글로벌캠퍼스", "메디컬캠퍼스"]

    @State var serverAlert = false  // 서버 통신 실패 알림
    @State var nilData = false  // data가 없을 때 알림
    
    var body: some View {
        NavigationView {
            if !apiConnection {
                ProgressView()
                    .onAppear(){
                        getBuildingList()
                    }
                    .alert("알림", isPresented: $serverAlert) {
                        Button("확인") {}
                    } message: {
                        Text("서버 통신에 실패했습니다.")
                    }
                    .alert("알림", isPresented: $nilData) {
                        Button("확인") {}
                    } message: {
                        Text("캠퍼스 맵 데이터가 없습니다.")
                    }
            } else {
                List(selection: $selection) {
                    Section(header: Text(titles[0])) {
                        ForEach(buildingList.indices) { index in
                            NavigationLink(destination: BuildingDetailView(buildingCode: buildingList[index].placeId), label:{
                                HStack {
                                    Image("gachonMark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .padding(.trailing, 8)
                                    
                                    Text(buildingList[index].placeName)
                                }
                            })
                            
                        }
                    }
                }
                .navigationTitle("캠퍼스 맵")

            }
        } // end of NavigationStack
            
            
//            .searchable(
//                text: $searchText,
//                placement: .navigationBarDrawer,
//                prompt: "검색")  {
//                    ForEach(searchResults, id: \.self.id) { building in
//                        Text(building.name)
//                            .onTapGesture {
//                                print("선택한 건물: \(building.name)")
//                            }
//                    } // end of ForEach
//                } // end of .searchable
        
      
    } // end of body
    
//    var searchResults: [Building] {
//        if searchText.isEmpty {
//            return globalBuilding
//        } else {
//            return globalBuilding.filter { $0.name.localizedStandardContains(searchText) }
//        }
//    }
    
    // 건물 정보 가져오는 함수
    func getBuildingList(){
        
        //        guard let url = URL(string: "https://af0b-58-121-110-235.ngrok-free.app/map/building-info/list")
        guard let url = URL(string: "https://8eac-58-121-110-235.ngrok-free.app/map/building-info/list")
        else {
            print("Invalid URL")
            return
            
        }
            
        // Alamofire를 사용하여 Get 요청 생성
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: BuildingListResponse.self) { response in
                // 에러 처리
                switch response.result {
                    case .success(let value):
                        // 성공적인 응답 처리
                    if let data = value.data {
                        print(data)
                        print("getBuildingList() - 건물 리스트 정보 가져오기 성공")
                        
                        
                        buildingList = data.buildingList
                        apiConnection = true
                    }
                    else {
                        print("데이터 없음")
                        nilData = true
                    }
                    
                    case .failure(let error):
                        // 에러 응답 처리
                        print("서버 통신 실패")
                        print("Error: \(error.localizedDescription)")
                        serverAlert = true
                    
                } // end of switch
        } // end of AF.request
    
    }
    
} // end of View

#Preview {
    BuildingTabView()
}
