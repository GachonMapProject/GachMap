//
//  ARCampusWrapperView.swift
//  GachMap
//
//  Created by 이수현 on 5/17/24.
//

import SwiftUI
import CoreLocation

struct ARCampusWrapperView: UIViewControllerRepresentable {
    let ARInfo : [ARInfo]
    @EnvironmentObject var nextNodeObject : NextNodeObject
    
    
    func makeUIViewController(context: Context) -> ARCampusController {
        return ARCampusController(ARInfo: ARInfo, nextNodeObject : nextNodeObject)
    }
    
    func updateUIViewController(_ uiViewController: ARCampusController, context: Context) {

    }
}
