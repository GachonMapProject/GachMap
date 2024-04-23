//
//  ProfileTabView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI
import Alamofire

enum ActiveExitAlert {
    case exit, withdraw
}

struct ProfileTabView: View {
    
    // @Binding var isLogin: Bool
    
    @State private var showModifyView: Bool = false
    
    @State private var loginInfo: LoginInfo? = nil
    @State private var isLogout: Bool = false
    @State private var isWithdraw: Bool = false
    @State private var isPasswordCheckMove: Bool = false
    @State private var isLoginMove: Bool = false
 
    @State private var showLogoutAlert: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var exitAlertMessage: String = ""
    @State private var activeExitAlert: ActiveExitAlert = .exit
    
    // LoginInfo에 저장된 정보 불러오기
    private func getLoginInfo() {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo") {
            if let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
                // userCode가 저장되어 있다면 출력
                if let userCode = loginInfo.userCode {
                    print("userCode: \(userCode)")
                } else {
                    print("userCode: Not set")
                }
                
                // guestCode가 저장되어 있다면 출력
                if let guestCode = loginInfo.guestCode {
                    print("guestCode: \(guestCode)")
                } else {
                    print("guestCode: Not set")
                }
            }
        } else {
            print("Login Info not found in UserDefaults")
        }
    }
    
    // LoginInfo에 저장된 userCode 가져오기
    func getUserCodeFromUserDefaults() -> String? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData),
           let userCode = loginInfo.userCode {
            return "\(userCode)"
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            VStack {
                let userCode = getUserCodeFromUserDefaults()
                
                if (userCode != nil) {
                    Text("회원 상태")
                    //Text(loginInfo?.userCode)
                    
                    // 내 정보 수정 Button
                    Button(action: {
                        showModifyView = true
                    }, label: {
                        HStack {
                            Text("내 정보 수정")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(.black))
                        }
                        .frame(width: UIScreen.main.bounds.width - 200, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.systemGray5))
                                .shadow(radius: 5, x: 2, y: 2)
                            
                        )
                        .padding(.top, 20)
                        .fullScreenCover(isPresented: $showModifyView) {
                            PasswordCheckView(showModifyView: $showModifyView)
                        }
                    })

                    // end of 내 정보 수정 Button
                    
                    // 로그아웃 Button
                    Button(action: {
                        // 로그아웃 버튼을 누르면 LoginInfo에 연결된 userCode 삭제
                        showLogoutAlert = true
                    }, label: {
                        HStack {
                            Text("로그아웃")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(.black))
                        }
                        .frame(width: UIScreen.main.bounds.width - 200, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.systemGray5))
                                .shadow(radius: 5, x: 2, y: 2)
                        )
                        .padding(.top, 20)
                    })
                    .alert(isPresented: $showLogoutAlert) {
                        Alert(title: Text("알림"), message: Text("로그아웃 하시겠습니까?"), primaryButton: .default(Text("예"), action: {
                            UserDefaults.standard.removeObject(forKey: "loginInfo"); isLogout = true
                        }), secondaryButton: .cancel(Text("아니오")))
                    }

                    NavigationLink("", isActive: $isLogout) {
                        PrimaryView()
                            .navigationBarBackButtonHidden(true)
                    }
                    // end of 로그아웃 버튼
                    
                    // 회원 탈퇴 Button
                    Button(action: {
                        showExitAlert = true
                        activeExitAlert = .exit
                    }, label: {
                        HStack {
                            Text("회원 탈퇴하기")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(.white))
                        }
                        .frame(width: UIScreen.main.bounds.width - 200, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                //.fill(Color(.systemBlue))
                                .shadow(radius: 5, x: 2, y: 2)
                        )
                        .padding(.top, 20)
                    })
                    .alert(isPresented: $showExitAlert) {
                        switch activeExitAlert {
                        case .exit:
                            return Alert(title: Text("탈퇴하시겠습니까?"), message: Text("회원 탈퇴 시 현재까지 제공되던\n개인 맞춤 소요시간 데이터가 삭제됩니다."), primaryButton: .default(Text("예"), action: { deleteUserRequest() }) , secondaryButton: .cancel(Text("아니오")))
                        case .withdraw:
                            return Alert(title: Text("알림"), message: Text(exitAlertMessage), dismissButton: .default(Text("확인"), action: { UserDefaults.standard.removeObject(forKey: "loginInfo"); isWithdraw = true }))
                        }
                    }
                    
                    NavigationLink("", isActive: $isWithdraw) {
                        PrimaryView()
                            .navigationBarBackButtonHidden(true)
                    }
                    
                    
                } else {
                    Text("게스트 상태")
                    //Text(loginInfo?.guestCode)
                    
                    Button(action: {
                        isLoginMove = true
                    }, label: {
                        HStack {
                            Text("로그인")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(.white))
                        }
                        .frame(width: UIScreen.main.bounds.width - 200, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                //.fill(Color(.systemBlue))
                                .shadow(radius: 5, x: 2, y: 2)
                        )
                    })
                    
    //                NavigationLink(destination: LoginView(), isActive: $isLoginMove) {
    //                    EmptyView()
    //                        .navigationBarBackButtonHidden(true)
    //                }
                    
                    NavigationLink("", isActive: $isLoginMove) {
                        LoginView()
                            .navigationBarBackButtonHidden(true)
                    }
                    //.navigationBarBackButtonHidden(true)
                }
            }
            .navigationBarTitle("마이 페이지", displayMode: .large)
            .navigationBarBackButtonHidden(true)
   
        } // end of NavigationStack
    } // end of body
    
    // deleteUserRequest() 함수
    func deleteUserRequest() {
        // API 요청을 보낼 URL 생성
        guard let userCode = getUserCodeFromUserDefaults(),
              let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/\(userCode)")
        else {
            print("Invalid URL")
            return
        }

        let parameter: [String: String] = ["userCode": userCode]
            
        // Alamofire를 사용하여 DELETE 요청 생성
        AF.request(url, method: .delete, parameters: parameter, headers: nil)
            .validate()
            .responseDecodable(of: DeleteUserResponse.self) { response in
            // 서버 연결 여부
            switch response.result {
                case .success(let value):
                    print(value)
                   // 회원 탈퇴 성공 유무
                    if (value.success == true) {
                        print("회원 탈퇴 성공")
                        print("value.success: \(value.success)")
                        print("value.messgae: \(value.message)")
                        
                        // getUserCodeFromUserDefaults()
                        
                        exitAlertMessage = "회원 탈퇴에 성공했습니다.\n다시 만날 날을 기다리고 있을게요!"
                        showExitAlert = true
                        activeExitAlert = .withdraw
                            
//                        UserDefaults.standard.removeObject(forKey: "loginInfo")
                        
                        // isLogin = false
                        
                        

                    } else {
                        print("회원 탈퇴 실패")
                        print("value.success: \(value.success)")
                        print("value.messgae: \(value.message)")

                        exitAlertMessage = "회원 탈퇴에 실패했습니다.\n다시 시도해주세요."
                        showExitAlert = true
                        activeExitAlert = .withdraw
                    }
                
                case .failure(let error):
                    // 에러 응답 처리
                    print("url: \(url)")
                    exitAlertMessage = "서버 연결에 실패했습니다."
                    showExitAlert = true
                    activeExitAlert = .withdraw
                    print("Error: \(error.localizedDescription)")
            } // end of switch
        } // end of AF.request
    } // end of postData()
    
} // end of View strucet

#Preview {
    ProfileTabView()
}
