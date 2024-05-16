//
//  SearchMainSecondView.swift
//  GachMap
//
//  Created by 원웅주 on 5/8/24.
//

import SwiftUI
import Alamofire
import CoreLocation

struct SearchSecondView: View {
    var getStartSearchText: String
    var getEndSearchText: String
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @EnvironmentObject var coreLocation : CoreLocationEx
    
    @State private var startSearchText: String = ""
    @State private var endSearchText: String = ""
    @State var startPlaceId: Int?
    @State var endPlaceId: Int?
    @State private var isSearched: Bool = false
    
    @State private var validStartText: Bool = false
    @State private var validEndText: Bool = false
    
    @State private var fixedStart: Bool = false
    @State private var fixedEnd: Bool = false
    
    @State private var activeTextField: String = ""
    
    @StateObject private var simpleSearchViewModel = SimpleSearchViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    
    @State private var showLocationSearchResultView: Bool = false
    
    @State var paths : [PathData]? = nil // 3가지 경로 배열
    @State private var goPathView = false   // 경로 뷰로 이동
    
    @State var showStartLocationChangeAlert = false // 출발지 - 현재 위치 변경시 알림
    
    var body: some View {
        if !goPathView{
            VStack {
                HStack {
                    // 뒤로 가기 버튼
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    })
                    
                    Spacer()
                    
                    // 검색창 종료 버튼
                    Button(action: {
                        globalViewModel.showSearchView = false
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.black)
                    })
                }
                .frame(width: UIScreen.main.bounds.width - 40)
                .padding(.top, 10)
                
                // 상단 검색바
                // 출발, 도착 두 필드가 모두 true일때만 길찾기 버튼 활성화
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
                                .onTapGesture {
                                    self.activeTextField = "start"
                                    isSearched = false
                                }
                                .onSubmit {
                                    performSearch()
                                }
                            
                            Spacer()
                            
