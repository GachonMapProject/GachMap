//
//  GlobalViewModel.swift
//  GachMap
//
//  Created by 이수현 on 5/14/24.
//

import Foundation

class GlobalViewModel: ObservableObject {
    @Published var showSearchView: Bool = false
    @Published var showDetailView: Bool = false
    @Published var destination: String = ""
}
