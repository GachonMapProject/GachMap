//
//  SimpleSearchResultCell.swift
//  GachMap
//
//  Created by 원웅주 on 5/9/24.
//

import SwiftUI
import Alamofire

class SimpleSearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var searchResults: [SearchKeywordData] = []
    @Published var selectedPlaceName: String?
    @Published var searchResultNull: Bool = false
    
    @State var placeName: String = ""
    
    // 빈 부분 탭하면 키보드 내리기 넣기

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
                    print("서버 연결 실패")
                    self.searchResultNull = true
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

// 빈 공간 선택 시 키보드 내리기 추가

struct SimpleSearchResultCell: View {
    // @Binding var searchText: String
    @ObservedObject var viewModel: SimpleSearchViewModel
    var onSelect: (String, Int) -> Void
    
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
                                self.onSelect(result.placeName, result.placeId)
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
                            
                            Divider()
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        } // end of ForEach
                        
                    } // end of ScrollView
                } // end of 검색 기록 전체 영역
                .onTapGesture {
                    endTextEditing()
                }
            } // end of else
            
        } // end of NavigationView
        .navigationBarBackButtonHidden()
        
    } // end of body
} // end of View struct

//#Preview {
//    SimpleSearchResultCell()
//}
