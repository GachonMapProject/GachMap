//
//  SearchMainView.swift
//  GachMap
//
//  Created by 원웅주 on 5/8/24.
//

import SwiftUI
import Alamofire

struct SearchMainView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showLocationSearchView: Bool
    @State private var showLocationSearchResultView: Bool = false
    @State private var searchText = ""
    @StateObject private var searchViewModel = SearchViewModel()
    
    // 네비게이션을 위한 상태
    @State private var selectedPlaceId: Int? = nil
    @State private var isNavigationTriggered = false

    var body: some View {
        NavigationView {
            VStack {
                // 검색어 입력
                HStack {
                    Button(action: {
                        withAnimation(.spring()) {
                            //showLocationSearchView.toggle()
                            //showLocationSearchResultView = false
                            dismiss()
                        }
                        //showSheet = true
                    }, label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.leading)
                    })
                    
                    TextField("어디로 갈까요?", text: $searchText)
                        .font(.title3)
                        .submitLabel(.search)
                        .onSubmit {
                            performSearch()
                        }
                        //.foregroundColor(Color(.gray))
                    
                    Spacer()
                    
                    if (searchText != "") {
                        Button(action: {
                            // 검색어 전달 API 함수 넣기
                            performSearch()
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
                .padding(.top, 10)
                // 검색창 끝
                
                /* 검색창 영역 끝 */
                
                /* =========================================================== */
                
                /* 검색 결과 영역 시작 */
                
                if showLocationSearchResultView {
                    LocationSearchResultCell(viewModel: searchViewModel, selectPlaceId: $selectedPlaceId, triggerNavigation: $isNavigationTriggered)
                        .padding(.top, 15)
                } else {
                    RecentSearchCell(viewModel: searchViewModel)
                        .padding(.top, 15)
                }
                
                NavigationLink(destination: ResultSelectView(detailViewModel: DetailResultViewModel(placeId: selectedPlaceId ?? 0)), isActive: $isNavigationTriggered) {
                    EmptyView()
                }
                
//                if (showLocationSearchResultView) {
//                    LocationSearchResultCell(viewModel: searchViewModel)
//                        .padding(.top, 15)
//                } else {
//                    // 최근 검색어 보여주기
//                    RecentSearchCell(viewModel: searchViewModel)
//                        .padding(.top, 15)
//                }
                
//                NavigationLink(destination: ResultSelectView(placeId: selectedPlaceId), isActive: $isNavigationTriggered) {
//                    EmptyView()
//                        .navigationBarBackButtonHidden()
//                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(ignoresSafeAreaEdges: .bottom)
            .background(Color.white)
            // end of 전체 VStack
        } // end of NavigationView
               
    } // end of body
    
    private func performSearch() {
        // 최근 검색어에 저장
        
        // 검색어 전달 API 함수 넣기
        searchViewModel.searchText = searchText
        searchViewModel.addSearchText(searchText)
        searchViewModel.getSearchResult()
        
        self.showLocationSearchResultView = true
        
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

} // end of View struct

#Preview {
    SearchMainView(showLocationSearchView: Binding.constant(false))
}
