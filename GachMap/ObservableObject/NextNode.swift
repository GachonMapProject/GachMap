//
//  nextNode.swift
//  GachonMap
//
//  Created by 이수현 on 4/13/24.
//

import Foundation

class NextNodeObject : ObservableObject {
    @Published var nextIndex: Int = 0
    @Published var nodeNames = [Int : [String]]()
    @Published var isARReady = false
    
    func increment() {
        nextIndex += 1
    }
}
