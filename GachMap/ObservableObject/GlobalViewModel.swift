//
//  GlobalViewModel.swift
//  GachMap
//
//  Created by 이수현 on 5/14/24.
//

import Foundation

class GlobalViewModel: ObservableObject {
    @Published var showSearchView: Bool = false
    @Published var selectedTab: Int = 1
    @Published var showSheet: Bool = false
    
    @Published var showDetailView: Bool = false
    @Published var destination: String = ""
    
    @Published var isLogin: Bool = false
    
    @Published var showUsageListView: Bool = false

    @Published var destinationId : Int = 0
    
    // ARCaompusView
    @Published var isARStart : Bool = false
    
    // 행사 디테일 -> 목적지 설정
    @Published var selectedDestination = false
    @Published var latitude : Double = 0.0
    @Published var longitude : Double = 0.0
    @Published var altitude : Double = 0.0  
    
    func getLoginInfo() -> LoginInfo? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
            print("loginInfo.userCode: \(String(describing: loginInfo.userCode))")
            print("loginInfo.guestCode: \(String(describing: loginInfo.guestCode))")
            return loginInfo
        } else {
            print("Login Info not found in UserDefaults")
            return nil
        }
    }
}
