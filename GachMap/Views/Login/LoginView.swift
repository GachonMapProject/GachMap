//
//  LoginView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/15/24.
//

import SwiftUI
import Alamofire
import CryptoKit

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var hashedPassword: String = ""
    
    @State private var loginStatus: Bool = false
    @State private var isFull: Bool = false
    @State private var isActive: Bool = false // 계정 정보 확인 후 일치 시 다른 뷰로 넘어갈 때 사용
    @State private var notCorrectLogin: Bool = false
    
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    @State private var showSignUpView: Bool = false
    @State private var showGuestInfoInputView: Bool = false
    
    //@Binding var isLogin : Bool
    
    // SHA-256 해시 생성 함수
    func sha256(_ string: String) -> String {
        if let stringData = string.data(using: .utf8) {
            let hash = SHA256.hash(data: stringData)
            return hash.compactMap { String(format: "%02x", $0) }.joined()
        }
        return ""
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack() {
                
                Spacer()
                
                Image("gach1000")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height * 0.2)
                
                VStack() {
                    // ID 입력
                    HStack {
                        Image("gachonMark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33, height: 24, alignment: .leading)
                            .padding(.leading)
                        
                        TextField("Gach.가자 ID", text: $username)
                            .keyboardType(.asciiCapable)
                            .autocapitalization(.none) // 대문자 설정 지우기
                            .disableAutocorrection(true) // 자동 수정 해제
                            .font(.title3)
                            .foregroundColor(Color(.gray))
                            .onChange(of: username) { newValue in
                                                if newValue.contains(" ") {
                                                    self.username = String(newValue.trimmingCharacters(in: .whitespaces))
                                                }
                                            }
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 80, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.white))
                            .shadow(radius: 5, x: 2, y: 2)
                    )
                    .padding(.top, 10) // end of ID HStack
                    
                    // 비밀번호 입력
                    HStack {
                        Image("gachonMark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33, height: 24, alignment: .leading)
                            .padding(.leading)
                        
                        SecureField("Gach.가자 비밀번호", text: $password)
                            .font(.title3)
                            .autocapitalization(.none) // 대문자 설정 지우기
                            .disableAutocorrection(true) // 자동 수정 해제
                            .foregroundColor(Color(.gray))
                            .onChange(of: password, perform: { value in
    //                            if password.count > 20 {
    //                                password = String(password.prefix(20))
    //                            }
                                
                                hashedPassword = sha256(value)
                            })
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 80, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.white))
                            .shadow(radius: 5, x: 2, y: 2)
                    )
                    .padding(.top, 5) // end of PW HStack
                    
                    // 로그인 버튼
                    HStack {
                        Button(action: {
                            
                            print("입력 ID: \(self.username)")
                            print("입력 PW: \(self.password)")
                            print("hashedPW: \(self.hashedPassword)")
                            
                            if username != "" && password != "" {
                                isFull.toggle()
                            }
                            
                            // LoginRequest 객체 생성
                            let param = LoginRequest(username: username, password: hashedPassword)
                            
                            postLoginData(parameter: param)
                            
                            username = ""
                            password = ""
                        }, label: {
                            HStack {
                                Text("로그인")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(.white))
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("오류"), message: Text(alertMessage),
                                      dismissButton: .default(Text("확인")))
                            }
                            .frame(width: UIScreen.main.bounds.width - 200, height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    //.fill(Color(.systemBlue))
                                    .shadow(radius: 5, x: 2, y: 2)
                            )
                            .padding(.top, 20)
                        })
                        .disabled(username.isEmpty || password.isEmpty)
                        
                    } // end of Login Button
                    
                    NavigationLink("", isActive: $isActive) {
                        PrimaryView()
                            .navigationBarBackButtonHidden(true)
                    }
                        
                } // end of Login Section VStack
                
                // 회원가입 버튼
                Button(action: {
                    showSignUpView = true
                }, label: {
                    Text("회원가입")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                })
                .padding(.top, 15)
                .fullScreenCover(isPresented: $showSignUpView) {
                    SignUpView(showSignUpView: $showSignUpView)
                }
                
                Button(action: {
                    showGuestInfoInputView = true
                }, label: {
                    Text("비회원으로 이용하기")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                })
                .padding(.top, 5)
                .fullScreenCover(isPresented: $showGuestInfoInputView) {
                    GuestInfoInputView(showGuestInfoInputView: $showGuestInfoInputView)
                }
                
                Spacer()
            } // end of entier VStack
            //.navigationBarBackButtonHidden()
            //.onTapGesture { self.endTextEditing() }

        } // end of NavigationStack
//        .toolbar(.hidden)
//        .navigationBarBackButtonHidden()
    } // end of body
    
    // 기기에 저장
    private func setLoginInfo(userCode: Int64?, guestCode: Int64?) {
        // 기존에 저장된 LoginInfo 정보 가져오기
        var loginInfo = LoginInfo(userCode: nil, guestCode: nil)
        
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let savedLoginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
            loginInfo = savedLoginInfo
        }
        
        // userCode가 전달되었다면
        if let userCode = userCode {
            loginInfo.userCode = userCode
            
            print("userCode 저장 성공: \(userCode)")
        }
        
        // guestCode가 전달되었다면
        if let guestCode = guestCode {
            loginInfo.guestCode = guestCode
            
            print("guestCode 저장 성공: \(guestCode)")
        }
        
        // 수정된 LoginInfo를 UserDefaults에 저장
        if let encoded = try? JSONEncoder().encode(loginInfo) {
            UserDefaults.standard.set(encoded, forKey: "loginInfo")
        }
    } // end of saveLoginInfo func

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
    
    // postData 함수
    private func postLoginData(parameter : LoginRequest) {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/login")
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
                   // 로그인 성공 유무
                    if (value.success == true) {
                        print("로그인 성공")
                        print("value.success: \(value.success)")
                        
                        isActive = true
                        //isLogin = true
                        
                        if let value = value.data {
                            let userCode = Int64(value.userId)
                            let loginInfo = LoginInfo(userCode: userCode, guestCode: nil)
                            if let encoded = try? JSONEncoder().encode(loginInfo) {
                                UserDefaults.standard.set(encoded, forKey: "loginInfo")
                            }
                            print("userId 저장 성공, userId: \(userCode)")
                        }
   
                    } else {
                        print("로그인 실패")
                        print("value.message: \(value.message)")

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
    
} // end of View struct

#Preview {
    PrimaryView()
}
