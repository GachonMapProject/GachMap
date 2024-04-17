//
//  FavTabView.swift
//  MoodangMapTest
//
//  Created by 원웅주 on 2/29/24.
//

import SwiftUI

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
    
    @State private var searchText = ""
    
    var body: some View {
        
        let titles = ["글로벌캠퍼스", "메디컬캠퍼스"]
        let data = [globalBuilding]
        
        NavigationStack {
            List {
                ForEach(data.indices) { index in
                    Section(header: Text(titles[index])) {
                        ForEach(data[index], id: \.id) { building in
                            HStack {
                                Image(building.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 8)
                                
                                Text(building.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("캠퍼스 맵")
        } // end of NavigationStack
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer,
            prompt: "검색")  {
                ForEach(searchResults, id: \.self.id) { building in
                    Text(building.name)
                        .onTapGesture {
                            print("선택한 건물: \(building.name)")
                        }
                } // end of ForEach
            } // end of .searchable
    } // end of body
    
    var searchResults: [Building] {
        if searchText.isEmpty {
            return globalBuilding
        } else {
            return globalBuilding.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
} // end of View

#Preview {
    BuildingTabView()
}
