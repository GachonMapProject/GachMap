//
//  EventCardView.swift
//  GachMap
//
//  Created by 이수현 on 4/17/24.
//
import SwiftUI
import Alamofire
import SafariServices


struct EventCardView : View {
    @State var haveLocationData : Bool = false
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var event : EventList
    @State var eventDetail : [EventDetail]    // 이미지 선택 후 DetailView 가기 전에 변경해줘야 함
    @State var locationAlert = false
    @State var serverAlert = false  // 서버 통신 실패 알림
    

    
    init(event: EventList) {
        self.event = event
        self.eventDetail = [EventDetail(eventInfoId: 0, eventCode: 0, eventName: "", eventPlaceName: "", eventLatitude: 0, eventLongitude: 0, eventAltitude: 0)]
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
//                        haveLocationData = true
                        
                    }, label: {
//                        Image("festival")
//                            .resizable()
//                            .frame(width: screenWidth)
//                            .scaledToFit()
                        AsyncImage(url: URL(string: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQgByBT5IiAT_a2x9pUVb4VMoOrlzHH7Jrzj-HB5jzHlR4lNLMS")) { image in
                            image.resizable()
                                .frame(width: screenWidth)
                                .scaledToFit()
                            } placeholder: {
                                ProgressView()
                        }
                    })
                    .alert(isPresented: $serverAlert) {
                        Alert(title: Text("서버 통신에 실패했습니다."))
                    }
                    
                    
                    NavigationLink(destination: EventDetailView(eventDetail: eventDetail), isActive: $haveLocationData) {
                        EmptyView()
                    }
                    
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
                        .alert(isPresented: $locationAlert) {
                            Alert(title: Text("행사 위치 정보가 없습니다."))
                        }
                        
                    }
                }
            }
        }
    }
    
    func getEventDetail(eventId : Int){
        // API 요청을 보낼 URL 생성
//        /src/admin/event/{eventId}
//        guard let url = URL(string: "https://ceprj.gachon.ac.kr/60002/src/admin/event/\(eventId)")
        guard let url = URL(string: "https://af0b-58-121-110-235.ngrok-free.app/event/\(eventId)")
        else {
            print("Invalid URL")
            return
        }
        print(url)
        // Alamofire를 사용하여 Get 요청 생성
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: EventDetailResponse.self) { response in
                // 에러 처리
                switch response.result {
                    case .success(let value):
                        print("getEventDetail() 성공")
                            
                        // 데이터가 nil이 아닐 때
                        if let data = value.data {
                            eventDetail = data
                            haveLocationData = true // 행사 위치 뷰 이동
                        }
                        else {
                            locationAlert = true
                            print("위치 없는 행사")
                        }

                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
                        serverAlert = true
                } // end of switch
        } // end of AF.request
    }
}





// 중앙 슬라이드 이미지 
//                    HStack{
//                        Image(systemName:"lessthan.circle.fill")
//                            .font(.system(size: 35))
//                            .foregroundColor(.gray)
//                            .opacity(0.8)
//                            .padding(.leading, 15)
//
//                        Spacer() // 가운데 여백 추가
//
//                        Image(systemName:"greaterthan.circle.fill")
//                            .font(.system(size: 35))
//                            .foregroundColor(.gray)
//                            .opacity(0.8)
//                            .padding(.trailing, 15)
//                    }
//                    .frame(width: screenWidth)
