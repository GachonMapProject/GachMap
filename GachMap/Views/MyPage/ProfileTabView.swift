//
//  ProfileTabView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI
import Alamofire

struct ProfileTabView: View {
    
    @State private var loginInfo: LoginInfo? = nil
    @State private var isLoginViewMove: Bool = false
    @State private var isModifyInfoMove: Bool = false
    
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
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
            Button(action: {
                isModifyInfoMove = true
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
            
            NavigationLink(destination: ProfileModifyView(), isActive: $isModifyInfoMove) {
                EmptyView()
            }
            
            
            Button(action: {
                // 로그아웃 버튼을 누르면 LoginInfo에 연결된 userCode 삭제
                UserDefaults.standard.removeObject(forKey: "loginInfo")
                
                isLoginViewMove = true
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
            
            NavigationLink(destination: LoginView(), isActive: $isLoginViewMove) {
                EmptyView()
            }
            
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
            
            
            .navigationTitle("마이 페이지")
        }
    } // end of body
    
    // deleteUserRequest() 함수
    private func deleteUserRequest() {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "https://525d-58-121-110-235.ngrok-free.app/user/login")
        else {
            print("Invalid URL")
            return
        }
        
        var headers: HTTPHeaders = [:]
        
        if let userCode = getUserCodeFromUserDefaults() {
            headers["userId"] = userCode
        }
            
        // Alamofire를 사용하여 DELETE 요청 생성
        AF.request(url, method: .delete, headers: headers)
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

                    } else {
                        print("회원 탈퇴 실패")
                        print("value.success: \(value.success)")

                        alertMessage = value.message ?? "알 수 없는 오류가 발생했습니다."
                        showAlert = true
                        
                        print("showAlert: \(showAlert)")
                    }
                
                case .failure(let error):
                    // 에러 응답 처리
                alertMessage = "서버 연결에 실패했습니다."
                showAlert = true
                    print("Error: \(error.localizedDescription)")
            } // end of switch
        } // end of AF.request
    } // end of postData()
    
} // end of View strucet

#Preview {
    ProfileTabView()
}
