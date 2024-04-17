//
//  EventCardView.swift
//  GachMap
//
//  Created by 이수현 on 4/17/24.
//
import SwiftUI
import Alamofire


struct EventCardView : View {
    @State var haveLocationData : Bool = false
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var event : EventList
    @State var eventDetail : EventDetail    // 이미지 선택 후 DetailView 가기 전에 변경해줘야 함
    

    
    init(event: EventList) {
        self.event = event
        self.eventDetail = EventDetail(eventDto: EventDto(eventId: event.eventId, eventName: event.eventName, eventStartDate: Date(), eventEndate: Date(), eventLink: event.eventLink, eventInfo: event.eventInfo, imageData: Data()), eventLocationDto: [
            EventLocationDto(eventPlaceName: "반도체 대학 정문", eventLatitiude: 37.4508817, eventLongitude: 127.1274769, eventAltitude: 50.23912),
            EventLocationDto(eventPlaceName: "광장계단 근처", eventLatitiude: 37.45048746, eventLongitude: 127.1280814, eventAltitude: 50.23912),
            EventLocationDto(eventPlaceName: "반도체대학 코너", eventLatitiude: 37.4506271, eventLongitude: 127.1274554, eventAltitude: 50.23912)])
        
    }
    
    
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
                        getEventDetail(eventId: event.eventId)
                        haveLocationData = true
                        
                    }, label: {
                        Image("festival")
                            .resizable()
                            .frame(width: screenWidth)
                            .scaledToFit()
                    })
                    
                    NavigationLink(destination: EventDetailView(eventDetail: eventDetail), isActive: $haveLocationData) {
                        EmptyView()
                    }
                    
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
                            VStack(alignment : .leading){
                                Spacer()
                                VStack(alignment : .leading){
                                    Text(event.eventName)
                                        .font(.system(size: 24))
                                        .foregroundStyle(.white)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                    
                                    ScrollView(){
//                                        Text("새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]  2024년 4월부터 10월까지, 교내 축구리그가 진행됩니다.새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]  2024년 4월부터 10월까지, 교내 축구리그가 진행됩니다.새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]  2024년 4월부터 10월까지, 교내 축구리그가 진행됩니다.새로운 에너지가 충만한 2024년, 우리의 열정이 폭발하는 이곳 [2024 가천대학교 축구리그: G-LEAGUE]  2024년 4월부터 10월까지, 교내 축구리그가 진행됩니다.")
                                        Text(event.eventInfo)
                                            .font(.system(size: 13))
                                            .foregroundStyle(.white)
                                            .bold()
                                            
                                        
                                    }
                                    .frame(width: screenWidth * 0.9, alignment: .leading)
                                    
                                }
                                .frame(height: screenHeight / 5, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 40, trailing: 20))
                                
                                
                            }
                            HStack{
                                Spacer()
                                Button(action: {  // 외부 URL로 연결하는 액션
                                    if let url = URL(string: event.eventLink) {
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
        guard let url = URL(string: "https://ceprj.gachon.ac.kr/60002/src/admin/event/\(eventId)")
        else {
            print("Invalid URL")
            return
        }
            
        // Alamofire를 사용하여 Get 요청 생성
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: EventDetailResponse.self) { response in
                // 에러 처리
                switch response.result {
                    case .success(let value):
                        print("getEventDetail() 성공")
                        
                        // 성공적인 응답 처리 (행사 위치 정보가 있을 때) -> 위치 정보 없으면 property == 203
                        if value.property == 200, let data = value.data{
                            print("행사 위치 정보 있음(\(value.property)) : \(data)")
                            eventDetail = data
                            haveLocationData = true // 행사 위치 뷰 이동
                        }
                        else {
                            // Alert : "행사 정보가 없습니다"
                            print("행사 위치 정보 없음(\(value.property)")
                        }

                    
                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
                } // end of switch
        } // end of AF.request
    }
}
