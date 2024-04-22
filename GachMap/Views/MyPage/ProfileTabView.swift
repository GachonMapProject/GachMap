//
//  ProfileTabView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI
import Alamofire

enum ActiveExitAlert {
    case exitok, exiterror
}

struct ProfileTabView: View {
    
    @State private var loginInfo: LoginInfo? = nil
    @State private var isLogout: Bool = false
    @State private var isWithdraw: Bool = false
    @State private var isPasswordCheckMove: Bool = false
 
    @State private var showLogoutAlert: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var exitAlertMessage: String = ""
    @State private var activeExitAlert: ActiveExitAlert = .exitok
    
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
        NavigationStack {
            // 내 정보 수정 Button
            Button(action: {
                isPasswordCheckMove = true
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
            })
            
            NavigationLink(destination: PasswordCheckView(), isActive: $isPasswordCheckMove) {
                EmptyView()
            }
            // end of 내 정보 수정 Button
            
            // 로그아웃 Button
            Button(action: {
                // 로그아웃 버튼을 누르면 LoginInfo에 연결된 userCode 삭제
                getUserCodeFromUserDefaults()
                    
                UserDefaults.standard.removeObject(forKey: "loginInfo")
                
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
                    isLogout = true
                }), secondaryButton: .cancel(Text("아니오")))
            }
            
            NavigationLink(destination: LoginView(), isActive: $isLogout) {
                EmptyView()
            }
            // end of 로그아웃 버튼
            
            // 회원 탈퇴 Button
            Button(action: {
                deleteUserRequest()
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
                    case .exitok:
                        return Alert(title: Text("알림"), message: Text(exitAlertMessage), primaryButton: .default(Text("예"), action: {
                            isWithdraw = true
                        }), secondaryButton: .cancel(Text("아니오")))
                
                    case .exiterror:
                        return Alert(title: Text("경고"), message: Text(exitAlertMessage), dismissButton: .default(Text("확인")))
                }
                
                
                Alert(title: Text("알림"), message: Text(exitAlertMessage), primaryButton: .default(Text("예"), action: {
                    isWithdraw = true
                }), secondaryButton: .cancel(Text("아니오")))
            }
            
            NavigationLink(destination: LoginView(), isActive: $isWithdraw) {
                EmptyView()
            }
            // end of 회원 탈퇴 Button
            
            .navigationTitle("마이 페이지")
            
        }
    } // end of body
    
    // deleteUserRequest() 함수
    private func deleteUserRequest() {
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
                        
                        exitAlertMessage = value.message
                        showExitAlert = true
                        activeExitAlert = .exitok

                    } else {
                        print("회원 탈퇴 실패")
                        print("value.success: \(value.success)")

                        exitAlertMessage = value.message ?? "알 수 없는 오류가 발생했습니다."
                        showExitAlert = true
                        activeExitAlert = .exiterror
                    }
                
                case .failure(let error):
                    // 에러 응답 처리
                    print("url: \(url)")
                    exitAlertMessage = "서버 연결에 실패했습니다."
                    showExitAlert = true
                    activeExitAlert = .exiterror
                    print("Error: \(error.localizedDescription)")
            } // end of switch
        } // end of AF.request
    } // end of postData()
    
} // end of View strucet

#Preview {
    ProfileTabView()
}
