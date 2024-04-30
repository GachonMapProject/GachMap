//
//  LocationSearchView.swift
//  GachMap
//
//  Created by 원웅주 on 4/28/24.
//

import SwiftUI

struct LocationSearchView: View {
    
    @Binding var showLocationSearchView: Bool
    
    @State private var searchText = ""
    @State private var recentSearches: [String] = []
    
    var body: some View {
        VStack {
            // 뒤로 가기 버튼
            Button(action: {
                withAnimation(.spring()) {
                    showLocationSearchView.toggle()
                }
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 검색어 입력
            HStack {
                Image("gachonMark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 33, height: 24, alignment: .leading)
                    .padding(.leading)
                
                TextField("어디로 갈까요?", text: $searchText)
                    .font(.title3)
                    //.foregroundColor(Color(.gray))
                
                Spacer()
                
                if (searchText != "") {
                    Button(action: {
                        // 검색어 전달 API 함수 넣기
                        addSearchItem()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.gachonBlue))
                    })
                    .padding(.trailing, 5)
                }
                
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(radius: 7, x: 2, y: 2)
            )
            // 검색창 끝

            // 최근 검색어 보여주기
            VStack {
                HStack {
                    Text("최근 검색")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Text("전체 삭제")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.gachonBlue)
                    })
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
           
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(0..<20, id: \.self) { _ in
                            LocationSearchResultCell()
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                .padding(.top, 3)
                        }
                    }
                } // end of ScrollView
                
            }
            .padding(.top, 20)
            
            
            
        }
        .background(Color.white)
        // end of 전체 VStack
        
    } // end of body
    
    private func addSearchItem() {
        if !searchText.isEmpty && !recentSearches.contains(searchText) {
            recentSearches.append(searchText)
            print(searchText)
            searchText = ""
        }
    }
    
} // end of View struct

#Preview {
    LocationSearchView(showLocationSearchView: Binding.constant(false))
}
