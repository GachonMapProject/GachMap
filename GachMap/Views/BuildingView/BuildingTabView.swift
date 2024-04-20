//
//  FavTabView.swift
//  MoodangMapTest
//
//  Created by 원웅주 on 2/29/24.
//

import SwiftUI
import Alamofire

struct Building: Identifiable, Hashable {
    let name: String
    let imageName: String
    let id = UUID()
}

private var globalBuilding = [
    Building(name: "가천관", imageName: "gachonMark"),
    Building(name: "AI관", imageName: "gachonMark"),
    Building(name: "비전타워", imageName: "gachonMark"),
    Building(name: "법과대학", imageName: "gachonMark"),
    Building(name: "공과대학1", imageName: "gachonMark"),
    Building(name: "공과대학2", imageName: "gachonMark"),
    Building(name: "바이오나노대학", imageName: "gachonMark"),
    Building(name: "반도체대학", imageName: "gachonMark"),
    Building(name: "한의과대학", imageName: "gachonMark"),
    Building(name: "예술・체육대학1", imageName: "gachonMark"),
    Building(name: "예술・체육대학2", imageName: "gachonMark"),
    Building(name: "글로벌센터", imageName: "gachonMark"),
    Building(name: "중앙도서관", imageName: "gachonMark"),
    Building(name: "전자정보도서관", imageName: "gachonMark"),
    Building(name: "일반대학원/평생교육원", imageName: "gachonMark"),
    Building(name: "교육대학원", imageName: "gachonMark"),
    Building(name: "산학협력관", imageName: "gachonMark"),
    Building(name: "바이오나노연구원", imageName: "gachonMark"),
    Building(name: "학생회관", imageName: "gachonMark"),
    Building(name: "제1기숙사", imageName: "gachonMark"),
    Building(name: "제2기숙사", imageName: "gachonMark"),
    Building(name: "제3기숙사", imageName: "gachonMark")
]

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
    
    var body: some View {
        
        NavigationView {
            if !apiConnection{
                ProgressView()
                    .onAppear(){
                        getBuildingList()
                    }
                    .alert("알림", isPresented: $serverAlert) {
                        Button("확인") {}
                    } message: {
                        Text("서버 통신에 실패했습니다.")
                    }
            }
            else{
                List(selection: $selection){
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
        
//        guard let url = URL(string: "https://ceprj.gachon.ac.kr/60002/src/map/building-info/list")
        guard let url = URL(string: "https://af0b-58-121-110-235.ngrok-free.app/map/building-info/list")
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
                        // 데이터 없음 
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
