//
//  DashboardView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI

// 여기서 로그인 정보 받아와서 회원/비회원 구분하고 분기

struct DashboardView: View {
    
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
        let userCode = getUserCodeFromUserDefaults()
        
        if (userCode != nil) {
            // 회원 뷰
            UserDashboardView()
        } else {
            // 게스트 뷰
            GuestDashboardView()
        }
        
    } // end of body
} // end of View struct

#Preview {
  ContentView()
        .environmentObject(GlobalViewModel())
}
