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
                    get: { loginInfo?.userCode != nil || loginInfo?.guestCode != nil },
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
    
} // end of View

#Preview {
    PrimaryView()
}
