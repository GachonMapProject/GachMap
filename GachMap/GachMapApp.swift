//
//  GachMapApp.swift
//  GachMap
//
//  Created by 원웅주 on 4/15/24.
//

import SwiftUI

@main
struct GachMapApp: App {
    @StateObject private var globalViewModel = GlobalViewModel()
    @StateObject private var naviagionController = NavigationController()
    @StateObject private var coreLocation = CoreLocationEx()
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(globalViewModel)
                .environmentObject(naviagionController)
                .environmentObject(coreLocation)
//            ContentView()
//                .environmentObject(globalViewModel)
//                .environmentObject(coreLocation)
        }
    }
}

