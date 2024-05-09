//
//  GachMapApp.swift
//  GachMap
//
//  Created by 원웅주 on 4/15/24.
//

import SwiftUI

@main
struct GachMapApp: App {
    var body: some Scene {
        WindowGroup {
//            SearchMainView(showLocationSearchView: Binding.constant(true))
            MapTabView()
        }
    }
}
