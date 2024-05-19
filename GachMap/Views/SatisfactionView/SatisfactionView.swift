//
//  SatisfactionView.swift
//  GachMap
//
//  Created by 이수현 on 4/23/24.
//

import SwiftUI
import Alamofire

struct SatisfactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var globalViewModel: GlobalViewModel

    var width = UIScreen.main.bounds.width
    let arr = [1 : "veryUnsatisfied", 2 : "unsatisfied", 3 : "normal", 4 : "satisfied", 5 : "verySatisfied"]
    let weatherData = WeatherData()
    @State var ready = false
    
    @State var pathSelect = -1
    @State var timeSelect = -1
    @State var submit = false
    
    let departures : Int
    let arrivals : Int
    let timeList : [TimeList]
    @State var loginInfo = LoginInfo()
    @State var temp = 0.0
    @State var rainPrecipitation = 0.0
    @State var rainPrecipitationProbability = 0
    @State var serverAlert = false
    @State var message = ""
    
    
    // 날씨, 유저 아이디(게스트아이디) 추가 필요함
    
    var body: some View {
        if !ready {
            ProgressView()
                .onAppear(){
                    loginInfo = getLoginInfo() ?? LoginInfo()
                    print("loginInfo : \(loginInfo)")
                    
                    weatherData.WeatherDataRequest{ newWeather in
                        if let newWeather = newWeather {
                            print("weather : \(newWeather)")
                            temp = newWeather.temp
                            rainPrecipitation = newWeather.precipitation
                            rainPrecipitationProbability = (newWeather.precipitationForm == "없음" ? 0 : Int(newWeather.precipitationForm)) ?? 0
                            print("temp : \(temp)")
                            print("rainPrecipitation : \(rainPrecipitation)")
                            print("rainPrecipitationProbability : \(rainPrecipitationProbability)")
                        }
                    }
                    ready = true
                }
        }
        else{
            VStack{
                Spacer()
                VStack(alignment : .leading){
                    HStack(spacing : 0){
                        Text("추천 경로")
                            .bold()
                        Text("에 대해")
                        Spacer()
                    }
                    HStack(spacing : 0){
                        Text("만족")
                            .bold()
                        Text("하셨나요?")
                        Spacer()
                    }
                } // end of VStack
                .font(.system(size: 32))
                .padding(.bottom, 30)
                
                Text("경로 만족도 평가는 개인별 소요시간 및 경로 예측도 향상에 큰 도움이 됩니다.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .frame(width: width * 0.7)
                    .padding(.bottom, 30)
                
                SatisfactionButtonView(name: "경로 평가", select: $pathSelect)
                    .padding(.bottom, 30)
                
                SatisfactionButtonView(name: "소요시간 정확도", select: $timeSelect)
                Spacer()
                
                Button(action: {
                    // 데이터 서버에 전달하는 함수 필요
                    let param = SatisfactionRequest(userId: loginInfo.userCode, guestId: loginInfo.guestCode, departures: departures, arrivals: arrivals, satisfactionRoute: arr[pathSelect] ?? "", satisfactionTime: arr[timeSelect] ?? "", temperature: temp, rainPrecipitation: rainPrecipitation, rainPrecipitationProbability: rainPrecipitationProbability, timeList: timeList)
                    print("param : \(param)")
                    postSatifactionData(parameter : param)
                    submit = true
                    
                }, label: {
                    Text("확인")
                        .frame(width: width * 0.7, height: 50)
                        .foregroundColor(.white)
                })
                .background(timeSelect == -1 || pathSelect == -1 ? Color.gray.opacity(0.3) : Color.blue)
                .multilineTextAlignment(.center)
                .cornerRadius(15)
                .shadow(radius: 5, x: 2, y: 2)
                .font(.system(size: 20))
                .disabled(timeSelect == -1 || pathSelect == -1)
                .padding(.bottom, 30)
                .alert(isPresented: $serverAlert) {
                    Alert(title: Text("알림"), message: Text("서버 연결에 실패했습니다."),
                          dismissButton: .default(Text("확인")){
                            dismiss()
                    })
                }
                
                
            } // end of VStack
            .frame(width: width * 0.9)
            .alert(isPresented: $submit) {
                Alert(title: Text("만족도 조사"), message: Text(message),
                      dismissButton: .default(Text("확인")){
                        dismiss()
                })
            }
   
          
        }
    }
        
    
    // 로그인 정보
    private func getLoginInfo() -> LoginInfo? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
            print("getLoginId.userCode: \(String(describing: loginInfo.userCode))")
            print("getLoginId.guestCode: \(String(describing: loginInfo.guestCode))")
            return loginInfo
        } else {
            print("Login Info not found in UserDefaults")
            return nil
        }
    }
    
    // postData 함수
    private func postSatifactionData(parameter : SatisfactionRequest) {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/history")
        else {
            print("Invalid URL")
            return
        }
            
        // Alamofire를 사용하여 POST 요청 생성
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
            // 서버 연결 여부
            switch response.result {
                case .success(let value):
                    print(value)
                   // 만족도 저장 성공 유무
                    if (value.success == true) {
                        print("만족도 저장 완료")
                        print("value.success: \(value.success)")
                        message = "만족도 저장 완료"
                        submit = true
   
                    } else {
                        print("만족도 저장 실패")
                        print("value.message: \(value.message)")
                        message = "만족도 저장 실패"
                        submit = true
                    }
                
                case .failure(let error):
                    // 에러 응답 처리
//                    alertMessage = "서버 연결에 실패했습니다."
//                    showAlert = true
                    print("Error: \(error.localizedDescription)")
                    serverAlert = true
            } // end of switch
        } // end of AF.request
    } // end of postData()
}


