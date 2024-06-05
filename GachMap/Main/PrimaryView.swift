//
//  PrimaryView.swift
//  GachMap
//
//  Created by 원웅주 on 4/15/24.
//

import SwiftUI

struct PrimaryView: View {
    @EnvironmentObject var globalViewModel: GlobalViewModel
    // isLogin

    
    var body: some View {
        if globalViewModel.isLogin {
            ContentView()
        }
        else {
            LoginView()
        }
//        if let loginInfo = globalViewModel.getLoginInfo() {
//            
//            if loginInfo.userCode != nil || loginInfo.guestCode != nil {
////                globalViewModel.isLogin = true
//                // 뭔가로 로그인을 한 상태
//                if globalViewModel.isLogin == true {
//                    ContentView()
//                }
//            }
//        } else {
//            LoginView()
//        }
//        
//        if globalViewModel.isLogin == true {
//            if let loginInfo = globalViewModel.getLoginInfo() {
//                if loginInfo.userCode != nil || loginInfo.guestCode != nil {
//                    ContentView()
//                } else {
//                    LoginView()
//                }
//            }
//        } else {
//            LoginView()
//        }
        
//        Group {
//            if let loginInfo = getLoginInfo() {
//                if loginInfo.userCode != nil || loginInfo.guestCode != nil {
//                    ContentView()
//                } else {
//                    LoginView()
//                }
//            } else {
//                LoginView()
//            }
//        }
        
        
        
        
//        NavigationStack {
//            if (loginInfo?.userCode != nil || loginInfo?.guestCode != nil) {
//                ContentView()
//            }
//            else {
//                LoginView()
//            }
//        }
//        .onAppear {
//            getLoginInfo()
//        }
        
//        NavigationView {
//            VStack {
////                if let loginInfo = getLoginInfo() {
////                    if let userCode = loginInfo.userCode {
////                        //print("userCode: \(userCode)")
////                    }
////                    
////                    if let guestCode = loginInfo.guestCode {
////                        //print("guestCode: \(guestCode)")
////                    }
////
////                }
//                
//                // 뷰를 분기할 때 userCode부터 보기
//                if (loginInfo?.userCode != nil || loginInfo?.guestCode != nil) {
//                    ContentView()
//                }
//                else {
//                    LoginView()
//                }
//                
////                NavigationLink(destination: ContentView(), isActive: Binding(
////                    get: { loginInfo?.userCode != nil || loginInfo?.guestCode != nil },
////                    set: { _ in }
////                )) {
////                    EmptyView()
////                }
////                                
////                NavigationLink(destination: LoginView(), isActive: Binding(
////                    get: { loginInfo?.userCode == nil && loginInfo?.guestCode == nil },
////                    set: { _ in }
////                )) {
////                    EmptyView()
////                }
//            }
//            // .navigationBarBackButtonHidden()
//            // .navigationBarHidden(true)
//        } // end of NavigationView
        
    } // end of body
    
//    private func getLoginInfo() -> LoginInfo? {
//        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
//           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
//            print("loginInfo.userCode: \(String(describing: loginInfo.userCode))")
//            print("loginInfo.guestCode: \(String(describing: loginInfo.guestCode))")
//            return loginInfo
//        } else {
//            print("Login Info not found in UserDefaults")
//            return nil
//        }
//    }
    
} // end of View

#Preview {
    PrimaryView()
        .environmentObject(GlobalViewModel())
        .environmentObject(NavigationController())
        .environmentObject(CoreLocationEx())
}
