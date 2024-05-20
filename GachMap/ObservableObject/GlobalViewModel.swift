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
}
