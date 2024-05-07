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
    
    @State private var showEscapeAlert: Bool = false
    @Binding var showModifyView: Bool
    
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
                    .foregroundColor(.black)
                Text("비밀번호를 입력해주세요.")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.black)
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
                        .foregroundColor(.black)
                    Spacer()
                }
                // .padding(.bottom, 1)
                
                SecureField("비밀번호 입력", text: $password)
                    //.padding(.leading)
                    .autocapitalization(.none) // 대문자 설정 지우기
                    .disableAutocorrection(true) // 자동 수정 해제
                    .frame(height: 45)
                    .padding(.leading)
                    .multilineTextAlignment(.leading)
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
            
            NavigationLink(destination: ProfileModifyView(showModifyView: $showModifyView), isActive: $isSame) {
                EmptyView()
            }
            // end of 비밀번호 확인 Button
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("비밀번호 확인")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showEscapeAlert = true
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.gray)
                                    .opacity(0.7)
                                    .frame(width: 30, height: 30)
                            )
                    })
                    .padding(.trailing, 8)
                    .alert(isPresented: $showEscapeAlert) {
                        Alert(title: Text("경고"), message: Text("마이 페이지로 이동하시겠습니까?\n입력한 모든 정보가 초기화됩니다."), primaryButton: .default(Text("확인"), action: { showModifyView = false }), secondaryButton: .cancel(Text("취소"))
                        )
                    } // end of X Button
                }
                
            } // end of .toolbar
        } // end of NavigationStack
    } // end of body
    
    // 회원 비밀번호 일치 여부 확인용 함수
    private func isPasswordValid(parameter: UserPasswordCheckRequest) {
        guard let url = URL(string: "https://8eac-58-121-110-235.ngrok-free.app/user/check-password")
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
                        
                        alertMessage = "비밀번호가 일치하지 않습니다."
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
    
} // end of View struct

//#Preview {
//    ProfileTabView()
//}
