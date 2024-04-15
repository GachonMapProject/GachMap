//
//  LoginView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/15/24.
//

import SwiftUI
import Alamofire

// 빈 공간 터치 시 키보드 숨기기
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var loginStatus: Bool = false
    @State private var isFull: Bool = false
    @State private var isActive: Bool = false // 계정 정보 확인 후 일치 시 다른 뷰로 넘어갈 때 사용
    @State private var notCorrectLogin: Bool = false

    
//    private var correctUsername: String = "testid"
//    private var correctPassword: String = "testpw"
    
    private var loginInfo: LoginInfo? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo") {
            if let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
                print("Gach.Map - userID, LoginInfo Success")
                return loginInfo
            } else {
                return nil
            }
        } else {
            print("Gach.Map - LoginInfo Failure")
            return nil
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                
                Spacer()
                
                HStack() {
                    Image("gach1000")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height * 0.2)
//                        .padding(.leading)
//                        .padding(.trailing)
                    
                    //Spacer()
                }
                //.padding(.top, 150) // end ot Title HStack
                
                // Spacer()
                
                VStack() {
                    // ID 입력
                    HStack {
                        Image("gachonMark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 33, height: 24, alignment: .leading)
                            .padding(.leading)
                        
                        TextField("가천대 포털 ID", text: $username)
                            .keyboardType(.default)
                            .font(.title3)
                            .foregroundColor(Color(.gray))
                        
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
                        
                        SecureField("가천대 포털 비밀번호", text: $password)
                            .font(.title3)
                            .foregroundColor(Color(.gray))
                        
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
                            print(self.username + self.password)
                            
                            if username != "" && password != "" {
                                isFull.toggle()
                            }
                            
                            // 로그인 여부 체크 (로직 체크용)
//                            checkLogin(isUsername: username, isPassword: password)
                            
                            // LoginRequest 객체 생성
                            let param = LoginRequest(username: username, password: password)
                            
                            postData(parameter: param)
                            
                            if notCorrectLogin == false {
                                print("로그인 성공")
                                isActive = true
                            }
                        }, label: {
                            HStack {
                                Text("로그인")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(.white))
                            }
                            .alert(isPresented: $notCorrectLogin) {
                                Alert(title: Text("오류"), message: Text("아이디 또는 비밀번호가\n일치하지 않습니다."),
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
                    
                    NavigationLink(destination: UserInfoInputView(), isActive: $isActive) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: GuestInfoInputView()) {
                        Text("비회원으로 이용하기")
                            .padding(.top, 15)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    } // end of 비회원 Button
                    
                    // Spacer()
                    
                } // end of Login Section VStack
                .padding(.top, 50)
                
                Spacer()
            
                Text("로그인은 가천대 아이디로만 가능하며 \n 외부인의 회원가입은 제한됩니다.")
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                
                Spacer()
            } // end of entier VStack
            .onTapGesture {
                self.endTextEditing()
            }

        } // end of NavigationStack
    } // end of body
    
//    private func checkLogin(isUsername: String, isPassword: String) {
//        if isUsername != correctUsername || isPassword != correctPassword {
//            notCorrectLogin = true
//        }
//    } // end of checkLogin func
    
    // 기기에 저장
    private func saveLoginInfo() {
            // UserDefaults를 사용하여 사용자가 입력한 정보를 저장
       // let loginInfo = LoginInfo(userId: userId)
        if let encoded = try? JSONEncoder().encode(loginInfo) {
            UserDefaults.standard.set(encoded, forKey: "loginInfo")
        }
    }
        
    // 저장된 정보 불러오기
    private func printLoginInfo() {
            if let savedData = UserDefaults.standard.data(forKey: "loginInfo") {
                if let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
                    print("userID: \(loginInfo.userId)")
                }
            } else {
                print("Login Info not found in UserDefaults")
            }
        }
    
    // POST 함수
    private func postData(parameter : LoginRequest) {
            // API 요청을 보낼 URL 생성
            guard let url = URL(string: "https://a065-58-143-1-4.ngrok-free.app/saveTime") else {
                print("Invalid URL")
                return
            }
            
            // Alamofire를 사용하여 POST 요청 생성
            AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseString { response in
                // 에러 처리
                switch response.result {
                case .success(let value):
                    value.data
                    let a = LoginInfo(userId: userId, isStudent: true)
                    // 성공적인 응답 처리
    //                self.responseData = value
                    print("서버로 데이터 전송 성공")
                case .failure(let error):
                    // 에러 응답 처리
                    print("Error: \(error.localizedDescription)")
                } // end of switch
            } // end of AF.request
        } // end of postData()
    
} // end of View struct

#Preview {
    LoginView()
}
