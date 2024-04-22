//
//  PasswordCheckView.swift
//  GachMap
//
//  Created by 원웅주 on 4/19/24.
//

import SwiftUI
import Alamofire
import CryptoKit

struct PasswordCheckView: View {
    
    @State private var loginInfo: LoginInfo? = nil
    
    @State private var userId: Int64 = 0
    @State private var password: String = ""
    @State private var hashedPassword: String = ""
    @State private var isPasswordCount: Bool = false
    
    @State private var isSame: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // SHA-256 해시 생성 함수
    func sha256(_ string: String) -> String {
        if let stringData = string.data(using: .utf8) {
            let hash = SHA256.hash(data: stringData)
            return hash.compactMap { String(format: "%02x", $0) }.joined()
        }
        return ""
    }
    
    // LoginInfo에 저장된 정보 가져오기
    private func getLoginInfo() -> LoginInfo? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
            return loginInfo
        } else {
            print("Login Info not found in UserDefaults")
            return nil
        }
    }
    
    var body: some View {
        NavigationStack {
            // title
            VStack(alignment: .leading) {
                Text("개인정보 보호를 위해")
                    .font(.system(size: 30, weight: .bold))
                Text("비밀번호를 입력해주세요.")
                    .font(.system(size: 30, weight: .bold))
            }
            .padding(.leading)
            .padding(.top, 50)
            .padding(.bottom, 70)
            .frame(maxWidth: .infinity, alignment: .leading)
            // end of title
            
            // 비밀번호 입력 부분
            VStack {
                HStack {
                    Text("비밀번호 입력")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
                // .padding(.bottom, 1)
                
                SecureField("비밀번호 입력", text: $password)
                    .padding(.leading)
                    .autocapitalization(.none) // 대문자 설정 지우기
                    .disableAutocorrection(true) // 자동 수정 해제
                    .frame(height: 45)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    .onChange(of: password, perform: { value in
                        self.isPasswordCount = password.count >= 8
                        
                        if password.count > 20 {
                            password = String(password.prefix(20))
                        }
                        
                        hashedPassword = sha256(value)
                    })
                
            }
            .padding(.top, 20)
            .padding(.leading)
            .padding(.trailing)
            // end of 비밀번호 입력 부분
            
            // 비밀번호 확인 Button
            Button(action: {
                loginInfo = getLoginInfo()
                
                let userId = loginInfo?.userCode ?? 0
                
                print("userId: \(userId)")
                print("hashedPW: \(hashedPassword)")
                
                let param = UserPasswordCheckRequest(userId: userId ?? 0, password: hashedPassword)
                
                isPasswordValid(parameter: param)
                
                password = ""
            }, label: {
                HStack {
                    Text("확인")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(.white))
                }
                .frame(width: UIScreen.main.bounds.width - 200, height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(!isPasswordCount ? Color(UIColor.systemGray4) : Color.gachonBlue)
                        .shadow(radius: 5, x: 2, y: 2)
                    
                )
                .padding(.top, 20)
            })
            .disabled(!isPasswordCount)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
            
            Spacer()
            
            NavigationLink(destination: ProfileModifyView(), isActive: $isSame) {
                EmptyView()
            }
            // end of 비밀번호 확인 Button
            
            .navigationBarTitle("비밀번호 확인", displayMode: .inline)
        } // end of NavigationStack
    } // end of body
    
    // 회원 비밀번호 일치 여부 확인용 함수
    private func isPasswordValid(parameter: UserPasswordCheckRequest) {
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/check-password")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserPasswordCheckResponse.self) { response in
                // 서버 연결 여부
                switch response.result {
                case .success(let value):
                    print(value)
                    // 비밀번호 일치 여부
                    if(value.success == true) {
                        print("비밀번호 일치")
                        
                        // getUserInfoInquiry()
                        
                        isSame = true

                    } else {
                        print("비밀번호 불일치")
                        
                        alertMessage = value.message ?? "알 수 없는 오류가 발생했습니다."
                        showAlert = true
                    }
                    
                case .failure(let error):
                    // 에러 응답 처리
                    alertMessage = "서버 연결에 실패했습니다."
                    showAlert = true
                    print("Error: \(error.localizedDescription)")
                }
            }
    } // end of isPasswordValid()
    
//    // 서버에 저장된 사용자 정보 가져오기
//    private func getUserInfoInquiry() {
//        guard let url = URL(string: "https://2a93-58-121-110-235.ngrok-free.app\(userId)")
//        else {
//            print("Invalid URL")
//            return
//        }
//
//        AF.request(url, method: .get, parameters: nil, headers: nil)
//            .validate()
//            .responseDecodable(of: UserInquiryResponse.self) { response in
//                switch response.result {
//                case .success(let value):
//                    if (value.success == true) {
//                        print("회원 정보 요청 성공")
//                    } else {
//                        print("회원 정보 요청 실패")
//                    }
//                    
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//    } // end of getUserInfoInquiry()
    
} // end of View struct

#Preview {
    PasswordCheckView()
}
