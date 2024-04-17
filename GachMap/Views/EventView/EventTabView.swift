//
//  EventTabView.swift
//  GachonMap
//
//  Created by 원웅주 on 4/9/24.
//

import SwiftUI
import Alamofire

struct EventTabView: View {
    @State var tabBarHeight = UITabBarController().tabBar.frame.size.height
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var eventList = [
        EventList(eventId: 0, eventName: "", eventLink: "", eventInfo: "", imageData: Data()),
        EventList(eventId: 0, eventName: "", eventLink: "", eventInfo: "", imageData: Data()),
        EventList(eventId: 0, eventName: "", eventLink: "", eventInfo: "", imageData: Data()),
    ]
    
    var body: some View {
        NavigationStack {
            
            ScrollView(.horizontal) { // 수평 스크롤로 설정
                HStack {
                    ForEach(eventList.indices) { index in
                        EventCardView(event: eventList[index])
                            .frame(width: screenWidth)
                    }
                }
            }
            
            Text("TabBar 위치")
                .frame(width: screenWidth, height: tabBarHeight)
                .background(.blue)
            
            .navigationTitle("교내 행사")
        } // end of NavigationStack
        .onAppear(){
            // API 연결 (eventList 초기화)
            
        }
    }
}

#Preview {
    EventTabView()
}

struct EventCardView : View {
    @State var haveLocationData : Bool = false
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var event : EventList
//    var image: Image {
//        guard let uiImage = UIImage(data: event.imageData) else {
//            return Image(systemName: "photo") // 이미지 데이터가 없을 경우 기본 이미지 사용
//        }
//        return Image(uiImage: uiImage)
//    }
//    var image = "https://118b-58-121-110-235.ngrok-free.app/user/test"
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack(){
                    //eventImage로 변경
                    Button(action: {
                        // 행사 디테일 API 통신 함수 추가하고 넘어온 데이터 보고 위치 데이터 있는지 없는지 판단해서 뷰 이동 혹은 알림 띄우기
                        haveLocationData = true
                    }, label: {
                        Image("festival")
                            .resizable()
                            .frame(width: screenWidth)
                            .scaledToFit()
                    })
//                    
//                    NavigationLink(destination: EventDetailView(eventId: event.eventId), isActive: $touchButton) {
//                        EmptyView()
//                    }
                    
                    HStack{
                        Image(systemName:"lessthan.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.gray)
                            .opacity(0.8)
                            .padding(.leading, 15)
                        
                        Spacer() // 가운데 여백 추가
                        
                        Image(systemName:"greaterthan.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.gray)
                            .opacity(0.8)
                            .padding(.trailing, 15)
                    }
                    .frame(width: screenWidth)
                    VStack{
                        Spacer()
                        ZStack(alignment : .bottom){
                            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.0), .black.opacity(1.0)]), startPoint: .top, endPoint: .bottom)
                            VStack{
                                Spacer()
                                VStack(alignment : .leading){
                                    //                                Text(event.eventName)
                                    Text("가천대학교 축구리그")
                                        .font(.system(size: 24))
                                        .foregroundStyle(.white)
                                        .bold()
                                    
                                    ScrollView{
                                        //                                    Text(event.eventInfo)
                                        Text("새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]  2024년 4월부터 10월까지, 교내 축구리그가 진행됩니다.새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]  2024년 4월부터 10월까지, 교내 축구리그가 진행됩니다.새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]  2024년 4월부터 10월까지, 교내 축구리그가 진행됩니다.새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]  2024년 4월부터 10월까지, 교내 축구리그가 진행됩니다.")
                                            .font(.system(size: 13))
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                    
                                }
                                .frame(height: screenHeight / 5)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 40, trailing: 20))
                                
                                
                            }
                            HStack{
                                Spacer()
                                Button(action: {  // 외부 URL로 연결하는 액션
                                    if let url = URL(string: "https://www.naver.com") {
                                        UIApplication.shared.open(url)
                                    }
                                }, label: {
                                    Text("더 알아보기")
                                        .font(.system(size: 16))
                                        .bold()
                                })
                                .frame(width: 120, height: 30)
                                .foregroundColor(.white)
                                .background(Capsule()
                                    .fill(Color(UIColor.systemBlue)))
                                //                                .background(.blue)
                                
                                //                                .cornerRadius(10)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
                            }
                            
                        }
                        .frame(height: screenHeight / 2.5)
                        
                    }
                }
            }
        }
    }
    
    func getEventDetail(eventId : Int){
        // API 요청을 보낼 URL 생성
//        /src/admin/event/{eventId}
        guard let url = URL(string: "https://ceprj.gachon.ac.kr/60002 /src/admin/event/\(eventId)")
        else {
            print("Invalid URL")
            return
        }
            
        // Alamofire를 사용하여 Get 요청 생성
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: EventDetail.self) { response in
                // 에러 처리
                switch response.result {
                    case .success(let value):
                        print(value)
                        // 성공적인 응답 처리
        //                self.responseData = value
                        
                    
                        // 위치 데이터 있는지 확인 후 있으면 haveLocationData = true 후 뷰 이동, 없으면 Alert 설정

                    
                    
                        print("서버로 데이터 전송 성공")
                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
                } // end of switch
        } // end of AF.request
    }
}
