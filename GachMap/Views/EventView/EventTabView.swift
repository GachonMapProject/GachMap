//
//  EventTabView.swift
//  GachonMap
//
//  Created by 원웅주 on 4/9/24.
//

import SwiftUI
import Alamofire

struct EventTabView: View {
    @EnvironmentObject var globalViewModel: GlobalViewModel
    
    var tabBarHeight = UITabBarController().tabBar.frame.size.height
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height

    @State var apiConnection = false
    
    @State var eventList = [EventList]()
    
    @State var currentIndex : Int = 0   // 현재 행사의 인덱스 번호 (위에 바 중 색 변경할 인덱스)
    @State var serverAlert = false  // 서버 통신 실패 알림
    @State var nilData = false      // data가 없을 때 알림
    
    var body: some View {
//        NavigationView {
            if !apiConnection {
                ProgressView()
                    .onAppear(){
                        // API 연결 (eventList 초기화)
                        getEventList()
                    }
                    .alert("알림", isPresented: $serverAlert) {
                        Button("확인") {}
                    } message: {
                        Text("서버 통신에 실패했습니다.")
                    }
            }
            else{
                if !nilData {
                    VStack{
                        // 상단 제목 영억
                        VStack {
                            Image("EventTabTitle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width - 50, alignment: .leading)
                                .frame(height: 32)
                                .padding(.top, 10)
                            
                            HStack{
                                ForEach(1...eventList.count, id: \.self){index in
                                    Rectangle()
                                        .cornerRadius(5)
                                        .frame(height: index == currentIndex ? 5 : 3)
                                        .foregroundColor(index == currentIndex ? .white : Color(UIColor.systemGray3))
                                        //.animation(.easeInOut)  // 애니메이션 적용
                                }
                            }
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        }
                        .frame(maxWidth: .infinity)
                        //.frame(height: 330)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.gachonBlue2,. gachonBlue]), startPoint: .top, endPoint: .bottom)
                        )
                        
                        NavigationLink("", isActive: $globalViewModel.selectedDestination) {
                            SearchSecondView(getStartSearchText: "현재 위치", getEndSearchText: globalViewModel.destination, getStartPlaceId: -1, getEndPlaceId: globalViewModel.destinationId, latitude: globalViewModel.latitude, longitude: globalViewModel.longitude, altitude: globalViewModel.altitude)
                                .navigationBarBackButtonHidden()
                        }
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) { // 수평 스크롤로 설정
                            ZStack(alignment : .leading){
                                LazyHStack {
                                    ForEach(eventList.indices) { index in
                                        EventCardView(event: eventList[index])
                                            .background(Color.white)
                                                    .cornerRadius(15)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                                            .frame(width: screenWidth)
                                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                                content
                                                    .opacity(phase.isIdentity ? 1.0 : 0.9)
                                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
                                            }
                                    }
                                }
                                .scrollTargetLayout()
                                
                                
                                GeometryReader { proxy in
                                    let offset = proxy.frame(in: .named("scroll")).origin.x
                                    Color.clear.preference(key: ViewOffsetKey.self, value: offset)
                                }
                                .frame(height : 0)
                                
                            }
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .coordinateSpace(name: "scroll")
                        .onPreferenceChange(ViewOffsetKey.self) { value in
                            currentIndex = Int(value / screenWidth * -1 + 1)
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                    
                }
                else {
                    Text("현재 진행 중인 행사가 없습니다.")
                        .navigationTitle("교내 행사")
                }
            }  // end of else

//        } // end of NavigationView
  
    }
       
    
    // 행사 리스트 가져오기
    func getEventList() {
        // api 연결되면 지워야 함
//        apiConnection = true
//        guard let url = URL(string: "https://af0b-58-121-110-235.ngrok-free.app/event/list")
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/event/list")
        else {
            print("getEventList - Invalid URL")
            return
        }
            
        // Alamofire를 사용하여 Get 요청 생성
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: EventListResponse.self) { response in
                // 에러 처리
                switch response.result {
                    case .success(let value):
                        // 성공적인 응답 처리
                    if let data = value.data {
                        print(data.eventList)
                        print("getEventList() - 행사 리스트 정보 가져오기 성공")
                        
                        eventList = data.eventList
                        apiConnection = true
                    }
                    else {
                        nilData = true
                        print("nilData")
                        
                    }
                            
                        
                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
                        serverAlert = true
                } // end of switch
        } // end of AF.request
    }

}
    
// scrollView offset 가져오기
struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

#Preview {
    EventTabView()
}

