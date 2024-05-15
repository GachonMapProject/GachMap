//
//  RecentSearchCell.swift
//  GachMap
//
//  Created by 원웅주 on 5/8/24.
//

import SwiftUI

struct RecentSearchCell: View {
    
    @State private var showAlert: Bool = false
    @ObservedObject var viewModel: SearchViewModel
    
    var onSearchSelect: (String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("최근 검색")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    showAlert = true
                }, label: {
                    Text("전체 삭제")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.gachonBlue)
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("최근 검색기록 삭제"), message: Text("최근 검색기록을 삭제하시겠습니까?"), primaryButton: .default(Text("확인"), action: { clearAllSearches() }), secondaryButton: .cancel(Text("취소")))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 3, trailing: 20))
            
            ScrollView {
                ForEach(Array(viewModel.recentSearches.enumerated()), id: \.element) { index, search in
                    VStack {
                        HStack {
                            Button(action: {
                                onSearchSelect(search)
                            }, label: {
                                Text(search)
                                    .font(.body)
                                    .foregroundColor(.black)
                            })
                            
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    duplicateDelete(at: .init(integer: index))
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            })
                        }
                        
                        Divider()
                    }
                    .padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                }
            } // end of ScrollView
        } // end of 검색 기록 전체 영역
    } // end of body
    
    // 검색어 저장
//    private func addOrUpdateSearchText(_ text: String) {
//        if !text.isEmpty {
//            if let index = recentSearches.firstIndex(of: text) {
//                // 중복된 값이 있으면 기존 위치에서 삭제
//                recentSearches.remove(at: index)
//            }
//            // 새로운 검색어를 목록의 맨 위로 추가
//            recentSearches.insert(text, at: 0)
//            UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
//        }
//    }

    // 검색어 개별 삭제
    private func duplicateDelete(at offsets: IndexSet) {
        viewModel.recentSearches.remove(atOffsets: offsets)
        UserDefaults.standard.set(viewModel.recentSearches, forKey: "recentSearches")
    }
    
    // 검색기록 전체 삭제
    private func clearAllSearches() {
        viewModel.recentSearches.removeAll()
        UserDefaults.standard.set(viewModel.recentSearches, forKey: "recentSearches")
    }
}

//#Preview {
//    RecentSearchCell(viewModel: SearchViewModel())
//}