                            if(fixedStart) {
                                Button(action: {
                                    if startSearchText == "현재 위치"{
                                        showStartLocationChangeAlert = true
                                    }
                                }, label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .background(
                                            Circle()
                                                .fill(.gray)
                                                .frame(width: 23, height: 23))
                                })
                                .padding(.trailing, 7)
                            }
                            
                        }
                        .frame(height: 47.5)
                        .alert(isPresented: $showStartLocationChangeAlert){
                            Alert(title: Text("출발 위치 변경"), message: Text("출발 위치가 현재 위치가 아닐 경우\n경로 미리보기만 가능합니다."), primaryButton: .default(Text("확인"), action: {
                                fixedStart = false
                                startSearchText = ""
                            }),
                              secondaryButton: .cancel(Text("취소")))
                        }
                        
                        Divider()
                        
                        HStack {
                            TextField("도착", text: $endSearchText)
                                .font(.title3)
                                .onTapGesture {
                                    self.activeTextField = "end"
                                    isSearched = false
                                }
                                .onSubmit {
                                    performSearch()
                                }
                            
                            Spacer()
                            
                            if(fixedEnd) {
                                Button(action: {
                                    fixedEnd = false
                                    endSearchText = ""
                                }, label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .background(
                                            Circle()
                                                .fill(.gray)
                                                .frame(width: 23, height: 23))
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
                            if (fixedStart && fixedEnd) {
                                
                                /* 1. 사용자가 교내에 위치
                                    i) 출발: 현재위치, 도착: 검색 지정 or 현재 위치 -> 내비게이션 사용 가능
                                    ii) 출발: 검색 지정, 도착: 검색 지정 or 현재 위치 -> 따라가기
                                   2. 사용자가 교외에 위치
                                    i) 출발: 현재위치, 도착: 검색 지정 -> 불가능
                                    ii) 출발: 검색 지정, 도착: 검색 지정 -> 따라가기 */
                                
                                // 길안내 뷰로 이동!
                                print("출발 placeName: \(startSearchText)")
                                print("출발 placeId: \(startPlaceId)")
                                print("도착 placeName: \(endSearchText)")
                                print("도착 placeId: \(endPlaceId)")
                                if let location = coreLocation.location {
                                    if startSearchText == "현재 위치" {
                                        getUserLocationPath(location : location, arrival: endPlaceId ?? 0)
                                    } else{
                                        getPath(departure: startPlaceId ?? 0, arrival: endPlaceId ?? 0)
                                    }
                                }

                                
                            } else {
                                isSearched = true
                                performSearch()
                            }
                        }, label: {
                            if (fixedStart && fixedEnd) {
                                // 길찾기 뷰로 넘기기
                                VStack(spacing: 5) {
                                    Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    Text("길찾기")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            } else {
                                // 키워드 검색(출발, 도착)
                                VStack(spacing: 5) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    Text("검색")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                }
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
                
                // 출발 TextField 선택 시에만 현재 위치 버튼 활성화
                if self.activeTextField == "start" {
                    HStack {
                        Button(action: {
                            if self.activeTextField == "start" {
                                self.startSearchText = "현재 위치"
                                fixedStart = true
                            }
                        }, label: {
                            Image(systemName: "location.fill")
                                .font(.system(size: 15))
                            Text("현재 위치")
                                .font(.system(size: 15))
                        })
                        .foregroundColor(.gray)
                        .background(
                            Capsule()
                                .fill(Color(UIColor.systemGray5))
                                .frame(width: 100, height: 25))
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 55)
                    .padding(.top, 8)
                }
                
                if isSearched {
                    SimpleSearchResultCell(viewModel: simpleSearchViewModel) { selectedPlaceName, selectedPlaceId in
                        if self.activeTextField == "start" {
                            self.startSearchText = selectedPlaceName
                            self.startPlaceId = selectedPlaceId
                            fixedStart = true
                        } else if self.activeTextField == "end" {
                            self.endSearchText = selectedPlaceName
                            self.endPlaceId = selectedPlaceId
                            fixedEnd = true
                        }
                    }
                    .padding(.top, 15)
                }
                
                
            } // 전체 VStack
            .onAppear {
                if !getStartSearchText.isEmpty {
                    startSearchText = getStartSearchText
                    fixedStart = true
                }
                if !getEndSearchText.isEmpty {
                    endSearchText = getEndSearchText
                    fixedEnd = true
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            // end of 전체 VStack
            
//            if paths != nil{
//                NavigationLink("", isActive: $goPathView){
//                    ChoosePathView(paths: paths ?? [], startText: startSearchText, endText: endSearchText)
//                        .navigationBarBackButtonHidden()
//                        .edgesIgnoringSafeArea(.bottom)
//                }
//                
//            }

        }
        else{
            if paths != nil{
                ChoosePathView(paths: paths ?? [], startText: startSearchText, endText: endSearchText)
//                .navigationBarBackButtonHidden()
//                .edgesIgnoringSafeArea(.bottom)
            
                
            }
        }
      
        
    } // end of body
    
    private func performSearch() {
        if activeTextField == "start" {
            searchViewModel.addSearchText(startSearchText)
            simpleSearchViewModel.searchText = startSearchText
        } else if activeTextField == "end" {
            searchViewModel.addSearchText(endSearchText)
            simpleSearchViewModel.searchText = endSearchText
        }
        
        simpleSearchViewModel.getSearchResult()
        
        // self.showLocationSearchResultView = true
        
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // 현재위치 x
    func getPath(departure : Int, arrival : Int) {
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/route?departures=\(departure)&arrivals=\(arrival)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: PathResponse.self) { response in
//                print("Response: \(response)")
                print("URL : \(url)")
                switch response.result {
                case .success(let value):
                    if(value.success == true) {
                        print("지정 위치 경로 가져오기 성공")
                        paths = value.data
                        if paths != nil{
                            goPathView = true
                            print(paths)


                        }
                       
                    } else {
                        print("지정 위치 경로 가져오기 실패")

                    }
                    
                case .failure(let error):
                    // 서버 연결 실패할 때도 검색 결과 없음 표시
                    print("서버 연결 실패")
                    //                            {"success":false,"property":400,"message":"출발지와 도착지가 같습니다.","data":null}
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    // 현재위치 o
    func getUserLocationPath(location : CLLocation, arrival : Int) {
//    http://ceprj.gachon.ac.kr:60002/map/route-now/{placeId}?latitude=37.44535&longitude=127.12673&altitude=54
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/route-now/\(arrival)?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&altitude=\(location.altitude)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: PathResponse.self) { response in
//                print("Response: \(response)")
                print("URL : \(url)")
                switch response.result {
                case .success(let value):
//                    print(value)
                    if(value.success == true) {
                        print("현재위치 - 경로 가져오기 성공")
                        paths = value.data
                        goPathView = true

                    } else {
                        print("현재위치 - 경로 가져오기 실패")

                    }
                    
                case .failure(let error):
                    // 서버 연결 실패할 때도 검색 결과 없음 표시
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

//#Preview {
//    SearchSecondView(getStartSearchText: "", getEndSearchText: "")
//}
