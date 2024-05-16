//
//  DashboardView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI
import Alamofire

struct UserDashboardView: View {
    @State private var currentIndex = UserDefaults.standard.integer(forKey: "currentIndex")
    let texts = ["오늘도 화이팅💪", "열정과 노력,\n그 모든 순간이 빛나길", "도전하는 당신, 응원합니다!", "멋진 추억이 될 오늘 하루", "지식의 여정을 함께 걸어요!", "새로운 배움과 함께하는 활기찬 하루!", "오늘도 열공하는 하루!📚", "배움의 즐거움, 함께 나누어요!", "열정과 노력, 그 모든 순간이 빛나길!", "새로운 배움의 하루, 함께 시작해요!"]
    let timer = Timer.publish(every: 88400, on: .main, in: .common).autoconnect()
    
    
    @State private var userInfo: UserInquiryResponse?
    @State private var isLoading: Bool = false
    @State private var userNickname = ""
    
    @State private var isMoveUsageList: Bool = false
    @State private var isMoveEvent: Bool = false
    @State private var isMoveSearch: Bool = false
    
    @State private var isConnectedServer: Bool = false
    
    // LoginInfo에 저장된 userCode 가져오기
    func getUserCodeFromUserDefaults() -> String? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData),
           let userCode = loginInfo.userCode {
            return "\(userCode)"
        }
        return nil
    }
    
    // 서버에 저장된 사용자 정보 가져오기
    private func getUserInfoInquiry() {
        isLoading = true
        
        guard let userCode = getUserCodeFromUserDefaults(),
              let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/\(userCode)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: UserInquiryResponse.self) { response in
                isLoading = false
                
                switch response.result {
                case .success(let value):
                    if (value.success == true) {
                        print("회원 정보 요청 성공")
                        isConnectedServer = true
                        
                        self.userInfo = value
                        self.userNickname = value.data.userNickname
                        
                    } else {
                        print("회원 정보 요청 실패")
                        isConnectedServer = false
                    }
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    isConnectedServer = false
                }
            }
    } // end of getUserInfoInquiry()
    
    var body: some View {
        HStack {
            if !isConnectedServer {
                VStack(spacing: 5) {
                    Image(systemName: "network.slash")
                        .font(.system(size: 70))
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    
                    Text("서버 연결 실패")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.gray)
                    
                    Text("잠시 후 다시 시도해주세요.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 300)
            } else {
                VStack {
                    VStack(spacing: 2) {
                        HStack(spacing: 2) {
                            Text(userNickname)
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.gachonBlue)
                            Text("님")
                                .font(.system(size: 28))
                            Spacer()
                        }
                        .frame(alignment: .leading)
                        
                        HStack {
                            Text(texts[currentIndex])
                                .font(.system(size: 28, weight: .bold))
                        } // H2
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onReceive(timer) { _ in
                                    currentIndex = (currentIndex + 1) % texts.count
                                    UserDefaults.standard.set(currentIndex, forKey: "currentIndex")
                                }
                        
                    } // V1
                    .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
                    
                    VStack(spacing: 13) {
                        HStack() {
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    Image("muhanEarth_dashboard")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 105)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        HStack {
                                            Text("🧭 AR 길찾기")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        
                                        Text("가천대 구석구석\nAR 길찾기")
                                            .font(.system(size: 15))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.leading)
                                            .padding(.leading, 3)
                                        Spacer()
                                    }
                                    //.frame(maxHeight: .infinity)
                                    .padding(EdgeInsets(top: 13, leading: 10, bottom: 0, trailing: 0))
                                }
                            })
                            .frame(width: 193, height: 258)
                            .background(
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(.dashboardBlue)
                                    .shadow(radius: 7, x: 2, y: 2)
                            )
                            
                            
                            Spacer()
                            
                            WeatherView()
                                .shadow(radius: 7, x: 2, y: 2)
                        } // H3
                        
                        //Spacer()
                        
                        HStack {
                            
                            Button(action: {
                                isMoveUsageList = true
                            }, label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("⭐️")
                                        Text("AI 길찾기")
                                        Text("이용내역")
                                    }
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(.leading, 15)
                            })
                            .frame(width: 131, height: 103)
                            .background(
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(.white)
                                    .shadow(radius: 7, x: 2, y: 2)
                            )
                            
                            NavigationLink("", isActive: $isMoveUsageList) {
                                UsageListView()
                                    .navigationBarBackButtonHidden()
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                isMoveEvent = true
                            }, label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("🎉")
                                        Text("행사")
                                        Text("안내")
                                    }
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 13, leading: 15, bottom: 13, trailing: 10))
                            })
                            .frame(width: 198, height: 103)
                            .background(
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(.dashboardPink)
                                    .shadow(radius: 7, x: 2, y: 2)
                            )
                        } // H4
                        
                        //Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.white)
                                .shadow(radius: 7, x: 2, y: 2)
                                
                            VStack {
                                HStack {
                                    Text("😻 인기 장소")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 13, leading: 15, bottom: 0, trailing: 0))
                                
                                HStack {
                                    Text("1위")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 25)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(.gachonBlue))
                                        .frame(width: 100)
                                    
                                    Text("2위")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 25)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(.gachonGreen))
                                        .frame(width: 100)
                                    
                                    Text("3위")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 25)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(.gachonOrange))
                                        .frame(width: 100)
                                        
                                }
                                
                                HStack {
                                    Text("가천대역\n1번 출구")
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 20, weight: .bold))
                                        .frame(width: 100)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("AI관")
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 20, weight: .bold))
                                        .frame(width: 100)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("가천관")
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 20, weight: .bold))
                                        .frame(width: 100)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.bottom, 13)
                            }
                        }
                        
                        Image("gach1000")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 343)
                            .padding(.top, 30)
                    }
                    .frame(width: 343) // V2
                    
                }
                .padding(.top, 20)// V3
            }
        }
        .onAppear {
            getUserInfoInquiry()
        }
        
        
    } // end of body
} // end of View struct

#Preview {
  UserDashboardView()
}
