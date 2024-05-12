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
    
    var body: some Scene {
        WindowGroup {
//            SearchMainView(showLocationSearchView: Binding.constant(true))
            ContentView()
                .environmentObject(globalViewModel)
        }
    }
}
