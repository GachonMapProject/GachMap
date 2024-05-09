//
//  SearchMainSecondView.swift
//  GachMap
//
//  Created by 원웅주 on 5/8/24.
//

import SwiftUI

struct SearchSecondView: View {
    
    @State private var startSearchText = ""
    @State private var endSearchText = ""
    
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var showLocationSearchResultView: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                // 뒤로 가기 버튼
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                })
                
                Spacer()
                
                // 검색창 종료 버튼
                Button(action: {
                    
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                })
            }
            .frame(width: UIScreen.main.bounds.width - 40)
            .padding(.top, 10)
            
            // 상단 검색바
            HStack(spacing: 0) {
                Image("gachonMark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 33, height: 24, alignment: .leading)
                    .padding(.leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        TextField("출발", text: $startSearchText)
                            .font(.title3)
                        
                        Spacer()
                        
                        if(!startSearchText.isEmpty) {
                            Button(action: {
                                startSearchText = ""
                            }, label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .background(
                                        Circle()
                                            .fill(.gray)
                                            .frame(width: 25, height: 25))
                            })
                            .padding(.trailing, 7)
                        }
                        
                    }
                    .frame(height: 47.5)
                    
                    Divider()
                    
                    HStack {
                        TextField("도착", text: $endSearchText)
                            .font(.title3)
                        
                        Spacer()
                        
                        if(!endSearchText.isEmpty) {
                            Button(action: {
                                endSearchText = ""
                            }, label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .background(
                                        Circle()
                                            .fill(.gray)
                                            .frame(width: 25, height: 25))
                            })
                            .padding(.trailing, 7)
                        }
                        
                    }
                    .frame(height: 47.5)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                if (startSearchText != "" || endSearchText != "") {
                    Button(action: {
                        // 검색어 전달 API 함수 넣기
                        performSearch()
                    }, label: {
                        VStack(spacing: 5) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("검색")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                    })
                    .frame(width: 50, height: 85)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gachonBlue))
                    .padding(.trailing, 5)
                }
                
            } // end of HStack (검색창)
            .frame(width: UIScreen.main.bounds.width - 30, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(radius: 7, x: 2, y: 2)
            )
            .padding(.top, 20)
            // 검색창 끝
            
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.white)
        // end of 전체 VStack
        
    }
    
    private func performSearch() {
        // 검색어 전달 API 함수 넣기
        searchViewModel.searchText = startSearchText
        searchViewModel.getSearchResult()
        
        self.showLocationSearchResultView = true
        
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchSecondView()
}
