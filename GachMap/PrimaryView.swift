//
//  PrimaryView.swift
//  GachMap
//
//  Created by 원웅주 on 4/15/24.
//

import SwiftUI

struct PrimaryView: View {
    @State private var loginInfo: LoginInfo? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Load Login Info") {
                    loginInfo = getLoginInfo()
                }
                
                NavigationLink(destination: ContentView(), isActive: Binding(
                    get: { loginInfo?.userCode != nil && loginInfo?.isStudent == true },
                    set: { _ in }
                )) {
                    EmptyView()
                }
                                
                NavigationLink(destination: ContentView(), isActive: Binding(
                    get: { loginInfo?.guestCode != nil && loginInfo?.isStudent == false },
                    set: { _ in }
                )) {
                    EmptyView()
                }
                                
                NavigationLink(destination: LoginView(), isActive: Binding(
                    get: { loginInfo?.userCode == nil && loginInfo?.guestCode == nil },
                    set: { _ in }
                )) {
                    EmptyView()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            // .navigationBarHidden(true)
        } // end of NavigationView
        
    } // end of body
    
    private func getLoginInfo() -> LoginInfo? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
            return loginInfo
        } else {
            print("Login Info not found in UserDefaults")
            return nil
        }
    }
    
//    private func navigateBasedOnLoginInfo() {
//        if let loginInfo = loginInfo {
//            if let _ = loginInfo.userCode {
//                // userCode가 존재한다면 StudentDash 뷰로 이동
//                print("Navigating to StudentDashBoardView")
//                // StudentDash 뷰로 이동하는 코드
//                NavigationLink(destination: DashboardView()) {
//                    EmptyView()
//                }
//            } else if let _ = loginInfo.guestCode {
//                // guestCode가 존재한다면 GuestDash 뷰로 이동
//                print("Navigating to GuestDashBoardView")
//                // GuestDash 뷰로 이동하는 코드
//                NavigationLink(destination: DashboardView()) {
//                    EmptyView()
//                }
//            } else {
//                // userCode와 guestCode 둘 다 없으면 LoginView로 이동
//                print("Navigating to LoginView")
//                // LoginView로 이동하는 코드
//                NavigationLink(destination: LoginView()) {
//                    EmptyView()
//                }
//            }
//        } else {
//            // LoginInfo 정보가 없으면 LoginView로 이동
//            print("Navigating to LoginView")
//            // LoginView로 이동하는 코드
//            NavigationLink(destination: LoginView()) {
//                EmptyView()
//            }
//        }
//    }
    
} // end of View

#Preview {
    PrimaryView()
}
