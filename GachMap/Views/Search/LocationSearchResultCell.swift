//
//  LocationSearchResultCell.swift
//  GachMap
//
//  Created by 원웅주 on 4/28/24.
//

import SwiftUI
import Alamofire

class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var searchResults: [SearchKeywordData] = []
    @Published var searchResultNull: Bool = false
    
    @Published var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    
    @State var placeName: String = ""
    
    // 최근 검색어 추가
    func addSearchText(_ text: String) {
            if !text.isEmpty {
                // 중복 검색어를 맨 위로 이동
                if let index = recentSearches.firstIndex(of: text) {
                    recentSearches.remove(at: index)
                }
                recentSearches.insert(text, at: 0)
                UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
            }
        }

    // 키워드 검색 결과 가져오기
    func getSearchResult() {
        
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/find?target=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: SearchKeywordResponse.self) { response in
                print("Response: \(response)")
                switch response.result {
                case .success(let value):
                    print(value)
                    if(value.success == true) {
                        print("키워드 검색 결과 가져오기 성공")
                        self.searchResultNull = false
                        self.searchResults = value.data
                    } else {
                        print("키워드 검색 결과 가져오기 실패")
                        self.searchResultNull = true
                    }
                    
                case .failure(let error):
                    // 서버 연결 실패할 때도 검색 결과 없음 표시
                    self.searchResultNull = true
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

// 빈 공간 선택 시 키보드 내리기 추가

struct LocationSearchResultCell: View {
    
    @ObservedObject var viewModel: SearchViewModel
    @Binding var selectPlaceId: Int?
    @Binding var triggerNavigation: Bool
    
    var body: some View {
        NavigationView {
            if(viewModel.searchResultNull) {
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("검색 결과 없음")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity)
            } else {
                VStack {
                    HStack {
                        Text("검색 결과")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 3, trailing: 20))
                    
                    ScrollView {
                        ForEach(viewModel.searchResults.indices, id: \.self) { index in
                            
                            let result = viewModel.searchResults[index]
                            
                            Button(action: {
                                self.selectPlaceId = result.placeId
                                self.triggerNavigation = true
                            }, label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        // 건물명
                                        Text(result.placeName)
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    
                                    // 요약 정보
                                    if (result.placeSummary != "\n" && result.placeSummary != "") {
                                        HStack {
                                            Text(result.placeSummary)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
                            })
                            
//                            NavigationLink(destination: ResultSelectView(detailViewModel: DetailResultViewModel(placeId: result.placeId))) {
//                                VStack(alignment: .leading) {
//                                    HStack {
//                                        // 건물명
//                                        Text(result.placeName)
//                                            .font(.body)
//                                            .foregroundColor(.black)
//                                        Spacer()
//                                    }
//                                    
//                                    // 요약 정보
//                                    if (result.placeSummary != "\n") {
//                                        HStack {
//                                            Text(result.placeSummary)
//                                                .font(.subheadline)
//                                                .foregroundColor(.gray)
//                                        }
//                                    }
//                                }
//                                .frame(maxWidth: .infinity)
//                                .padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
//                            }
//                            .navigationBarBackButtonHidden()
                            
//                            Button(action: {
//                                
//                            }, label: {
//                                VStack(alignment: .leading) {
//                                    HStack {
//                                        // 건물명
//                                        Text(result.placeName)
//                                            .font(.body)
//                                            .foregroundColor(.black)
//                                        Spacer()
//                                    }
//                                    
//                                    // 요약 정보
//                                    if (result.placeSummary != "\n") {
//                                        HStack {
//                                            Text(result.placeSummary)
//                                                .font(.subheadline)
//                                                .foregroundColor(.gray)
//                                        }
//                                    }
//                                }
//                                .frame(maxWidth: .infinity)
//                                .padding(EdgeInsets(top: 3, leading: 20, bottom: 0, trailing: 20))
//                            })
                            
                            Divider()
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        } // end of ForEach
                        
                    } // end of ScrollView
                } // end of 검색 기록 전체 영역
            } // end of else
            
        } // end of NavigationView
        .navigationBarBackButtonHidden()
               
    } // end of body
} // end of View struct

//#Preview {
//    LocationSearchResultCell(viewModel: SearchViewModel())
//}
