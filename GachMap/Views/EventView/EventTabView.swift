//
//  EventTabView.swift
//  GachonMap
//
//  Created by 원웅주 on 4/9/24. 
//

import SwiftUI
import Alamofire

struct EventTabView: View {
    var tabBarHeight = UITabBarController().tabBar.frame.size.height
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height

    @State var apiConnection = false
    
    @State var eventList = [EventList]()
    
    @State var currentIndex : Int = 0   // 현재 행사의 인덱스 번호 (위에 바 중 색 변경할 인덱스)

    
    var body: some View {
        if !apiConnection {
            ProgressView()
                .onAppear(){
                    // API 연결 (eventList 초기화)
                    getEventList()
                }
        }
        else{
            NavigationStack {
                VStack{
                    HStack{
                        ForEach(1...eventList.count, id: \.self){index in
                            Rectangle()
                                .cornerRadius(10)
                                .frame(height: index == currentIndex ? 6 : 3)
                                .foregroundColor(index == currentIndex ? .gachonBlue : .gray)
                                .animation(.easeInOut)  // 애니메이션 적용
                        }
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                    
                    ScrollView(.horizontal) { // 수평 스크롤로 설정
                        ZStack(alignment : .leading){
                            LazyHStack {
                                ForEach(eventList.indices) { index in
                                    EventCardView(event: eventList[index])
                                        .frame(width: screenWidth)
                                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1.0 : 0.8)
                                                .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                            
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
                    
                    
                    .navigationTitle("교내 행사")
                }
               
            } // end of NavigationStack
        }
    }
       
    
    // 행사 리스트 가져오기
    func getEventList() {
        // api 연결되면 지워야 함
//        apiConnection = true
//        guard let url = URL(string: "https://ceprj.gachon.ac.kr/60002/src/event/list")
        guard let url = URL(string: "https://af0b-58-121-110-235.ngrok-free.app/event/list")
        else {
            print("Invalid URL")
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
                    guard let data = value.data else {return}
                        print(data.eventList)
                        print("getEventList() - 행사 리스트 정보 가져오기 성공")
                    
                        eventList = data.eventList
                        apiConnection = true
                    
                            
                        
                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
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


