////
////  UserIdInjection.swift
////  GachMap
////
////  Created by 원웅주 on 4/20/24.
////
//
//import SwiftUI
//
//struct UserIdInjection: View {
//    @State private var loginInfo: LoginInfo? = nil
//    @State private var userCodeInput: String = ""
//    @State private var guestCodeInput: String = ""
//    @State private var isStudent: Bool = true
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            NavigationStack {
//                VStack {
//                    NavigationLink(destination: ProfileTabView()) {
//                        Text("Go to 내 정보 페이지")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//            }
//            
//            // userCode 입력 필드
//            TextField("Enter User Code", text: $userCodeInput)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//                .keyboardType(.numberPad)
//            
//            // guestCode 입력 필드
//            TextField("Enter Guest Code", text: $guestCodeInput)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//                .keyboardType(.numberPad)
//            
//            // 로그인 정보 저장 버튼
//            Button("Save Login Info") {
//                saveLoginInfo()
//            }
//            
//            // 로그인 정보 불러오기 버튼
//            Button("Load Login Info") {
//                loginInfo = getLoginInfo()
//            }
//            
//            Button("Delete Login Info") {
//                UserDefaults.standard.removeObject(forKey: "loginInfo")
//            }
//            
//            // 저장된 로그인 정보 표시
//            if let loginInfo = loginInfo {
//                Text("User ID: \(loginInfo.userCode ?? 0)")
//                Text("Guest Code: \(loginInfo.guestCode ?? 0)")
//            } else {
//                Text("Login Info not found")
//            }
//        }
//        .padding()
//    }
//    
//    private func getLoginInfo() -> LoginInfo? {
//        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
//           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
//            return loginInfo
//        } else {
//            print("Login Info not found in UserDefaults")
//            return nil
//        }
//    }
//    
//    private func saveLoginInfo() {
//        let userCode = Int64(userCodeInput) ?? nil
//        let guestCode = Int64(guestCodeInput) ?? nil
//        
//        let loginInfo = LoginInfo(userCode: userCode, guestCode: guestCode)
//        
//        if let encoded = try? JSONEncoder().encode(loginInfo) {
//            UserDefaults.standard.set(encoded, forKey: "loginInfo")
//        }
//    }
//}
//
//#Preview {
//    UserIdInjection()
//}
