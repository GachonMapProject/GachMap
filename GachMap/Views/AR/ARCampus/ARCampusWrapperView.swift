//
//  ARCampusWrapperView.swift
//  GachMap
//
//  Created by 이수현 on 5/17/24.
//

import SwiftUI

import SwiftUI
import CoreLocation

struct ARCampusWrapperView: UIViewControllerRepresentable {
    let ARInfo : [ARInfo]
    
    
    func makeUIViewController(context: Context) -> ARCampusController {
        return ARCampusController(ARInfo: ARInfo)
    }
    
    func updateUIViewController(_ uiViewController: ARCampusController, context: Context) {

    }
}
