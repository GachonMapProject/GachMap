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
    
    @State var eventList = [
        EventList(eventId: 0, eventName: "naver", eventLink: "https://www.naver.com", eventInfo: "1번", imageData: Data()),
        EventList(eventId: 1, eventName: "google", eventLink: "https://www.google.com", eventInfo: "2번", imageData: Data()),
        EventList(eventId: 2, eventName: "gachon", eventLink: "https://www.gachon.ac.kr", eventInfo: "3번", imageData: Data()),
    ]
    
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
                
                ScrollView(.horizontal) { // 수평 스크롤로 설정
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
                }
                .scrollTargetBehavior(.viewAligned)
                
                
                .navigationTitle("교내 행사")
            } // end of NavigationStack
        }
    }
       
    
    // 행사 리스트 가져오기
    func getEventList() {
        // api 연결되면 지워야 함
        apiConnection = true
        guard let url = URL(string: "https://ceprj.gachon.ac.kr/60002/src/event/list")
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
                        let data = value.data
                        print(data)
                        print("getEventList() - 행사 리스트 정보 가져오기 성공")
                    
                        eventList = data
                        apiConnection = true
                    
                            
                        
                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
                } // end of switch
        } // end of AF.request
    }

}
    
      

#Preview {
    EventTabView()
}


